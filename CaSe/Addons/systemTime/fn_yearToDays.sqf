/*
Maintainer: Caleb Serafin
    Converts the specified year to days since year 1.
    Inspired by C#'s DateTime(year, month, day) constructor and subfunctions.

Arguments:
    <SCALAR> Year. Should be positive integral for accurate result.

Return Value:
    <SCALAR> Days since year 1.

Scope: Any
Environment: Any
Public: No

Example:
    1600 call CaSe_fnc_systemTime_yearToDays;  // 584022
    1900 call CaSe_fnc_systemTime_yearToDays;  // 693595
    1984 call CaSe_fnc_systemTime_yearToDays;  // 724275
*/
params ["_year"];

private _yearOffset = _year - 1;  // Since year 1
private _century = floor (_yearOffset / 100);
floor (_yearOffset * (365 * 4 + 1) / 4) - _century + floor (_century / 4);
