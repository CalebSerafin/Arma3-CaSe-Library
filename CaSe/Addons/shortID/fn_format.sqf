/*
Maintainer: Caleb Serafin
    Creates a formatted hexadecimal string of a provided ShortID.
Argument: <ShortID> Generated ShortID.
Return Value: <STRING> Hexadecimal string in format 012345-6789ab.

Environment: Any
Public: Yes
Dependency: <CODE> fn_uintToHex needs to initialise before running this code.

Example:
    [1280,1] call CaSe_fnc_shortID_format;  // "000500-000001"
    [16777215,16777215] call CaSe_fnc_shortID_format;  // "ffffff-ffffff"
    call CaSe_fnc_shortID_create call CaSe_fnc_shortID_format;  // "cafe97-506685"
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params ["_mostSignificant","_leastSignificant"];
(_mostSignificant call FNCG(uintToHex,u24)) + "-" + (_leastSignificant call FNCG(uintToHex,u24));
