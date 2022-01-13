/// --- Versioning --- ///
#define PACKAGE async
#define YEAR 22
#define MONTH 1
#define DAY 13
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
#define ASYNC_TEST_DIRECTORY_PATH "\x\CaSe\Addons\async\Tests\"
#define ASYNC_TEST_HINT(Title,Message) hint parseText (Title + "<br/>" + Message);

#define TASK_PARAM_COUNT 4

#define TASK_I_LOCAL_REF 0
#define TASK_I_HAS_RETURNED 1
#define TASK_I_RETURN_VALUE 2
#define TASK_I_WHEN_CODE 3

#define TASK_D_TIMEOUT 60
// 15Hz for one second, 4Hz for 5 seconds, 1Hz for 10 seconds, 5secλ for 30 seconds, 20secλ for remaining time.
#define TASK_D_POLLING_PATTERN [[15, 20, 10, 6, 1], [0.06666667, 0.25, 1, 5, 20]]

#define VALIDATE_ASYNC_TASK(AsyncTask) if (AsyncTask SHARP##TASK_I_LOCAL_REF isNotEqualTo GETP(localRef)) exitWith { LOG_ERROR("Invalid AsyncTask. Async tasks cannot be deep-copied or transferred over the network.") };
