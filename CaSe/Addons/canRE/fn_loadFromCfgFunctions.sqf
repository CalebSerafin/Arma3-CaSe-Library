/*
Maintainer: Caleb Serafin
    Populates the lookup table from a specified CfgFunction entry.
    Base config can be either configFile, campaignConfigFile, missionConfigFile.
    Include class can either be CfgFunctions, Tag, Category, Function
    Recommend migrating production code to use CfgRemoteExec.
    Note: Disabled by default, requires a macro change to enable.

Arguments:
    <CONFIG> Include class, all sub-entries are added to CfgRemoteExec.
    <BOOLEAN> Can target server. Default = true
    <BOOLEAN> Can target client. Default = true

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes

Example:
    // All Default Functions
    (configFile >> "CfgFunctions") call CaSe_fnc_canRE_loadFromCfgFunctions;
    // Functions
    (missionConfigFile >> "CfgFunctions") call CaSe_fnc_canRE_loadFromCfgFunctions;
    // Tag
    (missionConfigFile >> "CfgFunctions" >> "A3A") call CaSe_fnc_canRE_loadFromCfgFunctions;
    // Category
    (missionConfigFile >> "CfgFunctions" >> "A3A" >> "CustomHint") call CaSe_fnc_canRE_loadFromCfgFunctions;
    // Specific
    (missionConfigFile >> "CfgFunctions" >> "A3A" >> "CustomHint" >> "showHint") call CaSe_fnc_canRE_loadFromCfgFunctions;
*/
#include "config.hpp"
#ifndef ENABLE_LOAD_FROM_CFGFUNCTIONS
    if (true) exitWith { LOG_ERROR("Function is Disabled. Enable by defining ENABLE_LOAD_FROM_CFGFUNCTIONS in canRE's config.hpp") };
#endif
FIX_LINE_NUMBERS

params [
    ["_startBase", missionConfigFile, [missionConfigFile]],
    ["_canTargetServer", true, [true]],
    ["_canTargetClient", true, [true]]
];

private _fnc_printConfigPath = {
    params ["_config"];
    private _hierarchy = configHierarchy _config;
    if (count _hierarchy == 0) exitWith { "" };
    private _root = _hierarchy deleteAt 0;
    private _rootName = [configName _root, "configFile", "campaignConfigFile", "missionConfigFile"] # (([configFile, campaignConfigFile, missionConfigFile] find _root) + 1);
    ([_rootName] + (_hierarchy apply { str configName _x })) joinString " >> ";
};

private _hierarchy = configHierarchy _startBase;
if (count _hierarchy < 2) exitWith {
    LOG_ERROR('Provided config class not specific enough. Provided: ('+(_startBase call _fnc_printConfigPath)+') Expected Example: (config >> "CfgFunctions")');
};

if (count _hierarchy > 5) exitWith {
    LOG_ERROR('Provided config class too long. Provided: ('+(_startBase call _fnc_printConfigPath)+') Max Length Example: (config >> "CfgFunctions" >> "Tag" >> "Category" >> "Function")');
};

private _acceptedRoots = [configFile >> "CfgFunctions", campaignConfigFile >> "CfgFunctions", missionConfigFile >> "CfgFunctions"] apply { configHierarchy _x };
if !((_hierarchy select [0,2]) in _acceptedRoots) exitWith {
    LOG_ERROR('Provided config root not supported. Provided: ('+(_startBase call _fnc_printConfigPath)+') Expected Example: (config >> "CfgFunctions")');
};


private _tagFunctions = []; // KeyPairs of [<STRING> Tag, <ARRAY<STRING>> Functions];
switch (count _hierarchy) do {
    case 2: {
        {
            private _tagProperty = _x >> "tag";
            private _tag = if (isText _tagProperty) then {getText _tagProperty} else {configName _x};

            private _categories = "true" configClasses _x;
            private _functions = flatten (_categories apply { "true" configClasses _x apply {configName _x} });
            _tagFunctions pushBack [_tag, _functions];
        } forEach ("true" configClasses _startBase);
    };
    case 3: {
        private _tagProperty = _startBase >> "tag";
        private _tag = if (isText _tagProperty) then {getText _tagProperty} else {configName _startBase};

        private _categories = "true" configClasses _startBase;
        private _functions = flatten (_categories apply { "true" configClasses _x apply {configName _x} });
        _tagFunctions pushBack [_tag, _functions];
    };
    case 4: {
        private _tagClass = configHierarchy _startBase #2;
        private _tagProperty = _tagClass >> "tag";
        private _tag = if (isText _tagProperty) then {getText _tagProperty} else {configName _tagClass};

        private _functions = "true" configClasses _startBase apply { configName _x };
        _tagFunctions pushBack [_tag, _functions];
    };
    case 5: {
        private _tagClass = configHierarchy _startBase #2;
        private _tagProperty = _tagClass >> "tag";
        private _tag = if (isText _tagProperty) then {getText _tagProperty} else {configName _tagClass};

        private _function = configName _startBase;
        _tagFunctions pushBack [_tag, [_function]];
    };
};


private _fullyQualifiedFunctions = flatten (_tagFunctions apply {
    _x params ["_tag","_functions"];
    _functions apply { _tag + "_fnc_" + _x };
});


if (_canTargetServer) then {
    private _targetServerList = GETP(targetServerList);
    {
        _targetServerList set [_x, true];
    } forEach _fullyQualifiedFunctions;
};
if (_canTargetClient) then {
    private _targetClientList = GETP(targetClientList);
    {
        _targetClientList set [_x, true];
    } forEach _fullyQualifiedFunctions;
};
