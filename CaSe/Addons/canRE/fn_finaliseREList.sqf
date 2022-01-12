/*
Maintainer: Caleb Serafin
    Saves the hashes and restore points of the server and client remote execute lists.

Scope: Any, Local Effect
Environment: Unscheduled
Public: Yes

Example:
    call CaSe_fnc_canRE_finaliseREList;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

#ifdef ENABLE_RE_LIST_VALIDATION
    if (!(isNil QUOTE(FNCP(REListHashes))) && {isFinal FNCP(REListHashes)}) then {
        LOG_ERROR("Hashes have already been calculated!");
    } else {
        private _serverListRERestorePoint = keys GETP(targetServerList);
        private _clientListRERestorePoint = keys GETP(targetClientList);
        missionNamespace setVariable [ QUOTE(FNCP(REListHashes)), compileFinal str [hashValue _serverListRERestorePoint, hashValue _clientListRERestorePoint] ];
        missionNamespace setVariable [ QUOTE(FNCP(REListRestorePoint)), compileFinal str [_serverListRERestorePoint, _clientListRERestorePoint] ];
    };
#endif
