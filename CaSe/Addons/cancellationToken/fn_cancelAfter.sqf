/*
Maintainer: Caleb Serafin
    Cancels a CancellationToken after a delay.
    Will override a previously set timer.

Arguments:
    <CancellationToken>
    <SCALAR> Delay in seconds.

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes

Example:
    [_cancellationToken, 5] call CaSe_fnc_cancellationToken_cancelAfter;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_cancellationToken", [], [ [] ], [CTOKEN_PARAM_COUNT]],
    ["_delay", 1e39, [ 0 ]]
];
VALIDATE_CANCELLATION_TOKEN(_cancellationToken)

if (!finite _delay) exitWith {};

isNil {
    if (_cancellationToken #CTOKEN_I_IS_CANCELLED) exitWith {};

    private _timerHandle = _cancellationToken #CTOKEN_I_TIMER_HANDLE;
    if (!scriptDone _timerHandle) then {
        terminate _timerHandle;
    };

    private _timerHandle = [_cancellationToken, _delay] spawn {
        params ["_cancellationToken", "_delay"];
        uiSleep _delay;
        [_cancellationToken] call FNCP(cancel);
    };
    _cancellationToken set [CTOKEN_I_TIMER_HANDLE, _timerHandle];
};
