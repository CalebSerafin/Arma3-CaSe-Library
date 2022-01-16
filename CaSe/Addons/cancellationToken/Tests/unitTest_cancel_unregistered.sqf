#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","cancel-unregistered"]];

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
    Dev_onCancelledOut = nil;
    private _emptyOnCancelled = [];
    private _onCancelled = [{ Dev_onCancelledOut = "Hello " + _this }, "World"];

    //// Assert
    private _cancellationToken = [] call FNCP(new);
    _cancellationToken #CTOKEN_I_REGISTERED_CODE pushBack _emptyOnCancelled;  // Do not directly set properties in real code! Not easily maintainable.
    _cancellationToken #CTOKEN_I_REGISTERED_CODE pushBack _onCancelled;

    [_cancellationToken] call FNCP(cancel);

    private _passedTest = Dev_onCancelledOut isEqualTo "Hello World";
    private _checkArray = [GETP(typeRef), true, scriptNull, [ _emptyOnCancelled ]];
    for "_i" from 0 to 3 do {
        if (_cancellationToken #_i isNotEqualTo _checkArray#_i) exitWith { _passedTest = false };
    };

    if (_passedTest) then {
        [_reporterContext, "Test Passed"] call _fnc_reporter;
    } else {
        [_reporterContext, "Test Failed"] call _fnc_reporter;
    };

    //// Clean Up
    Dev_onCancelledOut = nil;
    call compileScript [TEST_DIRECTORY_PATH+"unitTestUtility_revertInit.sqf"];
    call FNCP(init);
    Dev_unitTestInProgress = nil;
};
"Unit Test Started";
