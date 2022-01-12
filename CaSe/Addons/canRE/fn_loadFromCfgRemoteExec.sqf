/*
Maintainer: Caleb Serafin
    Populates the lookup table from the configFile, campaignConfigFile, and missionConfigFile's CfgRemoteExecs.

Scope: All, Local Effect
Environment: Any
Public: No

Example:
    call A3A_fnc_canRE_loadFromCfgRemoteExec;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

private _targetClientList = GETP(targetClientList);
private _targetServerList = GETP(targetServerList);

private _fnc_getConfigNumber = {
    params ["_config", "_default"];
    if (isNumber _config) then { getNumber _config } else { _default };
};

private _configFileOrder = [configFile, campaignConfigFile, missionConfigFile];
private _RETypes = ["Functions","Commands"];

private _inheritedParameters = createHashMap;  // _inheritedParameters get _REtype params ["_inheritedMode", "_inheritedTargets"];
{
    private _configRoot = _x;
    {
        private _REtype = _x;
        private _baseSettings = _configRoot >> "CfgRemoteExec" >> _REtype;
        private _mode = [_baseSettings >> "mode", 2] call _fnc_getConfigNumber;  // Note, mode 2 is ignored and is treated like mode 1.
        private _targets  = [_baseSettings >> "allowedTargets", 0] call _fnc_getConfigNumber;

        _inheritedParameters set [_REtype, [_mode, _targets]];
    } forEach _RETypes;
} forEach _configFileOrder;


{
    private _REtype = _x;
    _inheritedParameters get _REtype params ["_inheritedMode", "_inheritedTargets"];
    if (_inheritedMode == 0) then { continue };
    {
        private _configRoot = _x;
        private _commands = "true" configClasses (_configRoot >> "CfgRemoteExec" >> _REtype);
        {
            private _name = configName _x;
            private _allowedTargets  = [_x >> "allowedTargets", _inheritedTargets] call _fnc_getConfigNumber;

            switch (_allowedTargets) do {
                case 0: { _targetClientList set [_name, true]; _targetServerList set [_name, true]; };
                case 1: { _targetClientList set [_name, true]; };
                case 2: { _targetServerList set [_name, true]; };
            };
        } forEach _commands;
    } forEach _configFileOrder;
} forEach ["Functions","Commands"];

