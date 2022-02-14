/// --- Versioning --- ///
#define PACKAGE cancellationToken
#define YEAR 22
#define MONTH 1
#define DAY 14
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
#define TEST_DIRECTORY_PATH "\x\CaSe\Addons\cancellationToken\Tests\"
#define TEST_HINT(Title,Message) hint parseText (Title + "<br/>" + Message);

#define CTOKEN_PARAM_COUNT 4
#define CTOKEN_PARAM_TYPES [[], false, scriptNull, []]

#define CTOKEN_I_TYPE_REF 0
#define CTOKEN_I_IS_CANCELLED 1
#define CTOKEN_I_TIMER_HANDLE 2
#define CTOKEN_I_REGISTERED_CODE 3

#define VALIDATE_CANCELLATION_TOKEN(CToken) if (CToken SHARP##CTOKEN_I_TYPE_REF isNotEqualTo GETP(typeRef)) exitWith { if (CToken isEqualTypeParams CTOKEN_PARAM_TYPES) then {LOG_ERROR("Invalid cancellationToken. Tokens cannot be deep-copied or transferred over the network.")} else {LOG_ERROR("CancellationToken was not passed in.")} };
#define VALIDATE_CANCELLATION_TOKEN_ARRAY(CTokenArray) if (CTokenArray findIf {_x SHARP##CTOKEN_I_TYPE_REF isNotEqualTo GETP(typeRef)} != -1) exitWith { LOG_ERROR("Invalid cancellationToken. Tokens cannot be deep-copied or transferred over the network.") };
