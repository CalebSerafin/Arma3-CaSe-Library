/*
Maintainer: Caleb Serafin
    Checks if function/command and target combination allows for RemoteExecution.

Arguments:
    <STRING> The name of the command or function.
    <BOOLEAN> If the target is a server.
    <BOOLEAN> If the server is localHost.

Return Value:
    <BOOL> If remote execution should be allowed.

Scope: Any, Local Arguments
Environment: Any
Public: Yes

Example:
    ["setDamage", isServer, hasInterface] call CaSe_fnc_canRE_check;  // false

    // Local machine target shorthand:
    "setDamage" call CaSe_fnc_canRE_check;  // false
    "hint" call CaSe_fnc_canRE_check;  // true
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_name", "", [""]],
    ["_isTargetServer", isServer, [false]],
    ["_isServerLocalHost", hasInterface, [false]]
];

private _isTargetClient = !_isTargetServer || _isServerLocalHost && _isTargetServer;

if ( _isTargetServer && {_name in GETP(targetServerList)} ) exitWith { true };
if ( _isTargetClient && {_name in GETP(targetClientList)} ) exitWith { true };
false;
