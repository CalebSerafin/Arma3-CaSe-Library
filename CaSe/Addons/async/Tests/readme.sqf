/*
Run in order.
Make sure previous test finishes before starting next.
If the previous test failed, it's likely that the following will too.
*/

// Recommended
call compileScript ["x\CaSe\Addons\async\Tests\unitTest_newTask_empty.sqf"];
call compileScript ["x\CaSe\Addons\async\Tests\unitTest_newTask_code.sqf"];
