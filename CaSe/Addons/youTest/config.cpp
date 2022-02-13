#include "config.hpp"

class CfgPatches {
    class ADDON {
        name = PACKAGE;
        units[] = {};
        weapons[] = {};
        requiredVersion = 2.06;
        requiredAddons[] = { QUOTE(UGLUE(MOD,core)), QUOTE(UGLUE(MOD,uiBits)) };
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
            DEFINE_FNC(codeHintRenderer)
            DEFINE_FNC(codeHintSet)
            DEFINE_FNC(init)
            DEFINE_FNC(loadTestsFromConfig)
            DEFINE_FNC(renderProgressBar)
            DEFINE_FNC(runTestCode)
            DEFINE_FNC(runTestItem)
            DEFINE_FNC(strCfgRoot)
        };
    };
};

// CaSe_YouTest
class UGLUE(MOD,YouTest) {
    // Name displayed on user interface. Will not by compiled as structured text.
    name = "";

    // Absolute path to file. Reccomend using $PBOPREFIX$ in your mod or addon. If it is a mission, use the path from mission root.
    path = "";

    // Function name of code to run. Path will take preference, however, if empty or the file cannot be found, then the function will be used.
    function = "";
};

// CaSe_YouTestCollection
class UGLUE(MOD,YouTestCollection) {
    // Name displayed on user interface. Will not by compiled as structured text.
    name = "";

    // Defines the order at which sub-classes will run. Failed tests will block proceeding tests.
    // Classnames must be subclasses and inherit youTest or youTestCollection.
    classnames[] = {}; // EG: classnames[] = {"add","subtract","multiply","divide"};
};

// class CfgCaSeYouTest {};
class CfgCaSeYouTest {
    class MOD {
        class PACKAGE {
            class Dummy : CaSe_YouTest {
                name = "Dummy";
                path = QUOTE(PACKAGE_FILE_SUB(Tests,dummy.sqf));
            };

            class DummySleep : CaSe_YouTest {
                name = "Dummy Sleep";
                path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleep.sqf));
            };

            class DummiesOrdered : CaSe_YouTestCollection {
                name = "Test Collection";
                classnames[] = {"Dummy", "DummySleep", "Dummy2", "Dumma"};

                class Dummy : CaSe_YouTest {
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummy.sqf));
                };
                class DummySleep : CaSe_YouTest {
                    name = "Dummy Sleep";
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleep.sqf));
                };
                class Dummy2 : CaSe_YouTest {
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummy.sqf));
                };
                class Dumma : CaSe_YouTest {
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummy.sqf));
                };
            };

            class LikelyToBreak {
                name = "Likely To Break";

                class Random1 : CaSe_YouTest {
                    name = "Sleep Random 1";
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleepRandom.sqf));
                };
                class Random2 : CaSe_YouTest {
                    name = "Sleep Random 2";
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleepRandom.sqf));
                };
                class Random3 : CaSe_YouTest {
                    name = "Sleep Random 3";
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleepRandom.sqf));
                };
                class Random4 : CaSe_YouTest {
                    name = "Sleep Random 4";
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleepRandom.sqf));
                };
                class Random5 : CaSe_YouTest {
                    name = "Sleep Random 5";
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleepRandom.sqf));
                };
                class Random6 : CaSe_YouTest {
                    name = "Sleep Random 6";
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleepRandom.sqf));
                };
                class Random7 : CaSe_YouTest {
                    name = "Sleep Random 7";
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleepRandom.sqf));
                };
                class Random8 : CaSe_YouTest {
                    name = "Sleep Random 8";
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleepRandom.sqf));
                };
                class Random9 : CaSe_YouTest {
                    name = "Sleep Random 9";
                    path = QUOTE(PACKAGE_FILE_SUB(Tests,dummySleepRandom.sqf));
                };
            }
        };
    };
};