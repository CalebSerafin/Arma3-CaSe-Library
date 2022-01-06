/// --- Versioning --- ///
#define PACKAGE keyCache
#define YEAR 21
#define MONTH 12
#define DAY 24
#define PATCH 1

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
#define KEYCACHE_DEFAULT_TTL 120
