/*
Requires the following to be defined before the include. Example:

#define PACKAGE Core
#define YEAR 21
#define MONTH 12
#define DAY 23
#define PATCH 1
*/


/// --- Manipulation --- ///
#define REFLECT(X) X
#define SHARP REFLECT(#)
#define QUOTE(X) #X

#define GLUE(A,B)                 A##B
#define GLUE_2(A,B)               A##B
#define GLUE_3(A,B,C)             A##B##C
#define GLUE_4(A,B,C,D)           A##B##C##D
#define GLUE_5(A,B,C,D,E)         A##B##C##D##E
#define GLUE_6(A,B,C,D,E,F)       A##B##C##D##E##F
#define GLUE_7(A,B,C,D,E,F,G)     A##B##C##D##E##F##G
#define GLUE_8(A,B,C,D,E,F,G,H)   A##B##C##D##E##F##G##H

#define SYM_GLUE(SYM,A,B)                 A##SYM##B
#define SYM_GLUE_2(SYM,A,B)               A##SYM##B
#define SYM_GLUE_3(SYM,A,B,C)             A##SYM##B##SYM##C
#define SYM_GLUE_4(SYM,A,B,C,D)           A##SYM##B##SYM##C##SYM##D
#define SYM_GLUE_5(SYM,A,B,C,D,E)         A##SYM##B##SYM##C##SYM##D##SYM##E
#define SYM_GLUE_6(SYM,A,B,C,D,E,F)       A##SYM##B##SYM##C##SYM##D##SYM##E##SYM##F
#define SYM_GLUE_7(SYM,A,B,C,D,E,F,G)     A##SYM##B##SYM##C##SYM##D##SYM##E##SYM##F##SYM##G
#define SYM_GLUE_8(SYM,A,B,C,D,E,F,G,H)   A##SYM##B##SYM##C##SYM##D##SYM##E##SYM##F##SYM##G##SYM##H

#define UGLUE(A,B)                  SYM_GLUE(_,A,B)
#define UGLUE_2(A,B)                SYM_GLUE(_,A,B)
#define UGLUE_3(A,B,C)              SYM_GLUE_3(_,A,B,C)
#define UGLUE_4(A,B,C,D)            SYM_GLUE_4(_,A,B,C,D)
#define UGLUE_5(A,B,C,D,E)          SYM_GLUE_5(_,A,B,C,D,E)
#define UGLUE_6(A,B,C,D,E,F)        SYM_GLUE_6(_,A,B,C,D,E,F)
#define UGLUE_7(A,B,C,D,E,F,G)      SYM_GLUE_7(_,A,B,C,D,E,F,G)
#define UGLUE_8(A,B,C,D,E,F,G,H)    SYM_GLUE_8(_,A,B,C,D,E,F,G,H)

#define USCORE(A) _##A
#define DOTSQF(File) File##.sqf
#define DOTFSM(File) File##.fsm
#define FNFUNC(Func) fn_##Func


/// --- Line Numbers --- ///
#define FIX_LINE_NUMBERS SHARP##line __LINE__ __FILE__


/// --- Versioning --- ///
#define ADDON UGLUE(MOD,PACKAGE)
#define VERSION_NUM   YEAR##MONTH##DAY.PATCH
#define VERSION_STR   YEAR.MONTH.DAY.PATCH
#define VERSION_ARRAY YEAR,MONTH,DAY,PATCH


/// --- File Paths --- ///
#define PATH_A3(Pbo,Filepath)       \a3\Pbo\Filepath
#define PATH_MOD(Tag,Package,File)  \x\Tag\Addons\Package\File
#define PATH_CASE(Package,File)     PATH_MOD(MOD,Package,File)
#define PATH_PACKAGE(File)          PATH_CASE(PACKAGE,File)


/// --- Logging --- ///
#if HAS_PACKAGE_LOGGING
    #define LOG(Type,Message) [Type,Message] call UGLUE_4(MOD,fnc,logging,log);
    #define LOG_S(Type,Message) [Type,Message] call UGLUE_4(MOD,fnc,logging,logServer);
#else
    #define LOG_FORMAT(Sender,Type,Message) ((systemTimeUTC apply {str _x} joinString "-") + " | " + str Sender + " | " + Type + " | " + Message)  // No Padding on system time
    #define LOG(Type,Message) diag_log text LOG_FORMAT(clientOwner,Type,Message);
    #define LOG_S(Type,Message) LOG_FORMAT(clientOwner,Type,Message) remoteExec ["diag_log",2];  // Log line will be wrapped in string
#endif


#ifdef ENABLE_LOG_LEVEL_DEBUG
    #define LOG_DEBUG(Message) LOG("DEBUG",Message)
#else
    #define LOG_DEBUG(Message)
#endif

#define LOG_INFO(Message) LOG("INFO",Message)
#define LOG_WARN(Message) LOG("WARN",Message)
#define LOG_ERROR(Message) LOG("ERROR",Message)

#define LOG_S_DEBUG(Message) LOG_S("DEBUG",Message)
#define LOG_S_INFO(Message) LOG_S("INFO",Message)
#define LOG_S_WARN(Message) LOG_S("WARN",Message)
#define LOG_S_ERROR(Message) LOG_S("ERROR",Message)


/// --- GVAR Logging --- ///
#if HAS_PACKAGE_LOGGING
    #define VAR_STRING_VALUE(Value) call UGLUE_4(MOD,fnc,logging,stringValue)
    #define VAR_STRING_NAME(Name) GVAR_STRING_VALUE(Name)
