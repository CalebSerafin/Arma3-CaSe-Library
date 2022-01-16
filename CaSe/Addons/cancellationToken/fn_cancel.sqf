/*
Maintainer: Caleb Serafin
    Cancels a CancellationToken immediately.

Arguments:
    <CancellationToken>

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes

Example:
    [_cancellationToken] call CaSe_fnc_cancellationToken_cancel;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_cancellationToken", [], [ [] ], [CTOKEN_PARAM_COUNT]]
];
VALIDATE_CANCELLATION_TOKEN(_cancellationToken)

isNil {
    if (_cancellationToken #CTOKEN_I_IS_CANCELLED) exitWith {};
    _cancellationToken set [CTOKEN_I_IS_CANCELLED, true];

    private _timerHandle = _cancellationToken #CTOKEN_I_TIMER_HANDLE;
    if (!scriptDone _timerHandle) then {
        terminate _timerHandle;
    };

    private _emptyArray = [];
    {
        if (_x isEqualTo _emptyArray) then { continue };
        private _thisCancellationTokenRegistration = _x;
        _x params ["_code", "_argument"];
        _argument call _code;
    } forEach (_cancellationToken #CTOKEN_I_REGISTERED_CODE);
};
