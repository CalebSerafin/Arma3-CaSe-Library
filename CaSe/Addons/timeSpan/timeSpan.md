# TimeSpan
Represents a duration of time. It is broken up into smaller values to avoid the 24bit float limit. Days is the largest value as months are not standard and weeks do no make a big enough difference.

1. \<BOOLEAN\> Is Negative
2. \<SCALAR\> Days d
3. \<SCALAR\> Hours h
4. \<SCALAR\> Minutes m
5. \<SCALAR\> Seconds s
6. \<SCALAR\> Milliseconds ms
7. \<SCALAR\> Microseconds µs
8. \<SCALAR\> Nanoseconds ns

```sqf
private _timeSpan = [
    false,  // Negative
    27425,  // Days
    14,  // Hours
    53,  // Minutes
    54,  // Seconds
    69,  // Milliseconds
    142,  // Microseconds
    420  // Nanoseconds
];
[_timeSpan] call CaSe_fnc_timeSpan_format;
```

```sqf
[3463463] call CaSe_fnc_timeSpan_fromSeconds;  // [false,40,2,4,23,0,0,0]
```
