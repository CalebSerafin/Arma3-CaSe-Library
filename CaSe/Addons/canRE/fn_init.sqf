/*
Maintainer: Caleb Serafin
    Initialised the layout of the lookup table as well as necessary variables.

Return Value:
    <BOOL> true if this is the first run. false if it was blocked.

Scope: All Machines, Local Effect
Environment: Unscheduled
Public: No

Example:
    call CaSe_fnc_canRE_init;
*/
#include "config.hpp"
FIX_LINE_NUMBERS
RUN_ONLY_ONCE(init)

SETP(targetServerList, createHashMap)
SETP(targetClientList, createHashMap)

call FNCP(loadFromCfgRemoteExec);

call CaSe_fnc_canRE_finaliseREList;
