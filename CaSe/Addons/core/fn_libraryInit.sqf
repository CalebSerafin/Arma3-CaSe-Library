#include "config.hpp"
FIX_LINE_NUMBERS
RUN_ONLY_ONCE(init)

private _libraryPackageConfigs = "true" configClasses (configFile >> "CfgFunctions" >> QUOTE(MOD));

{
    private _funcClass = configName _x + "_init";
    if (isClass (_x >> _funcClass)) then {
        call (missionNamespace getVariable [QUOTE(MOD) + "_fnc_" + _funcClass, {}]);
    };
} forEach _libraryPackageConfigs;
