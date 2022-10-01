const std = @import("std");

const Windows = @cImport({
    @cInclude("Windows.h");
});

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Enable processing escape sequences in windows terminal.
    // This makes it possible to clear the screen before compilation.
    var hOutput = Windows.GetStdHandle(Windows.STD_OUTPUT_HANDLE);
    var dwMode: Windows.DWORD = undefined;
    var res = Windows.GetConsoleMode(hOutput, &dwMode);
    std.debug.assert(res != 0);
    dwMode |= Windows.ENABLE_VIRTUAL_TERMINAL_PROCESSING;
    res = Windows.SetConsoleMode(hOutput, dwMode);
    std.debug.assert(res != 0);

    var last_modification_time: i128 = 0;
    var process: ?std.ChildProcess = null;

    const dir = std.fs.cwd();

    while (true) {
        const stat = try dir.statFile("program.zig");

        // file didn't change so no need to do anything
        if (stat.mtime == last_modification_time)
            continue;

        last_modification_time = stat.mtime;

        // clear the terminal
        try std.io.getStdOut().writer().writeAll("\x1B[2J\x1B[H");

        if (process) |*pp|
            _ = pp.kill() catch {};

        // delete the executable
        dir.deleteFile("zig-out/bin/program.exe") catch {};

        // try to build it again
        process = std.ChildProcess.init(&.{ "zig", "build", "--prominent-compile-errors", "-freference-trace" }, allocator);
        try process.?.spawn();
        _ = try process.?.wait();

        // try to run it after the build
        if (dir.access("zig-out/bin/program.exe", .{})) {
            process = std.ChildProcess.init(&.{"zig-out/bin/program.exe"}, allocator);
            try process.?.spawn();
        } else |err| {
            std.debug.print("Can't run program: {}", .{err});
        }

        // check for file changes every 100 milliseconds
        std.time.sleep(std.time.ns_per_ms * 100);
    }
}
