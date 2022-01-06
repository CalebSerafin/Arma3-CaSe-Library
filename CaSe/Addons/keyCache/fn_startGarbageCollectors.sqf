/*
Maintainer: Caleb Serafin
    Starts a garbage collector for each generation.

Scope: All
Environment: Any
Public: No

Example:
    [] call CaSe_fnc_keyCache_startGarbageCollectors;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

#ifdef __keyCache_unitTestMode
params [["_confirmUnitTest", "", [""]]];
if (_confirmUnitTest isEqualTo "") exitWith { LOG_INFO("Standard Insertion Protocol Aborted due to Unit Test Mode Active."); };
if (_confirmUnitTest isNotEqualTo "confirmUnitTest" || _confirmUnitTest isEqualTo "preInit") exitWith { LOG_ERROR("Unknown Code: "+str _confirmUnitTest) };
#endif
FIX_LINE_NUMBERS

if (!isNil {GETP(garbageCollection)}) exitWith { LOG_ERROR("Invoked Twice"); };
SETP(garbageCollection, true);

// Start a GC for each of the ones listed in init.
private _keyCache_GC_generations = GETP(GC_generations);
private _keyCache_garbageCollectorHandles = [];
for "_i" from 0 to count _keyCache_GC_generations-1 do {
    _keyCache_garbageCollectorHandles pushBack ([_i] spawn FNCP(garbageCollector));
};
SETP(garbageCollectorHandles, _keyCache_garbageCollectorHandles);
