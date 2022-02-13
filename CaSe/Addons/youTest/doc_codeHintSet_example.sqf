
private _fnc_typeHelloWorld = {
    ("Hello World! " select [0,floor (2 * time mod count "Hello World! ")]) + (["_","<t shadow='0' color='#00000000'>_</t>"] #floor (2*1.61803*time mod 2))
};
private _fnc_renderProgressBar = {
    params [
        ["_cache", createHashMap],
        ["_symbol", "|"],
        ["_timeOffset",0],
        ["_size", 1.5],
        ["_progressBarLength", 48],
        ["_waveLength", 0.5],
        ["_period", 0.5],
        ["_wasUnInitialised", true]
    ];
    if (_wasUnInitialised) then {
        _wasUnInitialised = false;
        _this resize 0;
        _this append [_cache, _symbol, _timeOffset, _size, _progressBarLength, _waveLength, _period, _wasUnInitialised];
    };

    private _menuBGColours = [ ["GUI_BCG_RGB_R",0.13], ["GUI_BCG_RGB_G",0.54], ["GUI_BCG_RGB_B",0.21] ] apply {profileNamespace getVariable _x};
    private _blackColour = [0,0,0];

    private _filled = floor (_progressBarLength * 1);
    private _unfilled = _progressBarLength - _filled;

    private _cachedMenuColour = _cache getOrDefault ["_cachedMenuColour", []];
    if (_cachedMenuColour isNotEqualTo _menuBGColours) then {
        _cache set ["_cachedMenuColour", _menuBGColours];

        private _progressBarRenderLength = _progressBarLength max (_waveLength * _progressBarLength);

        private _colourBarColour = [[_menuBGColours, _progressBarRenderLength] call CaSe_fnc_uiBits_repeatItem, 0, 1, true] call CaSe_fnc_uiBits_sineWaveArray;
        private _colourBarEmpty = [_blackColour, _progressBarLength] call CaSe_fnc_uiBits_repeatItem;

        private _progressBarInnerFilled = [];
        private _progressBarInnerEmpty = [];

        if (_symbol == "") then {
            _progressBarInnerFilled = _colourBarColour apply { parseText ("<img size='"+str _size+"' image='#(rgb,8,8,1)color("+str (_x#0)+","+str (_x#1)+","+str (_x#2)+",1)' />") };
            _progressBarInnerEmpty = _colourBarEmpty apply { parseText ("<img size='"+str _size+"' image='#(rgb,8,8,1)color(0,0,0,0)' />") };
        } else {
            _progressBarInnerFilled = _colourBarColour apply { parseText ("<t size='"+str _size+"' color='#"+ (_x call CaSe_fnc_uiBits_colourRatioToHex) +"' >"+_symbol+"</t>") };
            _progressBarInnerEmpty = _colourBarEmpty apply { parseText ("<t size='"+str _size+"' color='#"+ (_x call CaSe_fnc_uiBits_colourRatioToHex) +"' >"+_symbol+"</t>") };
        };

        _cache set ["_waveColourCache", _progressBarInnerFilled];
        _cache set ["_waveEmptyCache", _progressBarInnerEmpty];
    };

    private _progressBarInnerFilled = _cache getOrDefault ["_waveColourCache", []];
    private _progressBarInnerEmpty = _cache getOrDefault ["_waveEmptyCache", []];

    _progressBarInnerFilled = [+_progressBarInnerFilled, _period * (_timeOffset + time) * count _progressBarInnerFilled] call CaSe_fnc_uiBits_shiftArrayLeft select [0,_filled];
    _progressBarInnerEmpty = _progressBarInnerEmpty select [0,_unfilled];

    composeText ( flatten [_progressBarInnerFilled, _progressBarInnerEmpty]);
};

[ _fnc_typeHelloWorld, "<br/>", [_fnc_renderProgressBar, []],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0    , 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0.166, 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0.333, 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0.5  , 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0.666, 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0.833, 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 1    , 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0.833, 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0.666, 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0.5  , 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0.333, 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0.166, 0.5, 26, 1, 1]],
    "<br/>", [_fnc_renderProgressBar, [createHashMap, "", 0.5 * 0    , 0.5, 26, 1, 1]]

] call CaSe_fnc_youTest_codeHintSet;