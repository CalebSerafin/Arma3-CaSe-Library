/// --- Name --- ///
#define MOD CaSe

/// --- Testing --- ///
//#define ENABLE_LOG_LEVEL_DEBUG
//#define DISABLE_AUTO_INIT

/// --- Testing NOT IMPLIMENTED, DOES NOTHING --- ///
//#define ENABLE_VAR_LOGGING

//#define ENABLE_VAR_REVERT  // Requires Macro Package: macroPackageTests.hpp
//#define ENABLE_GVAR_ISOLATION  // Requires Macro Package: macroPackageTests.hpp

//#define ENABLE_TESTS  // Requires Package: tests

//#define ENABLE_DEBUG_UI  // Requires Package: profiling
//#define ENABLE_PROFILING  // Requires Package: profiling
//#define ENABLE_CALL_STEPPING  // Requires Package: profiling

  // Requires Package: macroInterpreter, sandbox, tests




/// --- Package Macros Config --- ///
//#define ENABLE_GVAR_OVERWRITE_MITIGATION


// Rename strings if package or mod names change. __has_include is evaluated before macros.
#define HAS_PACKAGE_LOGGING           __has_include("\x\CaSe\Addons\logging\$PBOPREFIX$")
#define HAS_PACKAGE_TESTS             __has_include("\x\CaSe\Addons\test\$PBOPREFIX$")
#define HAS_PACKAGE_PROFILING         __has_include("\x\CaSe\Addons\profiling\$PBOPREFIX$")
#define HAS_PACKAGE_MACROINTERPRETER  __has_include("\x\CaSe\Addons\macroInterpreter\$PBOPREFIX$")
#define HAS_PACKAGE_SANDBOX           __has_include("\x\CaSe\Addons\sandbox\$PBOPREFIX$")

/// --- Installation Configuration --- ////
// Specifies where calsses are defined. Change if packaged into mission or campaign.
#define LOCAL_CONFIG configFile