#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","Refresh"]];

if (!isNil {Dev_unitTestInProgress}) exitWith {
    LOG_ERROR("Previous unit test still running");
    "Previous unit test still running";
};
Dev_unitTestInProgress = true;
Dev_testHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];
    "confirmUnitTest" call CaSe_fnc_keyCache_init;
    private _keyCache_DB = GETP(DB);
    _keyCache_DB set ["SomeTestVariable",["SomeAnswerVariable",300,serverTime + 100,nil]];
    [_reporterContext, "Test Started"] call _fnc_reporter;

    //// Assert
    "SomeTestVariable" call CaSe_fnc_keyCache_refresh;
    private _expiry = (_keyCache_DB get "SomeTestVariable")#2;
    private _passedTest = (_expiry > serverTime + 200) && (_expiry < serverTime + 400);
    if (_passedTest) then {
        [_reporterContext, "Test Passed"] call _fnc_reporter;
    } else {
        [_reporterContext, "Test Failed"] call _fnc_reporter;
    };

    //// Clean Up
    call compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"unitTestUtility_revertInit.sqf"];
    Dev_unitTestInProgress = nil;
};
"Unit Test Started";
