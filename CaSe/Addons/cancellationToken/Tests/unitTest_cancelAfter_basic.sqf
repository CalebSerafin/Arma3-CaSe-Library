#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","cancelAfter-Basic"]];

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
    Dev_onCancelledOut = nil;
    private _onCancelled = [{ Dev_onCancelledOut = "Hello " + _this }, "World"];

    private _cancellationToken = [] call FNCP(new);
    _cancellationToken #CTOKEN_I_REGISTERED_CODE pushBack _onCancelled;  // Do not directly set properties in real code! Not easily maintainable.

    [_reporterContext, "Test Started"] call _fnc_reporter;

    //// Assert
    [_cancellationToken,0.75] call FNCP(cancelAfter);
    uiSleep 0.5;
    _passedTest = _passedTest && !(_cancellationToken #CTOKEN_I_IS_CANCELLED);
    uiSleep 0.5;
    _passedTest = _passedTest && (_cancellationToken #CTOKEN_I_IS_CANCELLED) && Dev_onCancelledOut == "Hello World";

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
