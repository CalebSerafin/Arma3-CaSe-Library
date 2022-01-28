/// --- Versioning --- ///
#define PACKAGE uiBits
#define YEAR 22
#define MONTH 1
#define DAY 16
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
#define TEST_DIRECTORY_PATH "\x\CaSe\Addons\uiBits\ManualTests\"
#define TEST_HINT(Title,Message) hint parseText (Title + "<br/>" + Message);

