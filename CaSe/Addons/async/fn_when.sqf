/*
Maintainer: Caleb Serafin
    Assigns to tun When a task is complete.

Arguments:
    <AsyncTask> The first argument
    <CODE> Code to run when the task is complete.
    <ANY> Argument to code. (Default: nil)
    <SCALAR> Timeout. (Default is defined as TASK_D_TIMEOUT in config.hpp)

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: Yes/No

Example:
    private _asyncTask = [{uiSleep 3}] call CaSe_fnc_async_newTask;
    [_asyncTask, {systemChat "Done!"}] call CaSe_fnc_async_when;
    [_asyncTask, { systemChat format (["_return: %1, _argument: %2, _didTimeout: %3"] + _this) }, "Arg, I'm a pirate!"] call CaSe_fnc_async_when;
    [_asyncTask, { params ["_","_","_didTimeOut"]; systemChat (["Returned quickly!", "Ain't got no time for awaiting around."] select _didTimeOut) }, nil, 0.01] call CaSe_fnc_async_when;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_asyncTask", [[]], [ [] ]],
    ["_code", {}, [ {} ]],
    ["_argument", nil],
    ["_timeout", TASK_D_TIMEOUT]
];
VALIDATE_ASYNC_TASK(_asyncTask)

if (!finite _timeout) then {
    _asyncTask #TASK_I_WHEN_CODE pushBack [_code, _argument, scriptNull]
};

isNil {
    private _whenCodeIndexToken = [];
    private _timeoutHandle = [_timeout, _asyncTask, _whenCodeIndexToken, _code, _argument] spawn {
        params ["_timeout", "_asyncTask", "_whenCodeIndexToken", "_code", "_argument"];
        uiSleep _timeout;
        isNil {
            if (_asyncTask #TASK_I_HAS_RETURNED) exitWith {};
            _asyncTask #TASK_I_WHEN_CODE set [_whenCodeIndexToken #0, [{}, nil, scriptNull] ];
            [nil, _argument, true] call _code;
        }
    };

    _whenCodeIndexToken pushBack (_asyncTask #TASK_I_WHEN_CODE pushBack [_code, _argument, _timeoutHandle]);
}
