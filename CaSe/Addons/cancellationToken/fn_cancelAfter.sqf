/*
Maintainer: Caleb Serafin
    Cancels a CancellationToken after a delay.
    Will override a previously set timer.
    Use 1e39 to disable a previously set timer.

    IMPORTANT:
    Cancellation tokens with long finite delays MUST be disposed manually.
    Dispose via [_cToken] call CaSe_fnc_cancellationToken_dispose;
    Neglecting to dispose long delays will result in memory leaks until the timeout fires and releases it's reference to the cancellationToken.

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

isNil {
    if (_cancellationToken #CTOKEN_I_IS_CANCELLED) exitWith {};

    private _timerHandle = _cancellationToken #CTOKEN_I_TIMER_HANDLE;
    if (!scriptDone _timerHandle) then {
        terminate _timerHandle;
    };

    if (_delay <= 0) exitWith { [_cancellationToken] call FNCP(cancel) };
    if (!finite _delay) exitWith {};

    private _newTimerHandle = [_cancellationToken, _delay] spawn {
        params ["_cancellationToken", "_delay"];
        uiSleep _delay;
        [_cancellationToken] call FNCP(cancel);
    };
    _cancellationToken set [CTOKEN_I_TIMER_HANDLE, _newTimerHandle];
};
