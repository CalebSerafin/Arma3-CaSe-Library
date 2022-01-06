/*
Maintainer: Caleb Serafin
    Sets or adds a translation to the DB.
    This is the manual version of translate

Arguments:
    <HASHMAPKEY> Translation Key
    <ANY> Translation Value
    <SCALAR> | <NotANumber> Time to live from each refresh. (Infinity is inserted by 1e39)
    <CODE> Event run if garbage cleaned or dropped. Scheduled environment. params ["_keyName","_translation"]. (Default = nil)

Scope: Any, Local Effect
Environment: Any
Public: Yes
Dependencies:
    <HASHMAP> CaSe_keyCache_DB

Example:
    ["HelloWorld", parseText "Lol<br/>XD"] call CaSe_fnc_keyCache_set;
*/
#include "config.hpp"
FIX_LINE_NUMBERS
params [
    ["_keyName", ""],
    "_translation",
    ["_lifeTime", KEYCACHE_DEFAULT_TTL, [0,1e39]],
    ["_fnc_onDispose", nil, [nil, {}]]
];

// This is thread safe. Do not change the DB set and GC order, as that will make it thread unsafe.
GETP(DB) set [_keyName, [_translation, _lifeTime, serverTime + _lifeTime, _fnc_onDispose]];
if (finite _lifeTime) then {
    _keyName call FNCP(registerForGC);
};
