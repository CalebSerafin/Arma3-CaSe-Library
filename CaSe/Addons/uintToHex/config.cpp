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
            DEFINE_FNC(init)
            DEFINE_FNC(u12)
            DEFINE_FNC(u16)
            DEFINE_FNC(u20)
            DEFINE_FNC(u24)
        };
    };
};

class CfgRemoteExec {
    class Functions {
        mode = 1;           // 0: Completely blocked,   1: Blocked by default,      2: Allow All
        jip = 1;            // 0: No JIP,               1: JIP Allowed
        allowedTargets = 0; // 0: All machines,         1: Only to other clients,   2: Only to server

        BLOCK_FNC_RE(init)
        BLOCK_FNC_RE(u12)
        BLOCK_FNC_RE(u16)
        BLOCK_FNC_RE(u20)
        BLOCK_FNC_RE(u24)
    };
};
