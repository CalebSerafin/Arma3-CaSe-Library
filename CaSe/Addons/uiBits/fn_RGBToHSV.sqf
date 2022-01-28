/*
Maintainer: Caleb Serafin
    Converts ratio RGB into HSV.

Arguments:
    <SCALAR> Red ∈ [0,1]
    <SCALAR> Green ∈ [0,1]
    <SCALAR> Blue ∈ [0,1]

Return Array:
    <SCALAR> Hue ∈ [0,360)
    <SCALAR> Saturation ∈ [0,1]
    <SCALAR> Brightness ∈ [0,1]

Scope: Any
Environment:Any
Public: Yes

Example:
    [0, 0.5, 0] call CaSe_fnc_uiBits_RGBToHSV;  // [120, 1, 0.5]
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params ["_red", "_green", "_blue"];

private _channelMax = _red max _green max _blue;
private _channelMin = _red min _green min _blue;
private _channelChange = _channelMax - _channelMin;

// If chain is faster than switch. Yes the performance is desperately needed here.
private _hue = if (_channelChange == 0) then {
    0;
} else {
    if (_channelMax == _red) exitWith {
        60 * (((_green - _blue) / _channelChange) mod 6);
    };
    if (_channelMax == _green) exitWith {
        60 * (((_blue - _red) / _channelChange) + 2);
    };
    // _channelMax = _blue
    60 * (((_red - _green) / _channelChange) + 4);
};
private _saturation = if (_channelMax == 0) then { 0 } else { _channelChange / _channelMax };
private _value = _channelMax;

[_hue, _saturation, _value];
