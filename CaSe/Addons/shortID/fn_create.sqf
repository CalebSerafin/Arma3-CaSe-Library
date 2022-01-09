/*
Maintainer: Caleb Serafin
    Creates a ShortID that is unique to every computer on a server during the servers uptime.
    This is not unique between restarts or different servers.

Return Value: <ShortID>: <SCALAR, SCALAR>

Scope: Any
Environment: Scheduled
Public: Yes
Dependency: <CODE> fn_shortID_init must of completed.

Example:
    call CaSe_fnc_shortID_create;  // [1280,1]
    call CaSe_fnc_shortID_create call CaSe_fnc_shortID_format;  // "cafe97-506685"

    [] spawn {
        private _id = 0;
        isNil{_id = call CaSe_fnc_shortID_create};
        _id;  // [1280,2]
    };
*/
#include "config.hpp"
FIX_LINE_NUMBERS

private _newID = 0;
isNil {
    private _counter1 = GETP(counter1);
    private _counter2 = GETP(counter2);

    _newID = [GETP(clientID) + _counter2, _counter1];

    private _counter1 = _counter1 + 1;
    if (_counter1 >= GETP(counter1Modulo)) then {
        SETP(counter1, 0);
        SETP(counter2, (_counter2 + 1) mod GETP(counter2Modulo));
    } else {
        SETP(counter1, _counter1);
    };
};
_newID;
