#include "..\config.hpp"
FIX_LINE_NUMBERS

SETP(DB, nil);
SETP(GC_registeredItems, nil);
SETP(GC_generations, nil);
SETP(GC_gen0NewestBucket, nil);
RESET_RUN_ONLY_ONCE_P(init)