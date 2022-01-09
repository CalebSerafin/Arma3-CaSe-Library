#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","Garbage Collector"],["_componentNameShort","GC"]];

if (!isNil {Dev_unitTestInProgress}) exitWith {
    LOG_ERROR("Previous unit test still running");
    "Previous unit test still running";
};
Dev_unitTestInProgress = true;
Dev_shortFpsStressTestHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];

    private _fpsLog = [];
    private _fnc_logFPS = {
        params ["_group","_details"];
        _fpsLog pushBack [serverTime, _group, _details, diag_fps, (count _keyCache_DB) toFixed 0];
        [_reporterContext, "Short FPS Stress Test<br/>" + _group + "<br/>" + _details] call _fnc_reporter
    };

    "confirmUnitTest" call FNCP(init);
    private _keyCache_GC_generations = GETP(CaSe_keyCache_GC_generations);
    _keyCache_GC_generations #0 set [2,10];
    _keyCache_GC_generations #1 set [2,30];
    _keyCache_GC_generations #2 set [2,90];

    private _keyCache_DB = GETP(DB);
    ["GivingGCsIdleTime", ""] call _fnc_logFPS;

    "confirmUnitTest" call CaSe_fnc_keyCache_startGarbageCollectors;
    // Ensure that all GCs are in idle state.
    uiSleep 10;
    ["BaselineTaken", ""] call _fnc_logFPS;


    private _amountOfMillionStressItems = 5;
    private _stressItemTotal = "/"+ (_amountOfMillionStressItems toFixed 1) +" Million";
    private _randomTTLsWeighted = [5,0.75, 15,0.20, 45,0.05];
    for "_j" from 0 to 10*_amountOfMillionStressItems-1 step 1 do {
        for "_k" from 0 to 100000-1 step 10000 do {
            for "_l" from _k to _k + 10000-1 do {
                private _name = (str _j) + (_l toFixed 0);
                private _TTL = selectRandomWeighted _randomTTLsWeighted;
                _keyCache_DB set [_name, [nil,_TTL,serverTime + _TTL, nil]];
                _name call CaSe_fnc_keyCache_registerForGC;
            };
            //uiSleep 0.01; Processed at max speed anyway.
        };
        ["StressItem", (_j/10 toFixed 1)+_stressItemTotal] call _fnc_logFPS;
    };

    private _timeResolution = 5;
    private _waitTime = 80;
    private _endTime = serverTime + _waitTime;
    waitUntil {
        ["PostStressWatch", ((_endTime - serverTime) toFixed 0) + " sec remaining"] call _fnc_logFPS;
        _endTime <= serverTime || {uiSleep _timeResolution; false};
    };
    //// Assert
    private _passedTest = count _keyCache_DB == 0;
    if (_passedTest) then {
        ["TestPassed","Data copied to clipboard"] call _fnc_logFPS;
    } else {
        ["TestFailed","Data copied to clipboard"] call _fnc_logFPS;
    };
    copyToClipboard str _fpsLog;

    //// Clean Up
    call compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"unitTestUtility_revertInit.sqf"];
    call compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"unitTestUtility_revertStartGarbageCollectors.sqf"];
    Dev_unitTestInProgress = nil;
};
"Unit Test Started";
