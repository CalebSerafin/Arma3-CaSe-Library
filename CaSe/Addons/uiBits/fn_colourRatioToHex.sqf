/*
Maintainer: Caleb Serafin
    Converts an array of ratios to 0→ff Hex colour.
    It was designed for ratio to hex colour conversion, but it can handle any array length.

Argument: <ARRAY<SCALAR>>

Return Value:
    <STRING> hex colour in string. Without the pound symbol at the front;

Scope: Any
Environment: Any
Public: Yes

Example:
    [0, 0.5, 1] call CaSe_fnc_uiBits_colourRatioToHex;  // "007fff"
    [0, 0.5, 1, 0.75, 0.25] call CaSe_fnc_uiBits_colourRatioToHex;  // "007fffbf3f"
*/
#include "config.hpp"
FIX_LINE_NUMBERS

_this apply { CaSe_uintToHex_b16e2LookupTable #floor (_x*255) } joinString "";
