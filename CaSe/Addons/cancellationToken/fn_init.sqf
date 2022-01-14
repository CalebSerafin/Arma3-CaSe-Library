/*
Maintainer: Caleb Serafin
    Initialised typeRef used for verifying cancellation tokens.

Scope: All, Local Effect
Environment: Unscheduled
Public: Yes

Example:
    call CaSe_fnc_async_init;
*/
#include "config.hpp"
FIX_LINE_NUMBERS
RUN_ONLY_ONCE(init)

SETP(typeRef, [nil])
