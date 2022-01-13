/*
Maintainer: Caleb Serafin
    Calculates the logarithmic mean of the arguments.
    Places a marker on the map where Petros is not standing.
    Finally, concludes whether the player will win the next lottery.

Scope: All, Local Effect
Environment: Unscheduled
Public: Yes

Example:
    call CaSe_fnc_async_init;
*/
#include "config.hpp"
FIX_LINE_NUMBERS
RUN_ONLY_ONCE(init)

// Create a reference that breaks if the container is deep-copied or transferred to another machine.
SETP(localRef, [nil])
