/*
Maintainer: Caleb Serafin
    Loads tests from entries under [configFile, campaignConfigFile, missionConfigFile] >> "CfgCaSeYouTest";

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: No

Example:
    [] call CaSe_fnc_youTest_loadTestsFromConfig;
    [CaSe_youTest_testRoot] spawn CaSe_fnc_youTest_runTestItem;
*/
#include "config.hpp"
FIX_LINE_NUMBERS





private _typeTestItem = GETP(typeTestItem);
private _typeTestCollection = GETP(typeTestCollection);
private _typeTestFolder = GETP(typeTestFolder);

private _classCaSeYouTest = (LOCAL_CONFIG >> QUOTE(UGLUE(MOD,YouTest)));
private _classCaSeYouTestCollection = (LOCAL_CONFIG >> QUOTE(UGLUE(MOD,YouTestCollection)));


private _fnc_getName = {
    params ["_config"];
    private _nameProperty = _config >> "name";
    private _name = "";
    if (isText _nameProperty && { _name = getText _nameProperty; _name isNotEqualTo "" }) exitWith { _name };
    configName _config;
};

private _fnc_classifyConfig = {
    params ["_config"];

    if (_config isEqualTo configNull) exitWith {
        [_typeTestFolder, "configNull", []]
    };

    private _inheritedConfig = inheritsFrom _config;
    if (isNil "_inheritedConfig") exitWith {
        [_typeTestFolder, _config call _fnc_getName, _config call _fnc_loadFolder];
    };
    if (_inheritedConfig isEqualTo _classCaSeYouTest) exitWith {
        [_typeTestItem, _config call _fnc_getName, _config call _fnc_loadTest];
    };
    if (_inheritedConfig isEqualTo _classCaSeYouTestCollection) exitWith {
        [_typeTestCollection, _config call _fnc_getName, _config call _fnc_loadTestCollection];
    };
    // Default if not nil and not youTest or youTestCollection
    [_typeTestFolder, _config call _fnc_getName, _config call _fnc_loadFolder];
};

private _fnc_loadTest = {
    params ["_config"];
    private _path = getText (_config >> "path");
    if (fileExists _path) exitWith {
        compileScript [_path, false, ""]
    };
    private _functionName = getText (_config >> "function");
    missionNamespace getVariable [_functionName, { "Test not found!" }]
};

private _fnc_loadTestCollection = {
    params ["_config"];
    private _classnames = getArray (_config >> "classnames");
    _classnames apply {_config >> _x} select {isClass _x} apply {_x call _fnc_classifyConfig}
};

private _fnc_loadFolder = {
    params ["_config"];
    ("true" configClasses _config) apply { _x call _fnc_classifyConfig}
};

private _testRoot = GETP(testRoot);
_testRoot set [2, []];
{
    private _cfgName = _x call CaSe_fnc_youTest_strCfgRoot;
    private _cfgCaSeYouTest = _x >> "CfgCaSeYouTest";

    private _testHierarchy = [];
    if (_cfgCaSeYouTest isNotEqualTo configNull) then {
        _testHierarchy = [_cfgCaSeYouTest call _fnc_classifyConfig];
    };
    (_testRoot#2) pushBack [_typeTestFolder, _cfgName, _testHierarchy];
} forEach [configFile, campaignConfigFile, missionConfigFile];
