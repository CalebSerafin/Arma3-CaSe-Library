#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","cancelAfter-ResetTimer"]];

if (!isNil {Dev_unitTestInProgress}) exitWith {
    LOG_ERROR("Previous unit test still running");
    "Previous unit test still running";
};
Dev_unitTestInProgress = true;
Dev_testHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];

    call FNCP(init);
    private _passedTest = true;
    private _cancellationToken = [0.25] call FNCP(new);

    [_reporterContext, "Test Started"] call _fnc_reporter;

    //// Assert
    [_cancellationToken, 1] call FNCP(cancelAfter);
    uiSleep 0.1;
    _passedTest = _passedTest && !(_cancellationToken #CTOKEN_I_IS_CANCELLED);
    uiSleep 1;
    _passedTest = _passedTest && (_cancellationToken #CTOKEN_I_IS_CANCELLED);

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
