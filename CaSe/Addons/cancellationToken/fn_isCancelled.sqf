/*
Maintainer: Caleb Serafin
    Checks if the provided cancellationToken has been cancelled.

Arguments:
    <CancellationToken>

Return Value:
    <BOOLEAN> True if cancelled. False if still live.

Scope: Any, Local Arguments
Environment: Any
Public: Yes

Example:
    [_cancellationToken] call CaSe_fnc_cancellationToken_isCancelled;  // false
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_cancellationToken", [], [ [] ], [CTOKEN_PARAM_COUNT]]
];
VALIDATE_CANCELLATION_TOKEN(_cancellationToken)

_cancellationToken #CTOKEN_I_IS_CANCELLED;
