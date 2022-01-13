/*
Maintainer: Caleb Serafin
    Halts scheduled execution and awaits task completion.

Arguments:
    <AsyncTask> The first argument
    <SCALAR> Timeout. (Default is defined as TASK_D_TIMEOUT in config.hpp)
    <PollingPattern> | <SCALAR> Polling repeat and durations to use. Provide single number for basic polling sleep (Default is defined as TASK_D_POLLING_PATTERN in config.hpp)

Return Value:
    <BOOLEAN> If the player will win the next lottery.

Scope: Any, Local Arguments, Local Effect
Environment: Scheduled
Public: Yes

Example:
    private _asyncTask = [{uiSleep 3}] call CaSe_fnc_async_newTask;
    [_asyncTask] call CaSe_fnc_async_await;
    [_asyncTask, 5] call CaSe_fnc_async_await;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_asyncTask", [[]], [ [] ]],
    ["_timeout", TASK_D_TIMEOUT],
    ["_pollingPattern", TASK_D_POLLING_PATTERN, [ [], 0 ], [2]]
];
VALIDATE_ASYNC_TASK(_asyncTask)

if (_asyncTask #TASK_I_HAS_RETURNED) exitWith { [_asyncTask #TASK_I_RETURN_VALUE, false] };
if (!canSuspend) exitWith {
    LOG_ERROR("Unable to suspend.")
    [nil, true];
};

// Allows use of breakOut
scopeName "main";
private _endTime = serverTime + _timeout;

private _fnc_pollCode = {
    uiSleep _duration;
    if (_asyncTask #TASK_I_HAS_RETURNED) then {
        [_asyncTask #TASK_I_RETURN_VALUE, false] breakOut "main"
    };
    if (_endTime <= serverTime) then {
        [nil, true] breakOut "main"
    };
};

if (_pollingPattern isEqualType 0) exitWith {
    private _duration = _pollingPattern;
    while {true} do _fnc_pollCode;
};


private _pollRepeats = _pollingPattern #0;
private _pollDurations = _pollingPattern #1;

// From start to second last polling pattern.
for "_pollIndex" from 0 to count _pollDurations -2 do {
    private _repeat = _pollRepeats #_pollIndex;
    private _duration = _pollDurations #_pollIndex;
    for "_i" from 0 to _repeat do _fnc_pollCode;
};

// Last of polling pattern, repeat forever.
private _duration = _pollDurations #(count _pollDurations -1);
while {true} do _fnc_pollCode;



// Doesn't return here, two returns in _fnc_pollCode using breakOut
