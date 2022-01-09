#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [UINTTOHEX_TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","Drop-Expired"]];

if (!isNil {Dev_unitTestInProgress}) exitWith {
    LOG_ERROR("Previous unit test still running");
    "Previous unit test still running";
};
Dev_unitTestInProgress = true;
Dev_testHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];
    call FNCP(init);

    private _namedTests = [
        [" 4 Bits", CaSe_uintToHex_b16LookupTable   # 0x0   isEqualTo "0"     ],
        [" 8 Bits", CaSe_uintToHex_b16e2LookupTable # 0xb4  isEqualTo "b4"    ],
        ["12 Bits", 0xaaf       call CaSe_fnc_uintToHex_u12 isEqualTo "aaf"   ],
        ["16 Bits", 0xdead      call CaSe_fnc_uintToHex_u16 isEqualTo "dead"  ],
        ["20 Bits", 0xca1eb     call CaSe_fnc_uintToHex_u20 isEqualTo "ca1eb" ],
        ["24 Bits", 0xffffff    call CaSe_fnc_uintToHex_u24 isEqualTo "ffffff"]
    ];

    [_reporterContext, "Test Started"] call _fnc_reporter;

    //// Assert
    private _passedTest = _namedTests findIf {!(_x#1)} == -1;

    if (_passedTest) then {
        [_reporterContext, "All Tests Passed"] call _fnc_reporter;
    } else {
        private _failedTests = _namedTests select {isNil {_x#1} || !(_x#1)} apply {_x#0};
        _failedTests = _failedTests joinString "<br/>";
        [_reporterContext, "Some Tests Failed:<br/>"+_failedTests] call _fnc_reporter;
    };

    //// Clean Up
    call compileScript [UINTTOHEX_TEST_DIRECTORY_PATH+"unitTestUtility_revertInit.sqf"];
    Dev_unitTestInProgress = nil;
};
"Unit Test Started";
