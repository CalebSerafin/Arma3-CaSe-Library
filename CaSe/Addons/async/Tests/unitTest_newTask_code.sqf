#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [ASYNC_TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","newTask-Code"]];

if (!isNil {Dev_unitTestInProgress}) exitWith {
    LOG_ERROR("Previous unit test still running");
    "Previous unit test still running";
};
Dev_unitTestInProgress = true;
Dev_testHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];

    call FNCP(init);
    [_reporterContext, "Test Started"] call _fnc_reporter;

    //// Assert
    private _asyncTask = [{ _this }, "Hello"] call FNCP(newTask);
    uiSleep 1;

    private _passedTest = true;
    private _checkArray = [GETP(typeRef), true, "Hello", []];
    for "_i" from 0 to 3 do {
        if (_asyncTask #_i isNotEqualTo _checkArray#_i) exitWith { _passedTest = false };
    };

    if (_passedTest) then {
        [_reporterContext, "Test Passed"] call _fnc_reporter;
    } else {
        [_reporterContext, "Test Failed"] call _fnc_reporter;
    };

    //// Clean Up
    call compileScript [ASYNC_TEST_DIRECTORY_PATH+"unitTestUtility_revertInit.sqf"];
    Dev_unitTestInProgress = nil;
};
"Unit Test Started";
