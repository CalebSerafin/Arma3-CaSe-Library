/*
Maintainer: Caleb Serafin
    Creates a new slave cancellation token that will cancel when any of the linked master cancellation tokens are cancelled.

Argument: <ARRAY<cancellationToken>> Provide only an array of master cancellationTokens.

Return Value:
    <CancellationToken> Slave cancellation token.

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes

Example:
    private _slaveCT = [_masterCT1, _masterCT2, _masterCT3] call CaSe_fnc_cancellationToken_createLinked;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

if !(_this isEqualTypeAll []) exitWith {
    LOG_ERROR("Argument is not an array of cancellationTokens.")
};
VALIDATE_CANCELLATION_TOKEN_ARRAY(_this)

private _cTokenArray = _this;
private _cToken = [] call FNCP(new);

isNil {
    if (_cTokenArray findIf {_x #CTOKEN_I_IS_CANCELLED} != -1) exitWith {
        [_cToken] call FNCP(cancel);
    };

    private _fnc_massUnregister = {
        params ["_CTRegistrations","_cToken"];
        { [_x] call FNCP(unregister) } forEach _CTRegistrations;
        [_cToken] call FNCP(cancel);
    };
    private _CTRegistrations = [];
    _CTRegistrations append (_cTokenArray apply { [_x, _fnc_massUnregister, [_CTRegistrations,_cToken]] call FNCP(register) });
};

_cToken;
