/*
Maintainer: Caleb Serafin
    Registers code to run when cancellation is called.
    Will run immediately if already cancelled.

Arguments:
    <CancellationToken> The first argument
    <CODE<ANY>> Code to run when cancelled in Unscheduled environment. Argument passed as _this.
    <ANY> Argument passed to code as _this. (Default: nil)

Return Value:
    <CancellationTokenRegistration> Required for deregistering code.

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes

Example:
    [_ct, { systemChat "Hello World!" }] call CaSe_fnc_cancellationToken_register;
    [_ct, { systemChat ("Hello "+_this) }, name player] call CaSe_fnc_cancellationToken_register;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_cancellationToken", [], [ [] ], [CTOKEN_PARAM_COUNT]],
    ["_code", {}, [ {} ]],
    ["_argument", nil]
];
VALIDATE_CANCELLATION_TOKEN(_cancellationToken)

private _cTokenRegistration = [_code, _argument];

isNil {
    if (_cancellationToken #CTOKEN_I_IS_CANCELLED) exitWith {
        _argument call _code;
    };

    _cancellationToken #CTOKEN_I_REGISTERED_CODE pushBack _cTokenRegistration;
};

_cTokenRegistration;
