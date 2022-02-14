/*
Maintainer: Caleb Serafin, Håkon Rydland
    Converts systemTime or systemTimeUTC array into Sortable date/time pattern (long time, descending order, without AM/PM).
    EG: [2009,15,6,13,45,30,420] -> "2009-15-06 13:45:30:420"
    https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings#table-of-format-specifiers

Arguments:
    <SCALAR> Year
    <SCALAR> Month
    <SCALAR> Day
    <SCALAR> Hour
    <SCALAR> Minute
    <SCALAR> Second
    <SCALAR> Millisecond

Return Value:
    <STRING> Formatted systemTime

Scope: Any, Global Arguments
Environment:Any
Public: Yes

Example:
    [2009,15,6,13,45,30,420] call CaSe_fnc_systemTime_format_S;  // "2009-15-06 13:45:30:420"
    systemTimeUTC call CaSe_fnc_systemTime_format_S;
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

private _fnc_pad_2Digits = {
    if (count _this == 1) then {
        "0"+_this;
    } else {
        _this;
    };
};

private _fnc_pad_3Digits = {
    switch (count _this) do {
        case 1: {"00"+_this};
        case 2: {"0"+_this};
        default {_this};
    };
};

(str _year) + "-" + ((str _month) call _fnc_pad_2Digits) + "-" + ((str _day) call _fnc_pad_2Digits) + " " + ((str _hour) call _fnc_pad_2Digits) + ":" + ((str _minute) call _fnc_pad_2Digits) + ":" + ((str _second) call _fnc_pad_2Digits) + ":" + ((str _millisecond) call _fnc_pad_3Digits );
