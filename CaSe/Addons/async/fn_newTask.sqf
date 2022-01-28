/*
Maintainer: Caleb Serafin
    Returns a new asyncTask object.

Arguments:
    <CODE> Optional code to spawn immediately. (Default: nil)
    <ANY> Argument to pass to code. (Default: nil)

Return Value:
    <AsyncTask> Task task that's empty or started depending of if code is provided.

Scope: Any, Local Effect
Environment: Any
Public: Yes

Example:
    [] call CaSe_fnc_async_newTask;
    [{uiSleep 3}] call CaSe_fnc_async_newTask;
    [{hint ("Hello " + _this)}, name player] call CaSe_fnc_async_newTask;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_code", nil, [{}, nil] ],
    ["_argument", nil]
];

private _asyncTask = [
    GETP(typeRef),
    false,
    nil,
    []
];

if !(isNil "_code") then {
    [_asyncTask,_code,_argument] spawn {
        params ["_asyncTask","_code","_argument"];
        [_asyncTask, _argument call _code] call FNCP(return);
    };
};

_asyncTask;
