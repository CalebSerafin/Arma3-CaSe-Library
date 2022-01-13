/*
Maintainer: Caleb Serafin
    Ends a task and optionally returns a value.

Arguments:
    <AsyncTask> AsyncTask to return
    <ANY> Return Value. (Default: nil)

Return Value:
    <BOOLEAN> If the player will win the next lottery.

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes

Example:
    private _asyncTask = [] call CaSe_fnc_async_newTask;  // Note: Not started
    [_asyncTask] call CaSe_fnc_async_return;
    [_asyncTask, "Hello World!"] call CaSe_fnc_async_return;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_asyncTask", [[]], [ [] ]],
    ["_returnValue", nil]
];
VALIDATE_ASYNC_TASK(_asyncTask)

isNil {
    if (_asyncTask #TASK_I_HAS_RETURNED) exitWith {
        LOG_ERROR("Trying to return an asyncTask twice!")
    };
    _asyncTask set [TASK_I_RETURN_VALUE, _returnValue];
    _asyncTask set [TASK_I_HAS_RETURNED, true];

    private _whenCodes = _asyncTask #TASK_I_WHEN_CODE;
    // Kill all timeout scripts first to prevent the when code from possibly interfering by funny code.
    {
        private _timeoutHandle = _x#2;
        if (!scriptDone _timeoutHandle) then { terminate _timeoutHandle }
    } forEach _whenCodes;

    // Run when codes
    {
        _x params ["_code","_argument"];
        [_returnValue, _argument, false] call _code;
    } forEach _whenCodes;
};
