/*
Run in order.
Make sure previous test finishes before starting next.
If the previous test failed, it's likely that the following will too.
*/

// Recommended
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_new_empty.sqf"];
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_new_delay.sqf"];

call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_isCancelled.sqf"];
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_dispose.sqf"];

call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_cancel_empty.sqf"];
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_cancel_delay.sqf"];
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_cancel_code.sqf"];
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_cancel_unregistered.sqf"];

call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_register_noArg.sqf"];
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_register_arg.sqf"];

call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_unregister.sqf"];

call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_cancelAfter_basic.sqf"];
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_cancelAfter_resetTimer.sqf"];
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_cancelAfter_immediate.sqf"];

call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_createLinked_basic.sqf"];
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_createLinked_cleanUp.sqf"];
call compileScript ["x\CaSe\Addons\cancellationToken\Tests\unitTest_createLinked_immediate.sqf"];