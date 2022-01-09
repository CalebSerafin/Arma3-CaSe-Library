/*
Maintainer: Caleb Serafin
    Generates the lookup tables for uintToHex.
    Only needs to run once per machine.
Public: No.
Example:
    call CaSe_fnc_uintToHex_init;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

if (!isNil QUOTE(GETP(initComplete))) exitWith { LOG_ERROR("Invoked Twice"); };
SETP(initComplete, true);

private _b16LookupTable = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
private _b16e2LookupTable = [];
{
    private _prefix = _x;
    _b16e2LookupTable append (_b16LookupTable apply {_prefix + _x});
} forEach _b16LookupTable;

SETP(b16LookupTable, _b16LookupTable);
SETP(b16e2LookupTable, _b16e2LookupTable);
