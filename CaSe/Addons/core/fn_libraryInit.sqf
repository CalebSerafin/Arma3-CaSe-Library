#include "config.hpp"
FIX_LINE_NUMBERS
RUN_ONLY_ONCE(libraryInit)

// Get all package configs with an init function.

private _cfgPatchesAndCfgFunctionConfigs =
    "true" configClasses (configFile >> "CfgFunctions" >> QUOTE(MOD))
    apply { [QUOTE(MOD) + "_" + configName _x, _x] }
    select {
        isClass ((_x#1) >> (configName (_x#1) + "_init"))
        && isClass (configFile >> "CfgPatches" >> (_x#0))
    };

if (count _cfgPatchesAndCfgFunctionConfigs == 0) exitWith {
    LOG_WARNING("Library Init exited because no init functions could be found. This is likely a bug.");
};

private _cfgPatchToConfig = createHashMapFromArray _cfgPatchesAndCfgFunctionConfigs;
private _cfgPatches = keys _cfgPatchToConfig;
private _todoCfgPatches = _cfgPatches createHashMapFromArray _cfgPatches;

private _cfgPatchToDependencies = _cfgPatches createHashMapFromArray (_cfgPatches apply {
    getArray (configFile >> "CfgPatches" >> _x >> "requiredAddons") select {_x in _cfgPatchToConfig};
});


/*
    This is a depth first search.
    It checks the current cfgPatch for at least 1 dependency that is still in _todoCfgPatches (it is unresolved).
    If an unresolved dependency is found, it is: Removed from _todoCfgPatches (resolving it); Inserted at the current index (pushes dependants).
    If no unresolved dependency is found: The scan index is incremented.
*/
private _loadQueue = [];
private _scanIndex = 0;
private _queueLength = 1;

while {count _todoCfgPatches > 0} do {
    // Prime queue with random element.
    _loadQueue pushBack (_todoCfgPatches deleteAt (keys _todoCfgPatches #0));

    while {_scanIndex < _queueLength} do {
        private _cfgPatch = _loadQueue # _scanIndex;
        private _dependencies = _cfgPatchToDependencies get _cfgPatch;
        private _unresolvedDependencyIndex = _dependencies findIf { _x in _todoCfgPatches };

        if (_unresolvedDependencyIndex != -1) then {
            private _unresolvedDependency = _dependencies #_unresolvedDependencyIndex;
            _loadQueue insert [_scanIndex, _unresolvedDependency];
            _todoCfgPatches deleteAt _unresolvedDependency;
            _queueLength = _queueLength + 1;
            continue;
        };
        // No unresolved dependencies;
        _scanIndex = _scanIndex + 1;
    };
};

{
    private _funcClass = configName _x + "_init";
    private _funcName = QUOTE(MOD) + "_fnc_" + _funcClass;
    call (missionNamespace getVariable [_funcName, {}]);
    LOG_DEBUG("Executed initialiser " + _funcName);
} forEach (_loadQueue apply {_cfgPatchToConfig get _x});
