/*
private _fnc_reporter = compileScript [KEYCACHE_TEST_DIRECTORY_PATH+"testReporter.sqf"];
private _reporterContext = createHashmapFromArray [["_componentName","My Piece"]];
[_reporterContext,"Hello RPT, my test passed, goodbye."] call _fnc_reporter;
*/

#include "..\config.hpp"
FIX_LINE_NUMBERS

private _hashmap = createHashmap;
params [
    ["_context",_hashmap,[_hashmap]],
    ["_text","",[""]]
];

private _componentName = _context getOrDefault ["_componentName","General"];
private _componentNameShort = _context getOrDefault ["_componentNameShort",_componentName];

TEST_HINT("UnitTest cToken-"+_componentNameShort, _text);
LOG_INFO("UnitTest, cancellationToken "+_componentName+", " + _text);
