/// --- Versioning --- ///
#define PACKAGE shortID
#define YEAR 22
#define MONTH 1
#define DAY 9
#define PATCH 1


/// --- Package Macros Config --- ///
//#define ENABLE_GVAR_OVERWRITE_MITIGATION
//#define ENABLE_LOG_LEVEL_DEBUG


/// --- Integration Detaction --- ///
#if __has_include("modSettings.hpp")
    #include "modSettings.hpp"
    #include "modMacros.hpp"
#else
    #include "\x\CaSe\Addons\core\modSettings.hpp"
    #include "\x\CaSe\Addons\core\modMacros.hpp"
#endif


/// --- Package Specific Config --- ///

