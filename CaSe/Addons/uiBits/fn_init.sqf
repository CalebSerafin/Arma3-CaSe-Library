/*
Maintainer: Caleb Serafin
    Initialised typeRef used for verifying cancellation tokens.

Scope: All, Local Effect
Environment: Unscheduled
Public: Yes

Example:
    call CaSe_fnc_async_init;
*/
#include "config.hpp"
FIX_LINE_NUMBERS
RUN_ONLY_ONCE(init)

private _HSVToRGBPlugBoard = [
    {[_chroma,      _channelMid,0           ]},
    {[_channelMid,  _chroma,    0           ]},
    {[0,            _chroma,    _channelMid ]},
    {[0,            _channelMid,_chroma     ]},
    {[_channelMid,  0,          _chroma     ]},
    {[_chroma,      0,          _channelMid ]}
];
SETP(HSVToRGBPlugBoard, _HSVToRGBPlugBoard)
