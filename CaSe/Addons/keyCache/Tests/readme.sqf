/*
Run in order.
Make sure previous test finishes before starting next.
If the previous test failed, it's likely that the following will too.
*/

// Recommended
call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_garbageCollector_basicPromotion.sqf"];
call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_garbageCollector_timedPromotion.sqf"];
call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_garbageCollector_basicDeletion.sqf"];

call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_set_noExpiry.sqf"];
call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_set_expiry.sqf"];
call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_has_unexpired.sqf"];
call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_has_expired.sqf"];

call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_get_unexpired.sqf"];
call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_get_expired.sqf"];
call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_drop_unexpired.sqf"];
call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_drop_expired.sqf"];
call compileScript ["x\CaSe\Addons\keyCache\Tests\unitTest_refresh.sqf"];

// Will take ≈10 minutes. Game will still run at 60fps.
call compileScript ["x\CaSe\Addons\keyCache\Tests\stressTest_garbageCollector_short.sqf"];

// Not recommended for common testing
// Will take ≈2 hours 46 minutes. Game will still run at 60fps.
call compileScript ["x\CaSe\Addons\keyCache\Tests\stressTest_garbageCollector_long.sqf"];