#else
    #define VAR_STRING_VALUE(Value) typeName Value
    #define VAR_STRING_NAME(Name) str Name
#endif

#ifdef ENABLE_VAR_LOGGING
    #define VAR_LOG_SET(Namespace,Name,Value) call {LOG_DEBUG("GVAR SET ("+VAR_STRING_NAME(Name)+") to ("+VAR_STRING_VALUE(Value)+")"); Name}
    #define VAR_LOG_GET(Namespace,Name,Return) call {LOG_DEBUG("GVAR GET ("+VAR_STRING_NAME(Name)+") was ("+VAR_STRING_VALUE(Return)+")"); Name}
    #define VAR_LOG_GET_D(Namespace,Name,Return,Default) call {LOG_DEBUG("GVAR GET_D ("+VAR_STRING_NAME(Name)+") was ("+VAR_STRING_VALUE(Return)+") default ("+VAR_STRING_VALUE(Default)+")"); Name}
#else
    #define VAR_LOG_SET(Namespace,Name,Value) Name
    #define VAR_LOG_GET(Namespace,Name,Return) Name
    #define VAR_LOG_GET_D(Namespace,Name,Return,Default) Name
#endif


/// --- Variable Revert --- ///
#ifdef ENABLE_VAR_REVERT
    #define VAR_REVERT_SET_VARIABLE(Namespace,Name) call {\
        if (isNil "_CaSe_enableVarRevert") exitWith {Name};\
        if (isNil QUOTE(UGLUE(MOD,varNSRevertList))) then {\
            UGLUE(MOD,varNSRevertList) = createHashmap;\
        };\
        if !(QUOTE(PACKAGE) in UGLUE(MOD,varNSRevertList)) then {\
            UGLUE(MOD,varNSRevertList) set [PACKAGE, createHashmap];\
        };\
        private _undoList = UGLUE(MOD,varNSRevertList) get QUOTE(PACKAGE);\
        private _key = [Namespace,Name];\
        if !(_key in _undoList) then {\
            _undoList set [_key,Namespace getVariable Name];\
        };\
        Name\
    }
    #define VAR_REVERT_SET(Package,Name) call {\
        if (isNil "_CaSe_enableVarRevert") exitWith {Name};\
        if (isNil QUOTE(UGLUE(MOD,varRevertList))) then {\
            UGLUE(MOD,varRevertList) = createHashmap;\
        };\
        if !(QUOTE(PACKAGE) in UGLUE(MOD,varRevertList)) then {\
            UGLUE(MOD,varRevertList) set [PACKAGE, createHashmap];\
        };\
        private _undoList = UGLUE(MOD,varRevertList) get QUOTE(PACKAGE);\
        private _key = [Package,Name];\
        if !(_key in _undoList) then {\
            _undoList set [_key,Namespace getVariable Name];\
        };\
        Name\
    }
#else
    #define VAR_REVERT_SET_VARIABLE(Namespace,Name) Name
    #define VAR_REVERT_SET(Package,Name) Name
#endif


/// --- Global Variable Overwrite Mitigation --- ///
#ifdef ENABLE_GVAR_OVERWRITE_MITIGATION
    #define SET_GENERIC(Name,Value) localNamespace setVariable [QUOTE(Name), Value];
    #define GET_GENERIC(Name) (localNamespace getVariable QUOTE(Name))
#else
    #define SET_GENERIC(Name,Value) Name = Value;
    #define GET_GENERIC(Name) Name
#endif


/// --- GVAR --- ///
#define SET_VARIABLE(Namespace,Name,Value) Namespace setVariable [QUOTE(Name),Value]; GVAR_LOG_SET(Namespace,Name,Value);
#define GET_VARIABLE(Namespace,Name) Namespace getVariable QUOTE(Name);
#define GET_VARIABLE_D(Namespace,Name,Default) (Namespace getVariable [QUOTE(Name),Default])


#define GVAR(Name) UGLUE_3(MOD,G,Name)
#define SETG(Name,Value) SET_GENERIC(GVAR(Name),Value);
#define GETG(Name) GET_GENERIC(GVAR(Name))

#define PVAR(Name) UGLUE_3(MOD,PACKAGE,Name)
#define SETP(Name,Value) SET_GENERIC(PVAR(Name),Value);
#define GETP(Name) GET_GENERIC(PVAR(Name))


/// --- Calling Functions --- ///
#define FNCG(Package,Name)  UGLUE_4(MOD,fnc,Package,Name)
#define FNCP(Name)          FNCG(PACKAGE,Name)


/// --- CfgFunction Ease of Use --- ///
#define FNC_FOLDER_PATH SYM_GLUE_4(\,\x,MOD,Addons,PACKAGE)
#define FNC_SUBFOLDER_PATH(Folder) FNC_FOLDER_PATH##\##Folder

#define DEFINE_FNC(Name) class UGLUE(PACKAGE,Name) {\
    file = QUOTE(FNC_SUBFOLDER_PATH(UGLUE(fn,Name.sqf)));\
    recompile = 1;\
};


/// --- CfgRemoteExec Ease of Use --- ///
#define ALLOW_FNC_RE(Name) class UGLUE(MOD,fnc,PACKAGE,Name) {};
#define BLOCK_FNC_RE(Name)
