/*
Maintainer: Caleb Serafin
    Returns the string name of a passed config file root.
    Any other arguments return an empty string.

Argument: <CONFIG> Config root.

Return Value: <STRING> Name of config.

Scope: Any, Local Arguments
Environment: Any
Public: Yes

Example:
    configFile call CaSe_fnc_youTest_strCfgRoot;  // "configFile"
    campaignConfigFile call CaSe_fnc_youTest_strCfgRoot;  // "campaignConfigFile"
    missionConfigFile call CaSe_fnc_youTest_strCfgRoot;  // "missionConfigFile"
    (configFile >> "Jake") call CaSe_fnc_youTest_strCfgRoot;  // ""
*/
#include "config.hpp"
FIX_LINE_NUMBERS

GETP(cfgToStrHm) getOrDefault [_this, ""];
