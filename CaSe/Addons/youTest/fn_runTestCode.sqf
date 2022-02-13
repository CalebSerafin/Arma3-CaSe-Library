/*
Maintainer: Caleb Serafin
    Runs code as a test.

    provides access to reports through:
    _statusTextToken set [0,"Text"];
    _progressToken set [0, 0.5];
    _etaToken set [1, time + 5];

Arguments:
    <CODE> Code to test. Empty string return is regarded as pass. Non-empty is a failure and will be displayed.
    <HASHMAP> Progress Reporter Tokens. Used for returning info during execution.

Return Value:
    <BOOLEAN> If the test passed

Scope: Any, Local Effect.
Environment: Scheduled
Public: Yes

Example:
    [{"Rigged from the start."}] spawn CaSe_fnc_youTest_runTest;


    [{_etaToken set [1, time+10]; uiSleep 10; "Rigged from the start."}] spawn CaSe_fnc_youTest_runTestCode;

    [] spawn {
        uiSleep 2;
        ["Lol XD Test", {_etaToken set [1, time+10]; uiSleep 10; "Rigged from the start."}] spawn CaSe_fnc_youTest_runTestCode;
    };
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    "_code",
    ["_progressTokens", false]
];

private _context = createHashMapFromArray [
    ["_code", _code],
    ["_statusTextToken", [""]],
    ["_progressToken", [-1]],
    ["_etaToken", [time, -1]]
];

if (_progressTokens isEqualType false) then {
    LOG_DEBUG("_progressTokens not provided.")
};
if (_progressTokens isEqualType _context) then {
    _context merge [_progressTokens, true];
};

// Ensures that errors don't halt parent execution.
private _sandboxHandle = _context spawn {
    private _context = _this;

    private _statusTextToken = _context get "_statusTextToken";
    private _progressToken = _context get "_progressToken";
    private _etaToken = _context get "_etaToken";

    _this set ["_return", [] call (_context get "_code")];
};

waitUntil {
    uiSleep 0.01;
    scriptDone _sandboxHandle;
};

private _return = _context getOrDefault ["_return", "Error, crashed."];
if (isNil "_return") then {
    _return = "Error, nil return";
};
if !(_return isEqualType "") then { _return = str _return };
private _passedTest = _return isEqualTo "";

[_passedTest, _return]
