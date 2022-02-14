/*
Maintainer: Caleb Serafin
    Will tell you if a specified year is a leap year.
    If divisible by 400, then its a leap year.
    Else, if not divisible by 100, and divisible by 4, its a leap year.
    Inspired by C#'s DateTime(year, month, day) constructor and subfunctions.

Arguments:
    <SCALAR> Year. Should be positive integral for accurate result.

Return Value:
    <BOOL> If the specified year is a leap year.

Scope: Any
Environment: Any
Public: Yes

Example:
    1600 call CaSe_fnc_systemTime_isLeapYear;  // true
    1900 call CaSe_fnc_systemTime_isLeapYear;  // false
    1984 call CaSe_fnc_systemTime_isLeapYear;  // true
*/
params ["_year"];

if (_year mod 400 == 0) exitWith { true };
if (_year mod 100 == 0) exitWith { false };  // Georgian's minor correction every 100 years except for every 400 years.
if (_year mod 4 == 0) exitWith { true };
false;
