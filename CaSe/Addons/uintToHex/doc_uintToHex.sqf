/*
Maintainer: Caleb Serafin
    Formats a scalar as the specified length hexadecimal string.
    These lengths are divided into multiple functions for 4, 8, 12, 16, 20, 24 bits.
    4 and 8 bits are single lookup table selects.

Argument: <SCALAR> A numberic value to format as a hexadecimal string. Input must be integral.
Return Value: <STRING> 1,2,3,4,5,6 wide hexadecimal string.
Public: Yes
Dependency:
    fn_uintToHexGenTables must initialise:
    <ARRAY<STRING>> CaSe_b16LookupTable
    <ARRAY<STRING>> CaSe_b16e2LookupTable
*/

// Example:
floor random 0x1000000 call CaSe_fnc_uintToHex_u24;
16777215 call CaSe_fnc_uintToHex_u24;
// Tests:
[
    CaSe_uintToHex_b16LookupTable   # 0x0   isEqualTo "0",
    CaSe_uintToHex_b16e2LookupTable # 0xb4  isEqualTo "b4",
    0xaaf       call CaSe_fnc_uintToHex_u12 isEqualTo "aaf",
    0xdead      call CaSe_fnc_uintToHex_u16 isEqualTo "dead",
    0xca1eb     call CaSe_fnc_uintToHex_u20 isEqualTo "ca1eb",
    0xffffff    call CaSe_fnc_uintToHex_u24 isEqualTo "ffffff"
];
