#include "config.hpp"

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

class CfgFunctions {
    class MOD {
        class PACKAGE {
            DEFINE_FNC(check)
            DEFINE_FNC(empty)
            DEFINE_FNC(finaliseREList)
            DEFINE_FNC(init)
            DEFINE_FNC(loadFromCfgFunctions)
            DEFINE_FNC(loadFromCfgRemoteExec)
            DEFINE_FNC(validateREList)
        };
    };
};

class CfgRemoteExec {
    class Functions {
        mode = 1;           // 0: Completely blocked,   1: Blocked by default,      2: Allow All
        jip = 1;            // 0: No JIP,               1: JIP Allowed
        allowedTargets = 0; // 0: All machines,         1: Only to other clients,   2: Only to server

        BLOCK_FNC_RE(check)
        ALLOW_FNC_RE(empty)
        BLOCK_FNC_RE(finaliseREList)
        BLOCK_FNC_RE(init)
        BLOCK_FNC_RE(loadFromCfgFunctions)
        BLOCK_FNC_RE(loadFromCfgRemoteExec)
        BLOCK_FNC_RE(validateREList)
    };

    class Commands {
        mode = 1;           // 0: Completely blocked,   1: Blocked by default,      2: Allow All
        jip = 1;            // 0: No JIP,               1: JIP Allowed
        allowedTargets = 0; // 0: All machines,         1: Only to other clients,   2: Only to server

        ALLOW_CMD_RE(hint)
    };
};
