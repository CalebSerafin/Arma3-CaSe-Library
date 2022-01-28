#include "config.hpp"

class CfgPatches {
    class ADDON {
        name = PACKAGE;
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.06;
        requiredAddons[] = { QUOTE(UGLUE(MOD,core)) };
        author = "Caleb Serafin";
        authors[] = {"Caleb Serafin"};
        authorUrl = "https://github.com/CalebSerafin/Arma3-CaSe-Library";
        version = VERSION_NUM;
        versionStr = VERSION_STR;
        versionAr[] = {VERSION_ARRAY};
    };
};

class CfgFunctions {
    class MOD {
        class PACKAGE {
            DEFINE_FNC(drop)
            DEFINE_FNC(garbageCollector)
            DEFINE_FNC(get)
            DEFINE_FNC(has)
            DEFINE_FNC(init)
            DEFINE_FNC(refresh)
            DEFINE_FNC(registerForGC)
            DEFINE_FNC(set)
            DEFINE_FNC(startGarbageCollectors)
        };
    };
};
