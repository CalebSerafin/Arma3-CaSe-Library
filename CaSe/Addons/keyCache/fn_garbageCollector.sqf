/*
Maintainer: Caleb Serafin
    Uptime-living process. Periodically deletes expired keyCache entries.
    Divides the generation into buckets to process over time.
    buckets are also cut into spans that are processed over time.
    This ensures there are no CPU spikes.

Scope: All
Environment: Scheduled
Public: No
Dependencies:
    <HASHMAP> CaSe_keyCache_DB
    <ARRAY> CaSe_keyCache_GC_generations
    <ARRAY> CaSe_keyCache_GC_gen0NewestBucket

Example:
    [] spawn CaSe_fnc_keyCache_garbageCollection;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_generationNumber", 0, [0]]
];

#ifndef __keyCache_unitTestMode
// Offset start of different generations.
uiSleep random 10;
#endif
FIX_LINE_NUMBERS

// Keep reference to local variable to avoid continuously using getVariable
private _keyCache_GC_generations = GETP(GC_generations);
private _keyCache_DB = GETP(DB);
private _keyCache_GC_registeredItems = GETP(GC_registeredItems);


if (_generationNumber >= count _keyCache_GC_generations) exitWith {
    LOG_ERROR("Invalid Generation ("+str _generationNumber+")");
};

private _GC_generation = _keyCache_GC_generations #_generationNumber;
private _const_nullTranslation = [nil,nil,1e39,nil];

while {true} do {
    // Reload config every cycle.
    _GC_generation params ["_allBuckets","_newestBucket","_totalPeriod","_bucketsAmount","_promotedGeneration"];

    // Add new bucket before oldest is popped.
    _newBucket = [];
    _GC_generation set [1,_newBucket];
    if (_generationNumber == 0) then {  // Special case for registerForGC speed 😉
        SETP(GC_gen0NewestBucket,_newBucket)
    };
    _allBuckets pushBack _newBucket;

    private _promotedGenerationReference = _keyCache_GC_generations #_promotedGeneration;

    // Grab oldest bucket.
    private _currentBucket = _allBuckets deleteAt 0;
    private _count = count _currentBucket;

    // If empty, take a nice rest.
    private _bucketPeriod = _totalPeriod / _bucketsAmount;
    if (_count == 0) then {
        //Info_2("Gen%1 GC Bucket empty. Sleeping for %2s.",_generationNumber,_bucketPeriod);
        //private _diag_returnTime = serverTime + _bucketPeriod;
        uiSleep _bucketPeriod;
        /*if (_diag_returnTime*1.20 < serverTime) then {
            Debug_3("Gen%1 GC bucket empty slept too long! %2s longer than %3s",_generationNumber,serverTime-_returnTime,_bucketPeriod);
        };*/
        continue;
    };


    // Calculate span sizes
    private _spanSize = 10;  // Minimum amount of items in a processed span of a chunk
    private _spanAmount = ceil (_count / _spanSize);
    private _spanPeriod = _bucketPeriod / _spanAmount;

    private _averageFrameTime = 1 / diag_fps;  // diag_fps is used because it's averaged over 16 frames, unlike of deltaTime.
    // If the break period is less than a frame, we need to process more items per frame.
    if (_spanPeriod < _averageFrameTime) then {
        _spanAmount = 1 + floor (_bucketPeriod / _averageFrameTime);
        _spanSize = ceil (_count / _spanAmount);
        _spanPeriod = 0.001;  // Try sleep just 1 frame, setting it to _averageFrameTime may result in more than 1 frame due to rounding and FPS fluctuations.
    };

    /*
#define __inc_deleted _GCDeleted = _GCDeleted +1;
#define __inc_promoted _GCPromoted = _GCPromoted +1;
    //Info_2("Gen%1 GC processing bucket size %2.",_generationNumber,_count);
    private _GCDeleted = 0;
    private _GCPromoted = 0;
    */
    // Process each span. Eventually finishing the whole bucket within _bucketPeriod;
    private _allocatedTime = serverTime + _bucketPeriod;
    for "_span" from 0 to _count step _spanSize do {
        {
            // If the key has expired or deleted, another key may be added to replace it and update the expiry before this block finishes.
            // So it should be in an unscheduled block.
            isNil {
                private _expiryTime = (_keyCache_DB getOrDefault [_x,_const_nullTranslation])#2;
                if (_expiryTime > serverTime) then {
                    if (finite _expiryTime) then {
                        _promotedGenerationReference#1 pushBack _x;  /*__inc_promoted;*/
                    } else {
                        // Expiry was updated to be infinite.
                        _keyCache_GC_registeredItems deleteAt _x;
                    };
                    continue;
                };
                _keyCache_GC_registeredItems deleteAt _x;
                _x call FNCP(drop);
                /*__inc_deleted;*/
            };
        } forEach (_currentBucket select [_span, _spanSize]);
        uiSleep (_allocatedTime - serverTime);  // uiSleep does not crash from negative input.
    };

    /*if (_allocatedTime < serverTime) then {
        Debug_3("Gen%1 GC bucket processing exceeded allocated time of %2s by %3s.",_generationNumber,_spanPeriod,serverTime-_allocatedTime);
    };
    Info_4("Gen%1 GC Deleted/Skipped %2, Promoted %3. ",_generationNumber,_GCDeleted,_GCPromoted);*/
};
