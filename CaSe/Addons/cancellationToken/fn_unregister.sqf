/*
Maintainer: Caleb Serafin
    Unregisters the provided CancellationTokenRegistration.

Arguments:
    <CancellationTokenRegistration>

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes

Example:
    [_cancellationTokenRegistration] call CaSe_fnc_cancellationToken_unregister;
*/
params [
    ["_cancellationTokenRegistration", [], [ [] ]]
];

_cancellationTokenRegistration resize 0;
