/*
Maintainer: Caleb Serafin
    Creates a progress bar string with pulsing animation.
    Progress bar is coloured according to Arma's menu background.
    Supports caching when called multiple times if the argument array stays the same.

Arguments:
    0. <SCALAR> The ratio of completion.
    1. <SCALAR> Time offset used for sine wave animation.
    2. <SCALAR> Font size used for symbols.
    3. <SCALAR> Character length of the progress bar.
    4. <STRING> The symbol used for progress.
    5. <SCALAR> The length of each wave relative to the progress bar length.
    6. <SCALAR> The duration of each wave.
    // Do not insert more variables

Return Value:
    <STRING> Structured text to be parsed.

Scope: Clients
Environment: Any
Public: Yes

Example:
    [] call CaSe_fnc_youTest_renderProgressBar;
    [_ratio, _timeOffset, _fontSize, _progressBarLength, _symbol, _waveLength, _period] call CaSe_fnc_youTest_renderProgressBar;

    // NB, if used in a loop, please call this way to utilise caching
    private _renderProgressArg = [_ratio, _timeOffset, _fontSize, _progressBarLength, _symbol, _waveLength, _period];
    while {true} do {
        _renderProgressArg call CaSe_fnc_youTest_renderProgressBar;
    }
*/
#include "config.hpp"
FIX_LINE_NUMBERS

params [
    ["_ratio", 0, [0] ],
    ["_timeOffset", 0, [0] ],
    ["_fontSize", 1.5, [0] ],

    ["_progressBarLength", 48, [0] ],
    ["_symbol", "|", [""] ],
    ["_waveLength", 0.5, [0] ],

    ["_period", 2, [0] ],
    ["_cache", false]
];

if (_cache isEqualType false) then {
    _cache = createHashMap;
    _this resize 7;
    _this pushBack _cache;  // Allows the cache to persist if the same argument array is used for calling
};

_ratio = 0 max _ratio min 1;

private _menuBGColours = [ ["GUI_BCG_RGB_R",0.13], ["GUI_BCG_RGB_G",0.54], ["GUI_BCG_RGB_B",0.21] ] apply {profileNamespace getVariable _x};
private _blackColour = [0.2, 0.2, 0.2];

private _filled = floor (_progressBarLength * _ratio);
private _unfilled = _progressBarLength - _filled;

private _cachedMenuColour = _cache getOrDefault ["_cachedMenuColour", []];
if (_cachedMenuColour isNotEqualTo _menuBGColours) then {
    _cache set ["_cachedMenuColour", _menuBGColours];

    private _progressBarRenderLength = _progressBarLength max (_waveLength * _progressBarLength);

    private _colourBarColour = [[_menuBGColours, _progressBarRenderLength] call FNCG(uiBits,repeatItem), 0, 1, true] call FNCG(uiBits,sineWaveArray);

    private _progressBarInnerFilled = [];
    private _progressBarInnerEmpty = [];

    if (_symbol == "") then {
        _progressBarInnerFilled = _colourBarColour apply { ("<img image='#(rgb,8,8,1)color("+str (_x#0)+","+str (_x#1)+","+str (_x#2)+",1)' />") };
        _progressBarInnerEmpty = ["<img image='#(rgb,8,8,1)color("+(_blackColour#0)+","+(_blackColour#1)+","+(_blackColour#2)+",1)' />", _progressBarLength] call FNCG(uiBits,repeatItem);;
    } else {
        _progressBarInnerFilled = _colourBarColour apply { ("<t color='#"+ (_x call FNCG(uiBits,colourRatioToHex)) +"' >"+_symbol+"</t>") };
        _progressBarInnerEmpty = [_symbol, _progressBarLength] call FNCG(uiBits,repeatItem);
    };

    _cache set ["_waveColourCache", _progressBarInnerFilled];
    _cache set ["_waveEmptyCache", _progressBarInnerEmpty];
    _cache set ["_blackHexColour", _blackColour call FNCG(uiBits,colourRatioToHex)];
};

private _progressBarInnerFilled = _cache getOrDefault ["_waveColourCache", []];
private _progressBarInnerEmpty = _cache getOrDefault ["_waveEmptyCache", []];
private _blackHexColour = _cache getOrDefault ["_blackHexColour", []];

_progressBarStringFilled = [+_progressBarInnerFilled, (_timeOffset + time) * count _progressBarInnerFilled / _period] call FNCG(uiBits,shiftArrayLeft) select [0,_filled] joinString "";
_progressBarStringEmpty = _progressBarInnerEmpty select [_filled,_unfilled] joinString "";

private _progressBar = "<t size='"+str _fontSize+"' >" + _progressBarStringFilled + "<t color='#" + _blackHexColour + "' >" + _progressBarStringEmpty + "</t></t>";

_progressBar;

