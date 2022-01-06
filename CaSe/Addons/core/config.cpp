/// --- Versioning --- ///
#define PACKAGE core
#define YEAR 21
#define MONTH 12
#define DAY 23
#define PATCH 1

/// --- Integration Detaction --- ///
#if __has_include("modSettings.hpp")
    #include "modSettings.hpp"
    #include "modMacros.hpp"
#else
    #include "\x\CaSe\Addons\core\modSettings.hpp"
    #include "\x\CaSe\Addons\core\modMacros.hpp"
#endif

class CfgPatches {
    class ADDON {
        name = PACKAGE;
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.06;
        requiredAddons[] = {};
        author = "Caleb Serafin";
        authors[] = {"Caleb Serafin"};
        authorUrl = "https://github.com/CalebSerafin/Arma3-CaSe-Library";
        version = VERSION_NUM;
        versionStr = VERSION_STR;
        versionAr[] = {VERSION_ARRAY};
    };
};
