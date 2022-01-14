/*
Maintainer: Caleb Serafin
    Terminates and deletes all used resources, such has the delay.
    The cancellation token cannot be used after being disposed.

Arguments:
    <CancellationToken>

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes

Example:
    [_cancellationToken] call CaSe_fnc_cancellationToken_dispose;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_cancellationToken", [], [ [] ], [CTOKEN_PARAM_COUNT]]
];
VALIDATE_CANCELLATION_TOKEN(_cancellationToken)

isNil {
    private _timerHandle = _cancellationToken #CTOKEN_I_TIMER_HANDLE;
    if (!scriptDone _timerHandle) then {
        terminate _timerHandle;
    };

    _cancellationToken resize 0;
};
