#include "config.hpp"

class CfgPatches {
    class ADDON {
        name = PACKAGE;
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.06;
        requiredAddons[] = { QUOTE(UGLUE(MOD,core)), QUOTE(UGLUE(MOD,uintToHex)) };
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
            DEFINE_FNC(colourRatioToHex)
            DEFINE_FNC(HSVToRGB)
            DEFINE_FNC(init)
            DEFINE_FNC(repeatItem)
            DEFINE_FNC(RGBToHSV)
            DEFINE_FNC(shiftArrayLeft)
            DEFINE_FNC(sineBlend)
            DEFINE_FNC(sineWaveArray)
        };
    };
};
