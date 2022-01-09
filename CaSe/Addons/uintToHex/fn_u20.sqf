#include "config.hpp"
FIX_LINE_NUMBERS

GETP(b16e2LookupTable) # floor (_this / 4096) +
GETP(b16e2LookupTable) # floor (_this / 16 mod 256) +
GETP(b16LookupTable) # (_this mod 16);
