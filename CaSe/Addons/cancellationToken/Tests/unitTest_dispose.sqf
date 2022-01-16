#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","dispose"]];

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
    private _ctRunning = [] call FNCP(new);
    private _ctDelay = [] call FNCP(new);

    private _timerHandle = [] spawn {uiSleep 1};
    _ctDelay set [CTOKEN_I_TIMER_HANDLE, _timerHandle];  // Do not directly set properties in real code! Not easily maintainable.

    [_ctRunning] call FNCP(dispose);
    [_ctDelay] call FNCP(dispose);

    private _passedTest = _ctRunning isEqualTo [] && _ctDelay isEqualTo [] && scriptDone _timerHandle;
    if (_passedTest) then {
        [_reporterContext, "Test Passed"] call _fnc_reporter;
    } else {
        [_reporterContext, "Test Failed"] call _fnc_reporter;
    };

    //// Clean Up
    call compileScript [TEST_DIRECTORY_PATH+"unitTestUtility_revertInit.sqf"];
    call FNCP(init);
    Dev_unitTestInProgress = nil;
};
"Unit Test Started";
