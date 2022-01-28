/*
Maintainer: Caleb Serafin
    Consumes an array of colours and generates a sinusoid wave pattern.
    Brightness is increased using RGB channel brightness boosting can be used.
    Alternatively, HSV value and saturation can be used instead for better perception at a performance cost.

Arguments:
    <ARRAY<SCALAR,SCALAR,SCALAR>> Array of colours
    <SCALAR> Period position offset for wave. [0,1) and repeats. (Default = 0)
    <SCALAR> Wavelength in proportion to input array. (Default = 1)
    <BOOLEAN> True to use HSV brightness boosting, false to use RGB channel boosting. (Default = false);

Return Value:
     <ARRAY<SCALAR,SCALAR,SCALAR>> Array of modified colours.

Scope: Any
Environment: Any
Public: Yes

Example:
    call CaSe_fnc_uiBits_sineWaveArray;
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params ["_colourVectors", ["_offset",0], ["_waveLength",1], ["_useHSVBoost", false]];

private _outputArray = [];
private _countWaveLengthProduct = count _colourVectors * _waveLength / 2;  // The 2 corrects for sineBlend half period.
_offset = _offset * 2;  // The 2 corrects for sineBlend half period.

private _fnc_boostBrightness = if (_useHSVBoost) then {{
    _this call FNCP(RGBToHSV) params ["_hue","_saturation","_value"];

    _value = _value + _brightnessBoost * (1 - _value);
    _saturation = _saturation + _brightnessBoost * (0.5 - _saturation);  // Move saturation to middle to make it brighter.

    [_hue,_saturation,_value] call FNCP(HSVToRGB);
}} else {{
    _this apply {_x + _brightnessBoost * 0.69 * (1 - _x)};  // The 0.69 tries to prevent a white out due to the basic technique.
}};

{
    private _brightnessBoost = (_forEachIndex / _countWaveLengthProduct  - _offset) call FNCP(sineBlend);
    _outputArray pushBack (_x call _fnc_boostBrightness);
} forEach _colourVectors;
_outputArray;
