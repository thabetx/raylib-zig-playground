// look at raylib/examples/build.zig to support other platforms

const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const program = b.addExecutable("program", "program.zig");
    program.setBuildMode(b.standardReleaseOptions());
    program.linkLibC();
    program.addObjectFile("raylib/raylib.lib");
    program.addIncludePath("raylib");
    program.linkSystemLibrary("winmm");
    program.linkSystemLibrary("gdi32");
    program.linkSystemLibrary("opengl32");
    program.install();

    b.step("program", "Build program").dependOn(&program.step);
    var run_program_step = b.step("run-program", "Run Program");
    run_program_step.dependOn(&program.run().step);

    const watcher = b.addExecutable("watcher", "watcher.zig");
    watcher.setBuildMode(b.standardReleaseOptions());
    watcher.linkLibC();

    b.step("watcher", "Build watcher").dependOn(&watcher.step);
    var run_watcher_step = b.step("run-watcher", "Run Watcher");
    run_watcher_step.dependOn(&watcher.run().step);
}
