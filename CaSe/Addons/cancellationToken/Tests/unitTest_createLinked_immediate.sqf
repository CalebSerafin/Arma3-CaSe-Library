#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","createLinked-Immediate"]];

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
    private _ctMasters = [];
    _ctMasters resize 7;
    _ctMasters = _ctMasters apply {[] call FNCP(new)};

    [_reporterContext, "Test Started"] call _fnc_reporter;

    //// Assert
    [_ctMasters #3] call FNCP(cancel);
    private _ctSlave = _ctMasters call FNCP(createLinked);
    _passedTest = _passedTest && (_ctSlave #CTOKEN_I_IS_CANCELLED);

    {
        private _noRegistration = count (_x #CTOKEN_I_REGISTERED_CODE) == 0;
        _passedTest = _passedTest && _noRegistration;
    } forEach _ctMasters;

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
