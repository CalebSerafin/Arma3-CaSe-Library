/*
Maintainer: Caleb Serafin
    Removes a translation from the Translation DB.
    Will run _fnc_onDispose if it's defined.

Argument:  <HASHMAPKEY> Translation Key

Scope: Any, Local Effect
Environment: Any
Public: Yes

Example:
    "HelloWorld" call CaSe_fnc_keyCache_drop;
*/
#include "config.hpp"
FIX_LINE_NUMBERS
// Garbage Cleaner will take care of the GC_registeredItems entry
private _cacheStruct = GETP(DB) deleteAt _this;

// Try spawn dispose event if expired
_cacheStruct params ["_translation","_lifeTime",["_expiryTime",1e39],["_fnc_onDispose",nil]];
if (isNil "_fnc_onDispose") exitWith {};
[_this, _translation] spawn _fnc_onDispose;
