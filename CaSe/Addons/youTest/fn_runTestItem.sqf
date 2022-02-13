/*
Maintainer: Caleb Serafin
    Runs code as a test.

    provides access to reports through:
    _statusTextToken set [0,"Text"];
    _progressToken set [0, 0.5];
    _etaToken set [1, time + 5];

Arguments:
    <TestItem> | <typeTestCollection> | <typeTestFolder> Will recursively run any of the passed test types.

Return Value:
    <BOOLEAN> If the test passed

Scope: Any, Local Effect.
Environment: Scheduled
Public: Yes

Example:
    [] call CaSe_fnc_youTest_loadTestsFromConfig;
    [CaSe_youTest_testRoot] spawn CaSe_fnc_youTest_runTestItem;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_testItem", [], [ [] ], [3]]
];

private _typeTestItem = GETP(typeTestItem);
private _typeTestCollection = GETP(typeTestCollection);
private _typeTestFolder = GETP(typeTestFolder);


private _fnc_countItems = {
    if !(_this isEqualTypeParams [[],"",nil]) exitWith {
        private _stringed = str _this;
        LOG_ERROR("Unexpected _fnc_countItems argument ("+_stringed+")")
    };
    params [
        ["_type", [], [ [] ], [1]],
        "_name",
        "_data"
    ];
    if (_type isEqualTo _typeTestItem) exitWith { 1 };
    if (_type isEqualTo _typeTestCollection || _type isEqualTo _typeTestFolder) exitWith {
        private _count = 0;
        {
            _count = _count + (_x call _fnc_countItems);
        } forEach _data;
        _count
    };
    0
};
private _totalItems = _testItem call _fnc_countItems;
private _processedItems = 0;

private _totalProgressToken = [0];
private _hierarchyToken = [];
private _currentItemsToken = [0,[]];
private _previousResultTextToken = [""];
private _displayNameToken = [""];

private _statusTextToken = [""];
private _progressToken = [-1];
private _etaToken = [time, -1];

private _progressTokens = createHashMap;
_progressTokens set ["_statusTextToken", _statusTextToken];
_progressTokens set ["_progressToken", _progressToken];
_progressTokens set ["_etaToken", _etaToken];

private _fnc_resetProgressTokens = {
    _statusTextToken set [0, ""];
    _progressToken set [0, -1];
    _etaToken set [0, time];
    _etaToken set [1, -1];
};

private _fnc_runItem = {
    params [
        ["_type", [], [ [] ], [1]],
        "_name",
        "_data"
    ];
    if (_type isEqualTo _typeTestItem) exitWith {
        _this call _fnc_runTest;
    };
    if (_type isEqualTo _typeTestCollection) exitWith {
        _this call _fnc_runTestCollection;
    };
    if (_type isEqualTo _typeTestFolder) exitWith {
        _this call _fnc_runFolder;
    };
    LOG_ERROR("RunItem, Unknown typeRef.")
    false
};
private _fnc_runTest = {
    params [
        ["_type", [], [ [] ], [1]],
        "_name",
        "_code"
    ];
    _displayNameToken set [0, _name];
    [_code, _progressTokens] call CaSe_fnc_youTest_runTestCode params ["_passedTest", "_return"];
    [] call _fnc_resetProgressTokens;

    if (_passedTest) then {
        private _hintText = (
            "<t size='1.2' >Result of: " + _name + "<br/><br/>" +
            "Test Passed!" + "</t><br/><br/>"
        );
        _previousResultTextToken set [0, _hintText];
        LOG_INFO("Test Passed: " + _name);
        true
    } else {
        private _hintText = (
            "<t size='1.2' >Result of: " + _name + "<br/><br/>" +
            "Test Failed:" + _return + "</t><br/><br/>"
        );
        _previousResultTextToken set [0, _hintText];
        LOG_WARNING("Test Failed: " + _name + ", " + _return);
        false
    };
    _processedItems = _processedItems +1;
    _totalProgressToken set [0, _processedItems/_totalItems];
    _passedTest;
};

private _fnc_runTestCollection = {
    params [
        ["_type", [], [ [] ], [1]],
        "_name",
        "_collection"
    ];
    private _hierarchyIndex = _hierarchyToken pushBack _name;
    private _currentItems = _collection apply { [_x#1, false] };
    _currentItemsToken set [1, _currentItems];
    private _return = {
        _currentItemsToken set [0, _forEachIndex];
        private _passed = _x call _fnc_runItem;
        _currentItems #_forEachIndex set [1, _passed];

        if !(_passed) exitWith { false };
        true
    } forEach _collection;
    _hierarchyToken deleteAt _hierarchyIndex;
    _return;
};

private _fnc_runFolder = {
    params [
        ["_type", [], [ [] ], [1]],
        "_name",
        "_folder"
    ];
    private _hierarchyIndex = _hierarchyToken pushBack _name;
    private _currentItems = _folder apply { [_x#1, false] };
    _currentItemsToken set [1, _currentItems];
    {
        _currentItemsToken set [0, _forEachIndex];
        private _passed = _x call _fnc_runItem;
        _currentItems #_forEachIndex set [1, _passed];
    } forEach _folder;
    _hierarchyToken deleteAt _hierarchyIndex;
    true
};



private _fnc_renderHierarchy = {
    params ["_hierarchyToken","_cacheHM"];

    private _hierarchyHash = hashValue _hierarchyToken;
    if (_hierarchyHash isEqualTo (_cacheHM getOrDefault ["hash",""])) exitWith {
        _cacheHM get "string"
    };
    _cacheHM set ["hash", _hierarchyHash];

    private _string = "<t size='1.2' align='left'>.- " + (_hierarchyToken joinString "<br/>|- ") + "</t><br/>";
    _cacheHM set ["string", _string];
    _string
};
private _fnc_renderCurrentItems = {
    params ["_currentItemsToken","_cacheHM"];

    private _currentItemsHash = hashValue _currentItemsToken;
    if (_currentItemsHash isEqualTo (_cacheHM getOrDefault ["hash",""])) exitWith {
        _cacheHM get "string"
    };
    _cacheHM set ["hash", _currentItemsHash];

    _currentItemsToken params ["_index","_items"];
    _index = (count _items) min _index;
    _printableItems = [];
    private _passColours = ["#d86a77", "#77d86a"];  // Red, Green
    private _passSymbols = [" F ", " P "];
    for "_i" from 0 to _index -1 do {
        (_items #_i) params ["_name","_passed"];
        private _colour = _passColours select _passed;
        private _symbol = _passSymbols select _passed;
        _printableItems pushBack ("<t color='"+_colour+"'>"+_symbol+_name+"</t>");
    };
    if (_index < count _items) then {
        _printableItems pushBack ("<t color='#d8cb6a'>-&gt; "+(_items #_index #0)+"</t>");  // Yellow
    };
    for "_i" from _index+1 to count _items -1 do {
        (_items #_i) params ["_name","_passed"];
        _printableItems pushBack (_items #_i #0);
    };

    private _string = "<t size='1.2' align='left' color='#d8d8d8'>"+(_printableItems joinString "<br/>") + "</t><br/>";  // Default Light Grey
    _cacheHM set ["string", _string];
    _string
};
private _fnc_renderDisplayName = {
    params ["_displayNameToken"];
    _displayNameToken params [ ["_displayName", "", [""]] ];
    "<t size='1.2' align='center' >Test: " + _displayName + "</t><br/><br/>"
};
private _fnc_renderStaticText = {
    params ["_statusTextToken"];
    _statusTextToken params [ ["_statusText", "", [""]] ];
    if (count _statusText == 0) exitWith { "" };
    _statusText + "<br/>";
};
private _fnc_renderProgressBar = {
    params ["_progressToken","_cacheStore"];
    _progressToken params [ ["_progress",-1, [0]] ];

    if (_progress < 0) exitWith { "" };
    private _ratioText = "<t size='1.2' align='center' color='#ffffff'>" + ((_progress min 1) * 100 toFixed 2) + "%</t>";

    _cacheStore set [0,_progress];
    _cacheStore set [1,time];
    _ratioText + "<br/>" + (_cacheStore call FNCP(renderProgressBar)) + "<br/>";
};
private _fnc_renderETABar = {
    params ["_etaToken","_cacheStore"];
    _etaToken params [ ["_start",-1], ["_end",-1] ];

    if (_end < time || _end <= 0) exitWith {""};
    private _etaText = "<t size='1.2' align='center' color='#ffffff'>" + ((_end - time) toFixed 0) + " Seconds Left</t>";
    private _progress = (time - _start) / (_end - _start);

    _cacheStore set [0,_progress];
    _cacheStore set [1,time];
    _etaText + "<br/>" + (_cacheStore call FNCP(renderProgressBar)) + "<br/>";
};


[
    [ _fnc_renderProgressBar, [_totalProgressToken, [-1, time, 1.5, 48, "|", 0.5, 2]] ],
    "<t size='1.2' align='center' >Hierarchy:</t><br/>",
    [ _fnc_renderHierarchy, [_hierarchyToken, createHashMap] ],
    "<t size='1.2' align='center' >Items:</t><br/>",
    [ _fnc_renderCurrentItems, [_currentItemsToken, createHashMap] ],
    [ _fnc_renderStaticText, [_previousResultTextToken] ],
    [ _fnc_renderDisplayName, [_displayNameToken] ],
    [ _fnc_renderStaticText, [_statusTextToken] ],
    [ _fnc_renderProgressBar, [_progressToken, [-1, time, 1.5, 48, "|", 0.5, 2]] ],
    [ _fnc_renderETABar, [_etaToken, [-1, time, 1.5, 48, "|", 0.5, 2]] ]
] call FNCP(codeHintSet);

private _testHierarchy = _testItem call _fnc_runItem;
