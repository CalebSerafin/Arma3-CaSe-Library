/*
Maintainer: Caleb Serafin
    Checks if contents of server and client remote execute lists are the same since initialisation.

Arguments:
    <BOOLEAN> false to just return the answer, true to log and auto restore the RE lists.

Return Value:
    <BOOLEAN> True if they are the same, false if they have been tampered with.

Scope: Any
Environment: Any
Public: Yes

Example:
    [] call CaSe_fnc_canRE_validateREList;
    [true] call CaSe_fnc_canRE_validateREList;
*/
#include "config.hpp"
#ifndef ENABLE_RE_LIST_VALIDATION
if (true) exitWith { true };
#endif
FIX_LINE_NUMBERS

params [
    ["_autoRestore", false, [false]]
];

if (isNil QUOTE(FNCP(REListHashes)) || { !isFinal FNCP(REListHashes) }) exitWith {
    LOG_ERROR("Hashes have not been calculated.");
    false;
};

private _actualHashes = [hashValue keys GETP(targetServerList), hashValue keys GETP(targetClientList)];
private _expectedHashes = call FNCP(REListHashes);
private _hashesMatch = _expectedHashes isEqualTo _actualHashes;

if (!_autoRestore) exitWith { _hashesMatch };
if (_hashesMatch) exitWith { true };

LOG_ERROR("Integrity hashes mismatch! Actual: "+ str _actualHashes +", Expected: "+ str _expectedHashes);

private _REListRestorePoint = parseSimpleArray ((str FNCP(REListRestorePoint)) trim ["{}", 0]);
if (isNil "_REListRestorePoint") exitWith {
    LOG_ERROR("Failed to restore RE list. parseSimpleArray returned nil.")
};

_REListRestorePoint params ["_serverListRestore", "_clientListRestore"];
private _restorePointHashes = [hashValue keys _serverListRestore, hashValue keys _clientListRestore];
if (_expectedHashes isNotEqualTo _restorePointHashes) exitWith {
    LOG_ERROR("Failed to restore RE list. Integrity hashes mismatch! Actual: "+ str _restorePointHashes +", Expected: "+ str _expectedHashes)
};

private _targetServerList = createHashMap;
private _targetClientList = createHashMap;
{ _targetServerList set [_x, true] } forEach _serverListRestore;
{ _targetClientList set [_x, true] } forEach _clientListRestore;
SETP(targetServerList, _targetServerList);
SETP(targetClientList, _targetClientList);

LOG_INFO("Restore RE list to finalised version.")
false;
