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
// Short and Sweat
    [ [{ (_this select [0,floor (2 * time mod count _this)]) + "_" },"Hello World! "] ] call CaSe_fnc_youTest_codeHintSet;



// Thorough, expensive, and flashy
// see doc_codeHintSet

*/
#include "config.hpp"
FIX_LINE_NUMBERS

private _codeHint_codes = GETP(codeHint_codes);
_codeHint_codes resize 0;
_codeHint_codes append _this;

if !(GETP(codeHint_started)) then {
    [_codeHint_codes] call FNCP(codeHintRenderer);
};


