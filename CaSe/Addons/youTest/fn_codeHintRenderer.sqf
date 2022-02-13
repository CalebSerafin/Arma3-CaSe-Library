/*
Maintainer: Caleb Serafin
    Calculates the logarithmic mean of the arguments.
    Places a marker on the map where Petros is not standing.
    Finally, concludes whether the player will win the next lottery.

Arguments:
    <STRING> The first argument
    <OBJECT> The second argument
    <SCALAR> Float or number in SQF.
    <INTEGER> If the number cannot have fractional values.
    <BOOLEAN> Optional input (default: true)
    <ARRAY<STRING>> Array of a specific type (string in this case).
    <STRING,ANY> A key-pair as compound type, shorthand by omitting ARRAY.
    <CODE|STRING> Optional input with synonymous types, string compiles into code. (default: {true})
    <STRING> Optional singular String input | <ARRAY> Optional Array input (default: [""])
    <CODE<OBJECT,SCALAR,SCALAR,STRING>> Code that takes arguments of an object, a scalar, a scalar, and returns a string.

Return Value:
    <BOOLEAN> If the player will win the next lottery.

Scope: Server/Server&HC/Clients/Any, Local Arguments/Global Arguments, Local Effect/Global Effect
Environment: Scheduled/Unscheduled/Any
Public: Yes/No

Example:
    [ [{ (_this select [0,floor (2 * time mod count _this)]) + "_" },"Hello World! "] ] call CaSe_fnc_youTest_codeHintRenderer;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params ["_codeHint_codes"];

if (GETP(codeHint_started)) exitWith {};
SETP(codeHint_started, true);
SETP(codeHint_errorState, false);

private _fnc_render = {
    private _codeHint_codes = _thisArgs;
    if !(GETP(codeHint_started)) exitWith {};
    if (GETP(codeHint_errorState)) exitWith { SETP(codeHint_started, false); hint "codeHint Renderer Exited due to Error State." };
    SETP(codeHint_errorState, true);

    private _structuredStringArray = _codeHint_codes apply {
        switch (true) do {
            case (_x isEqualType ""): { _x };
            case (_x isEqualType {}): { [] call _x };
            case (_x isEqualType [] && {count _x == 2}): { (_x#1) call (_x#0) };
            default { "(Error Building)" };
        };
    };
    if (isNil "_structuredStringArray" || (_structuredStringArray isEqualTo [])) exitWith {};

    private _dummyText = text "";
    private _textArray = _structuredStringArray apply { if (_x isEqualType _dummyText) then {_x} else { parseText _x} };
    if (isNil "_structuredStringArray") exitWith {};

    private _composedText = composeText _textArray;
    if (isNil "_composedText") exitWith {};

    hintSilent _composedText;

    SETP(codeHint_errorState, false);
};

addMissionEventHandler ["EachFrame", _fnc_render, _codeHint_codes];
