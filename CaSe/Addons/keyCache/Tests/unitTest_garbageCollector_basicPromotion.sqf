#include "..\config.hpp"
FIX_LINE_NUMBERS

private _fnc_reporter = compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","Garbage Collector"],["_componentNameShort","GC"]];

[_reporterContext,"Test Report!"] call _fnc_reporter;

if (!isNil {Dev_unitTestInProgress}) exitWith {
    LOG_ERROR("Previous unit test still running");
    "Previous unit test still running";
};
Dev_unitTestInProgress = true;
Dev_basicPromotionTestHandle = [_fnc_reporter,_reporterContext] spawn {
    //// Setup
    params ["_fnc_reporter","_reporterContext"];
    "confirmUnitTest" call CaSe_fnc_keyCache_init;

    private _keyCache_DB = GETP(DB);
    _keyCache_DB set ["Test123", [
        "value",
        100,
        serverTime + 100,
        nil
    ]];

    private _keyCache_GC_gen0NewestBucket = [];
    SETP(GC_gen0NewestBucket, _keyCache_GC_gen0NewestBucket);
    private _gen1TopBucket = [];

    //  _x params ["_allBuckets","_newestBucket","_totalPeriod","_bucketsAmount","_promotedGeneration"];  // <ARRAY>, <ARRAY>, <SCALAR>, <SCALAR>, <SCALAR>
    private _keyCache_GC_generations = [
        [  // Gen0
            [_keyCache_GC_gen0NewestBucket],
            _keyCache_GC_gen0NewestBucket,
            0.001,
            1,
            1
        ],
        [  // Gen1
            [_gen1TopBucket],
            _gen1TopBucket,
            999,
            1,
            1
        ]
    ];
    SETP(GC_generations, _keyCache_GC_generations);

    private _GCHandle = [0] spawn CaSe_fnc_keyCache_garbageCollector;
    uiSleep 1;
    "Test123" call CaSe_fnc_keyCache_registerForGC;
    [_reporterContext, "Basic Promotion<br/>Test Started"] call _fnc_reporter;


    private _timeout = serverTime + 30;
    private _passedTest = false;

    //// Assert
    waitUntil {
        _passedTest = "Test123" in _gen1TopBucket;
        _passedTest || _timeout <= serverTime
    };
    if (_passedTest) then {
        [_reporterContext, "Basic Promotion<br/>Test Passed"] call _fnc_reporter;
    } else {
        [_reporterContext, "Basic Promotion<br/>Test Failed"] call _fnc_reporter;
    };

    //// Clean Up
    terminate _GCHandle;
    call compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"unitTestUtility_revertInit.sqf"];
    Dev_unitTestInProgress = nil;
};
"Unit Test Started";
