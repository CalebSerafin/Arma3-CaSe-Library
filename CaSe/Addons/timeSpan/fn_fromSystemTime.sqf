/*
Maintainer: Caleb Serafin
    Converts systemTime to the timeSpan since year 1.

Arguments:
    <SCALAR> Year (1 based)
    <SCALAR> Month (1 based)
    <SCALAR> Day (1 based)
    <SCALAR> Hour
    <SCALAR> Minute
    <SCALAR> Second
    <SCALAR> Millisecond

Return Value:
    <TimeSpan> Time since year 1.  See timeSpan.md

Scope: Any
Environment: Any
Public: Yes

Example:
    [2022,2,14,2,41,05,420] call CaSe_fnc_timeSpan_fromSystemTime;  // [false,738199,2,41,5,420,0,0]
*/
params [
    "_year",
    "_month",
    "_day",
    "_hour",
    "_minute",
    "_second",
    "_millisecond"
];

[  // TimeSpan
    false,
    [_year, _month, _day] call FNCG(systemTime,dateToDays),
    _hour,
    _minute,
    _second,
    _millisecond,
    0,
    0
]
