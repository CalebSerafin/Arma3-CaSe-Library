/*
Maintainer: Caleb Serafin
    Eases the transition between 0 and 1 to be the leading edge of a sine curve.
    sine is very similar to the Bézier curve used for CSS ease-in-and-out animations.
    Is continuos like sine, so it will act like waves if the input ∉ [0,1].

Arguments:
    <SCALAR> Linear input.

Return Value:
    <SCALAR> Eased output.

Scope: Any
Environment: Any
Public: Yes

Example:
    0    call CaSe_fnc_uiBits_sineBlend;  // 0
    0.25 call CaSe_fnc_uiBits_sineBlend;  // ~0.146446
    0.5  call CaSe_fnc_uiBits_sineBlend;  // 0.5
    0.25 call CaSe_fnc_uiBits_sineBlend;  // ~0.853553
    1    call CaSe_fnc_uiBits_sineBlend;  // 1
*/
#include "config.hpp"
FIX_LINE_NUMBERS

0.5 * (-cos (180 * _this) + 1);
