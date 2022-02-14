/// --- Versioning --- ///
#define PACKAGE uintToHex
#define YEAR 21
#define MONTH 12
#define DAY 24
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
// Default Time to live for translations.
#define UINTTOHEX_TEST_DIRECTORY_PATH "\x\CaSe\Addons\uintToHex\Tests\"

#define UINTTOHEX_TEST_HINT(title,message) hint parseText (title + "<br/>" + message);
