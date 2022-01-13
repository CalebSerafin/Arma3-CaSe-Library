/*
Maintainer: Caleb Serafin
    Checks if a task is done.
    Does not check the individual timeouts for when code.

Arguments:
    <AsyncTask> The first argument

Return Value:
    <BOOLEAN> true is task is done. false if it is not done.

Scope: Any, Local Arguments, Local Effect
Environment: Scheduled
Public: Yes

Example:
    private _asyncTask = [{uiSleep 3}] call CaSe_fnc_async_newTask;
    [_asyncTask] call CaSe_fnc_async_isDone;  // false
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_asyncTask", [[]], [ [] ]]
];
VALIDATE_ASYNC_TASK(_asyncTask)

_asyncTask #TASK_I_HAS_RETURNED
