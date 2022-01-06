/*
Maintainer: Caleb Serafin
    Refreshes the expiry of a translation in the DB.
    Will not refresh if the translation does not exist, or if it has already expired but waiting for GC.

Argument: <HASHMAPKEY> Translation Key

Scope: Any, Local Effect
Environment: Any
Public: Yes
Dependencies:
    <HASHMAP> CaSe_keyCache_DB

Example:
    "HelloWorld" call CaSe_fnc_keyCache_refresh;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

isNil {
    private _cachedStruct = GETP(DB) getOrDefault [_this,[nil,nil,-1,nil]];
    if (_cachedStruct#2 <= serverTime) exitWith {};
    _cachedStruct set [2, serverTime + _cachedStruct#1];
};
