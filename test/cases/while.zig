const assert = @import("std").debug.assert;

test "while loop" {
    var i: i32 = 0;
    while (i < 4) {
        i += 1;
    }
    assert(i == 4);
    assert(whileLoop1() == 1);
}
fn whileLoop1() i32 {
    return whileLoop2();
}
fn whileLoop2() i32 {
    while (true) {
        return 1;
    }
}
test "static eval while" {
    assert(static_eval_while_number == 1);
}
const static_eval_while_number = staticWhileLoop1();
fn staticWhileLoop1() i32 {
    return whileLoop2();
}
fn staticWhileLoop2() i32 {
    while (true) {
        return 1;
    }
}

test "continue and break" {
    runContinueAndBreakTest();
    assert(continue_and_break_counter == 8);
}
var continue_and_break_counter: i32 = 0;
fn runContinueAndBreakTest() void {
    var i: i32 = 0;
    while (true) {
        continue_and_break_counter += 2;
        i += 1;
        if (i < 4) {
            continue;
        }
        break;
    }
    assert(i == 4);
}

test "return with implicit cast from while loop" {
    returnWithImplicitCastFromWhileLoopTest() catch unreachable;
}
fn returnWithImplicitCastFromWhileLoopTest() error!void {
    while (true) {
        return;
    }
}

test "while with continue expression" {
    var sum: i32 = 0;
    {
        var i: i32 = 0;
        while (i < 10) : (i += 1) {
            if (i == 5) continue;
            sum += i;
        }
    }
    assert(sum == 40);
}

test "while with else" {
    var sum: i32 = 0;
    var i: i32 = 0;
    var got_else: i32 = 0;
    while (i < 10) : (i += 1) {
        sum += 1;
    } else {
        got_else += 1;
    }
    assert(sum == 10);
    assert(got_else == 1);
}

test "while with nullable as condition" {
    numbers_left = 10;
    var sum: i32 = 0;
    while (getNumberOrNull()) |value| {
        sum += value;
    }
    assert(sum == 45);
}

test "while with nullable as condition with else" {
    numbers_left = 10;
    var sum: i32 = 0;
    var got_else: i32 = 0;
    while (getNumberOrNull()) |value| {
        sum += value;
        assert(got_else == 0);
    } else {
        got_else += 1;
    }
    assert(sum == 45);
    assert(got_else == 1);
}

test "while with error union condition" {
    numbers_left = 10;
    var sum: i32 = 0;
    var got_else: i32 = 0;
    while (getNumberOrErr()) |value| {
        sum += value;
    } else |err| {
        assert(err == error.OutOfNumbers);
        got_else += 1;
    }
    assert(sum == 45);
    assert(got_else == 1);
}

var numbers_left: i32 = undefined;
fn getNumberOrErr() error!i32 {
    return if (numbers_left == 0) error.OutOfNumbers else x: {
        numbers_left -= 1;
        break :x numbers_left;
    };
}
fn getNumberOrNull() ?i32 {
    return if (numbers_left == 0) null else x: {
        numbers_left -= 1;
        break :x numbers_left;
    };
}

test "while on nullable with else result follow else prong" {
    const result = while (returnNull()) |value| {
        break value;
    } else
        i32(2);
    assert(result == 2);
}

test "while on nullable with else result follow break prong" {
    const result = while (returnMaybe(10)) |value| {
        break value;
    } else
        i32(2);
    assert(result == 10);
}

test "while on error union with else result follow else prong" {
    const result = while (returnError()) |value| {
        break value;
    } else |err|
        i32(2);
    assert(result == 2);
}

test "while on error union with else result follow break prong" {
    const result = while (returnSuccess(10)) |value| {
        break value;
    } else |err|
        i32(2);
    assert(result == 10);
}

test "while on bool with else result follow else prong" {
    const result = while (returnFalse()) {
        break i32(10);
    } else
        i32(2);
    assert(result == 2);
}

test "while on bool with else result follow break prong" {
    const result = while (returnTrue()) {
        break i32(10);
    } else
        i32(2);
    assert(result == 10);
}

test "break from outer while loop" {
    testBreakOuter();
    comptime testBreakOuter();
}

fn testBreakOuter() void {
    outer: while (true) {
        while (true) {
            break :outer;
        }
    }
}

test "continue outer while loop" {
    testContinueOuter();
    comptime testContinueOuter();
}

fn testContinueOuter() void {
    var i: usize = 0;
    outer: while (i < 10) : (i += 1) {
        while (true) {
            continue :outer;
        }
    }
}

fn returnNull() ?i32 {
    return null;
}
fn returnMaybe(x: i32) ?i32 {
    return x;
}
fn returnError() error!i32 {
    return error.YouWantedAnError;
}
fn returnSuccess(x: i32) error!i32 {
    return x;
}
fn returnFalse() bool {
    return false;
}
fn returnTrue() bool {
    return true;
}
