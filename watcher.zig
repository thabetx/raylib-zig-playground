const std = @import("std");

const Windows = @cImport({
    @cInclude("Windows.h");
});

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Enable processing escape sequences in windows terminal.
    // This makes it possible to clear the screen after compilation.
    var hOutput = Windows.GetStdHandle(Windows.STD_OUTPUT_HANDLE);
    var dwMode: Windows.DWORD = undefined;
    var res = Windows.GetConsoleMode(hOutput, &dwMode);
    std.debug.assert(res != 0);
    dwMode |= Windows.ENABLE_VIRTUAL_TERMINAL_PROCESSING;
    res = Windows.SetConsoleMode(hOutput, dwMode);
    std.debug.assert(res != 0);

    var last_mtime: i128 = 0;
    var p: ?std.ChildProcess = null;

    const dir = std.fs.cwd();

    while (true) {
        const stat = try dir.statFile("program.zig");
        if (stat.mtime != last_mtime) {
            last_mtime = stat.mtime;

            // clear the terminal
            try std.io.getStdOut().writer().writeAll("\x1B[2J\x1B[H");

            if (p) |*pp|
                _ = pp.kill() catch {};

            // delete the executable
            dir.deleteFile("zig-out/bin/program.exe") catch {};

            // try to build it again
            p = std.ChildProcess.init(&[_][]const u8{ "zig", "build", "--prominent-compile-errors" }, allocator);
            try p.?.spawn();
            _ = try p.?.wait();

            // try to run it after the build
            // there should be a better way to do this check
            var file_found = true;
            dir.access("zig-out/bin/program.exe", .{}) catch {file_found = false;};
            if (file_found)
            {
                p = std.ChildProcess.init(&[_][]const u8{"zig-out/bin/program.exe"}, allocator);
                try p.?.spawn();
            }
        }

        std.time.sleep(std.time.ns_per_ms * 100);
    }
}
