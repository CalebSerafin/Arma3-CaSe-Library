/// --- Versioning --- ///
#define PACKAGE canRE
#define YEAR 22
#define MONTH 1
#define DAY 10
#define PATCH 1


/// --- Package Macros Config --- ///
//#define ENABLE_GVAR_OVERWRITE_MITIGATION


/// --- Integration Detaction --- ///
#if __has_include("modSettings.hpp")
    #include "modSettings.hpp"
    #include "modMacros.hpp"
#else
    #include "\x\CaSe\Addons\core\modSettings.hpp"
    #include "\x\CaSe\Addons\core\modMacros.hpp"
#endif


/// --- Package Specific Config --- ///
// Allows dynamic loading of functions from
#define ENABLE_LOAD_FROM_CFGFUNCTIONS
// Records an initial hash of the remote execution list.
#define ENABLE_RE_LIST_VALIDATION

