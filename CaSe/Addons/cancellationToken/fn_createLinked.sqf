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

private _ctMasterArray = _this;
private _cToken = [] call FNCP(new);

isNil {
    if (_ctMasterArray findIf {_x #CTOKEN_I_IS_CANCELLED} != -1) exitWith {
        [_cToken] call FNCP(cancel);
    };
    // WON'T WORK, RECURSIVE REFERENCE.
    // Maybe: store all tokens in a global something.
    // Require a using statement system to enclose cancellation tokens, and dispose tokens detected to go out of scope.
    // This will impact the Task system too.
    private _ctRegistrations = _ctMasterArray apply {[_x, FNCP(cancel), [_cToken]] call FNCP(register)};

    [_cToken, { {[_x] call FNCP(unregister)} forEach _x }, _ctRegistrations] call FNCP(register);
};

_cToken;
