/*
Maintainer: Caleb Serafin
    Creates a new cancellation token.
    Can optionally specify a delay to automatic cancellation.

Arguments:
    <SCALAR> Delay in seconds. (Default: 1e39)

Return Value:
    <CancellationToken>

Scope: Any, Local Effect
Environment: Any
Public: Yes

Example:
    private _cancellationToken = [] call CaSe_fnc_cancellationToken_new;
    private _cancellationToken = [5] call CaSe_fnc_cancellationToken_new;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_delay", 1e39, [ 0 ]]
];

private _cToken = [GETP(typeRef), false, scriptNull, []];

if (finite _delay) then {
    [_cToken, _delay] call FNCP(cancelAfter);
};

_cToken;
