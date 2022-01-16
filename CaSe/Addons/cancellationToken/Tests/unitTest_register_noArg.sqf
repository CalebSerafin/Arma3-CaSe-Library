#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","register-NoArg"]];

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

    //// Assert
    private _ctNoArg = [] call FNCP(new);
    [_ctNoArg, _fnc_dummy] call FNCP(register);

    private _passedTest = true;
    private _checkArrayNoArg = [GETP(typeRef), false, scriptNull, [ [_fnc_dummy, nil] ]];
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
