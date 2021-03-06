#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","Has-Unexpired"]];

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
    _keyCache_DB set ["SomeTestVariable",["SomeAnswerVariable",1e39,1e39,nil]];
    [_reporterContext, "Test Started"] call _fnc_reporter;

    //// Assert
    private _passedTest = "SomeTestVariable" call CaSe_fnc_keyCache_has && !("SomeUnknownVariable" call CaSe_fnc_keyCache_has);
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
