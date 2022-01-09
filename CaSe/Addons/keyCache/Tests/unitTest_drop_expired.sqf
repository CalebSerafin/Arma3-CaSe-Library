#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","Drop-Expired"]];

if (!isNil {Dev_unitTestInProgress}) exitWith {
    LOG_ERROR("Previous unit test still running");
    "Previous unit test still running";
};
Dev_unitTestInProgress = true;
Dev_testHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];
    "confirmUnitTest" call FNCP(init);
    private _keyCache_DB = GETP(DB);

    Dev_keyCacheDropUnitTest_expired_onDisposeRan = false;

    _keyCache_DB set ["SomeTestVariable",["SomeAnswerVariable",100,serverTime,{Dev_keyCacheDropUnitTest_expired_onDisposeRan = true}]];
    [_reporterContext, "Test Started"] call _fnc_reporter;

    //// Assert
    "SomeTestVariable" call CaSe_fnc_keyCache_drop;

    private _passedTest = !("SomeTestVariable" in _keyCache_DB);
    uiSleep 1;
    _passedTest = _passedTest && Dev_keyCacheDropUnitTest_expired_onDisposeRan;

    if (_passedTest) then {
        [_reporterContext, "Test Passed"] call _fnc_reporter;
    } else {
        [_reporterContext, "Test Failed"] call _fnc_reporter;
    };

    //// Clean Up
    Dev_keyCacheDropUnitTest_expired_onDisposeRan = nil;
    call compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"unitTestUtility_revertInit.sqf"];
    Dev_unitTestInProgress = nil;
};
"Unit Test Started";
