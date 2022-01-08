/*
Maintainer: Caleb Serafin
    Checks if a key is in the translation DB.
    If it is contained, it updates the expiry and returns the translation.
    If it is not contained, it returns nil.

Argument:  <HASHMAPKEY> Translation Key

Return Value:
    <ANY> The translation if the key is in the DB. Otherwise, it returns nil.

Scope: Any, Local Effect
Environment: Any
Public: Yes
Dependencies:
    <HASHMAP> CaSe_keyCache_DB

Example:
    "HelloWorld" call CaSe_fnc_keyCache_get;  // "HelloWorld"
*/
#include "config.hpp"
FIX_LINE_NUMBERS

private _cachedStruct = GETP(DB) getOrDefault [_this,[nil,0,-1]];
_cachedStruct params ["_translation","_lifeTime","_expiryTime","_fnc_onDispose" ];

isNil {
    if (_expiryTime <= serverTime) exitWith {
        _this call FNCP(drop);
        _translation = nil
    };
    _cachedStruct set [2, serverTime + _lifeTime];
};

if (isNil '_translation') exitWith { nil };  // Stops SQF from resolving _translation.
_translation;
