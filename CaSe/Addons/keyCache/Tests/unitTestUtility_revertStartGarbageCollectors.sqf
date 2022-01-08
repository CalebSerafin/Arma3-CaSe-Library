#include "..\config.hpp"
FIX_LINE_NUMBERS

{ terminate _x; } forEach GETP(garbageCollectorHandles);
SETP(garbageCollection, nil);
