/*
Maintainer: Caleb Serafin
    Repeats an item the provided number of times.
    Useful for filling a a line with characters.

Arguments:
    <ANY> Item to repeat.
    <SCALAR> Number of times to repeat.

Return Value:
    <ARRAY<ANY>> Array of repeated items.

Scope: Any
Environment: Any
Public: Yes

Example:
    ["|",5] call CaSe_fnc_uiBits_repeatItem;  // ["|","|","|","|","|"]
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params ["_item","_repetitions"];
private _a = [];
_a resize floor _repetitions;
_a apply {_item};
