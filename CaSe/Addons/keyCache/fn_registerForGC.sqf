/*
Maintainer: Caleb Serafin
    Adds key to Garbage Collection.
    This is a function, don't copy internal code, for the case that the internal implementation changes.
    Prevents an item being registered twice.

Argument: <HASHMAPKEY> Key

Scope: Any, Local Arguments, Local Effect
Environment: Any
Public: No
Dependencies:
    <ARRAY> CaSe_keyCache_GC_gen0NewestBucket

Example:
    "HelloWorld" call CaSe_fnc_keyCache_registerForGC;
*/
#include "config.hpp"
FIX_LINE_NUMBERS
// set returns true if a key was overwritten. This is used to exit before adding the item to the GC bucket.
if (GETP(GC_registeredItems) set [_this, true]) exitWith {};
GETP(GC_gen0NewestBucket) pushBack _this;
