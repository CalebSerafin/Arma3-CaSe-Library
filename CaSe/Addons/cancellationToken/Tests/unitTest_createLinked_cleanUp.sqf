#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","createLinked-CleanUp"]];

if (!isNil {Dev_unitTestInProgress}) exitWith {
    LOG_ERROR("Previous unit test still running");
    "Previous unit test still running";
};
Dev_unitTestInProgress = true;
Dev_testHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];

    call FNCP(init);
    private _ctMasters = [];
    _ctMasters resize 7;
    _ctMasters = _ctMasters apply {[] call FNCP(new)};

    [_reporterContext, "Test Started"] call _fnc_reporter;

    //// Assert
    private _ctSlave = _ctMasters call FNCP(createLinked);
    [_ctMasters #3] call FNCP(cancel);

    private _passedTest = true;
    {
        private _cleanedUp = (_x #CTOKEN_I_REGISTERED_CODE) findIf {count _x > 0} == -1;
        _passedTest = _passedTest && _cleanedUp;
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
