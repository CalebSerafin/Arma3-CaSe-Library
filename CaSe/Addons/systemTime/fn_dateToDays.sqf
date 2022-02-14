/*
Maintainer: Caleb Serafin
    Converts the provided date to days since year 1.
    Inspired by C#'s DateTime(year, month, day) constructor and subfunctions.

Arguments:
    <SCALAR> Year
    <SCALAR> Month
    <SCALAR> Day

Return Value:
    <SCALAR> Days.

Scope: Any
Environment: Any
Public: No

Example:
    [1984,7,4] call CaSe_fnc_systemTime_dateToDays;  // 724460
    [2022,2,14] call CaSe_fnc_systemTime_dateToDays;  // 738199
*/
#include "..\..\script_component.hpp"
FIX_LINE_NUMBERS()
params ["_year", "_month", "_day"];

if (_year < 1 || _month < 1 || _month > 12 || _day < 1) exitWith {
    Error_3("Year, month, or day is invalid: (%1 - %2 - %3)",_year,_month,_day);
    0
};

if (isNil 'A3A_core_dateToDays_didInit') then {
    A3A_core_dateToDays_didInit = true;
    A3A_core_dateToDays_daysToMonth365 = [ 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365 ];
    A3A_core_dateToDays_daysToMonth366 = [ 0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366 ];
};

private _days = if (_year call FNCP(isLeapYear)) then { A3A_core_dateToDays_daysToMonth366 } else { A3A_core_dateToDays_daysToMonth365 };
private _prevMonth = _days#(_month - 1);
private _daysInMonth = ((_days#_month) - _prevMonth);
if (_day > _daysInMonth) exitWith {
    Error_4("Day %1 is too high, only %2 days in month %3 of year %4.",_day,_daysInMonth,_month,_year);
    0
};

private _totalDays = (_year call FNCP(yearToDays)) + _prevMonth + _day - 1;
_totalDays;
