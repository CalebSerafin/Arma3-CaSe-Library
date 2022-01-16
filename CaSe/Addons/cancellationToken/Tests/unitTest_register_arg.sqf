#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","register-Arg"]];

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
    private _fnc_dummy = { systemChat "Hello World" };
    private _dummyArg = 420;

    //// Assert
    private _ctArg = [] call FNCP(new);
    [_ctArg, _fnc_dummy, _dummyArg] call FNCP(register);

    private _passedTest = true;
    private _checkArrayArg = [GETP(typeRef), false, scriptNull, [ [_fnc_dummy, _dummyArg] ]];
    for "_i" from 0 to 3 do {
        if (_ctArg #_i isNotEqualTo _checkArray#_i) exitWith { _passedTest = false };
    };

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
