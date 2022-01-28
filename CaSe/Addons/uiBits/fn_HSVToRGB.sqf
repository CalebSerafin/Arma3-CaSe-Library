/*
Maintainer: Caleb Serafin
    Converts HSV into ratio RGB.

Arguments:
    <SCALAR> Hue ∈ [0,360)
    <SCALAR> Saturation ∈ [0,1]
    <SCALAR> Brightness ∈ [0,1]

Return Array:
    <SCALAR> Red ∈ [0,1]
    <SCALAR> Green ∈ [0,1]
    <SCALAR> Blue ∈ [0,1]

Scope: Any
Environment:Any
Public: Yes

Example:
    [120, 1, 0.5] call CaSe_fnc_uiBits_HSVToRGB;  // [0, 0.5, 0]
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params ["_hue", "_saturation", "_value"];

private _chroma = _saturation * _value;
private _hueSector = (_hue mod 360) / 60;

private _channelMax = _value;
private _channelMid = _chroma * (1 - abs (_hueSector mod 2 - 1) );
private _channelMin = _value - _chroma;

private _redGreenBlueDark = 0 call ( GETP(HSVToRGBPlugBoard) #(floor _hueSector) );

_redGreenBlueDark apply { _x + _channelMin };
