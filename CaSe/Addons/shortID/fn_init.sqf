
/*
Maintainer: Caleb Serafin
    You can configure the range and distribution of short ID data here.
    It's based on counters. A client has 2^32. A headless-client has 2^40. A server has 2^46.
    Counters are initialised to random values to mitigate clientOwner collisions.


Bit Distribution:
    L - isServerLike
    S - isServer
.                    0                   1                   2                   3                   4
.                    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7
.                   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Server or Host:     |L|S|                 Counter 2                 |                   Counter 1                   |
.                   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Headless CLient:    |L|S| Identity  |           Counter 2           |                   Counter 1                   |
.                   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
Dedicated Client:   |L|          Identity           |   Counter 2   |                   Counter 1                   |
.                   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+


Scope: Any
Environment: Any
Public: No

Example:
    call CaSe_fnc_shortID_init;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

private _clientID = 0;
private _counter1Modulo = 2^24;
private _counter2Modulo = 0;


if (isServer || !hasInterface) then {
    if (isServer) then {
        _clientID = 1 * 2^23;           // 1 isServerLike bit
        _clientID = _clientID + 2^22;   // 1 isServer bit
        _counter2Modulo = 2^22;         // 22 Counter bits
    } else {  // Headless client.
        _clientID = 1 * 2^23;                                   // 1 isServerLike bit
        _clientID = _clientID + 0 * 2^22;                       // 1 isServer bit
        _clientID = _clientID + (clientOwner mod 2^6) * 2^16;   // 6 ID bits
        _counter2Modulo = 2^16;                                 // 16 Counter bits
    };
} else {
    _clientID = 0 * 2^23;                                 // 1 isServerLike bit
    _clientID = _clientID + (clientOwner mod 2^15) * 2^8; // 15 ID bits
    _counter2Modulo = 2^8;                                // 8 Counter bits
};

SETP(clientID, _clientID);
SETP(counter1Modulo, _counter1Modulo);
SETP(counter2Modulo, _counter2Modulo);
SETP(counter1, floor random _counter1Modulo);
SETP(counter2, floor random _counter2Modulo);
