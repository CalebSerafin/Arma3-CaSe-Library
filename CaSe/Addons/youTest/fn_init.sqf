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

SETP(codeHint_codes, [])
SETP(codeHint_started, false)
SETP(codeHint_errorState, false)

private _cfgToStrHm = createHashMapFromArray [
    [configFile, "configFile"],
    [campaignConfigFile, "campaignConfigFile"],
    [missionConfigFile, "missionConfigFile"]
];
SETP(cfgToStrHm, _cfgToStrHm)

/*
<TestItem>: [
    <typeRef>
    <STRING> display name
    <CODE> test code
]
<typeTestCollection>: [
    <typeRef>
    <STRING> display name
    <ARRAY> Ordered Collection
]
<typeTestFolder>: [
    <typeRef>
    <STRING> display name
    <ARRAY> Unordered Collection
]
*/
SETP(typeTestItem, [nil])
SETP(typeTestCollection, [nil])
private _typeTestFolder = [nil];
SETP(typeTestFolder, _typeTestFolder)

private _testRoot = [_typeTestFolder, "testRoot", []];
SETP(testRoot, _testRoot)
