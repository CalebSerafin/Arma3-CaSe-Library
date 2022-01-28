/*
Maintainer: Caleb Serafin
    Shifts the items in the array left by the specified amount, does not work backwards.
    Supports the shift amount looping.

Arguments:
    <ARRAY> The array being modified. NB Make a copy if you do not want to the original modified.
    <SCALAR> Amount to shift left.

Return Value:
    <ARRAY> Same reference, not a copy.

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes

Example:

    [ [1,2,3], 7 ] call CaSe_fnc_uiBits_shiftArrayLeft;  // [3,1,2]
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params ["_array", "_shiftAmount"];

private _count = count _array;
_shiftAmount = floor (_shiftAmount mod _count);
if (_shiftAmount <= 0) exitWith { _array };

_array insert [0, _array select [_count - _shiftAmount, _count]];
_array resize _count;
_array;
