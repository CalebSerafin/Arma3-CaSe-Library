// First. This code will create a string that is 512 Kb.
Dev_longString = "T";
Dev_longString_handle = [] spawn {
    private _id = str floor random 10000;
    systemChat ("Started ID: " + _id);
    for "_i" from 1 to 19 do {
        Dev_longString = Dev_longString + Dev_longString;
    };
    systemChat ("Done ID: " + _id);
};


// Then. This code will create arrays that are each 1Gb, if they are GCed when pressure gets high, the memory will no grow out of control.
Dev_longString_gc_handle = [] spawn {
    private _id = str floor random 10000;
    systemChat ("Started ID: " + _id);
    for "_run" from 0 to 16 do {
        systemChat ("Started ID: " + _id);
        private _scopedGigabyte = [];
        for "_i" from 1 to 2000 do {
            private _randomLetter = toString [33 + floor random 93];
            private _randomLongString = Dev_longString + _randomLetter;
            _scopedGigabyte pushBack _randomLongString;
        };
    };
    systemChat ("Done ID: " + _id);
};


// Third. This code will create arrays that are each 1Gb, and then it will recurse reference them to itself using a hashMap.
// If the GC catches the self references, it will be GCed according to pressure.
Dev_longString_gc_handle = [] spawn {
    private _id = str floor random 10000;
    systemChat ("Started ID: " + _id);
    for "_run" from 0 to 16 do {
        systemChat ("Run Number: " + str _run);
        private _scopedGigabyte = [];
        for "_i" from 1 to 2000 do {
            private _randomLetter = toString [33 + floor random 93];
            private _randomLongString = Dev_longString + _randomLetter;
            _scopedGigabyte pushBack _randomLongString;
        };
        private _hashMap = createHashMap;
        _scopedGigabyte pushBack _hashMap;
        _hashMap set [0, _scopedGigabyte];  // This should cause a memory leak according to the warning str gives you.
    };
    systemChat ("Done ID: " + _id);
};
