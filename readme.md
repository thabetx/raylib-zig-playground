# raylib-zig-playgournd

**raylib-zig-playground** is a small [zig](https://ziglang.org/) environment for creating small tools or games based on [raylib](https://github.com/raysan5/raylib).

Build with `zig build`.

`program.zig` is the main program.

`watcher.zig` watches `program.zig` and restarts it on change. This makes iterating on the code more fun.

You can use `watch.bat` to start the watcher.

`raylib.lib` is a bundled prebuilt raylib created by running 'zig build -Drelease-fast` in `raylib/src` in raylib's repository.

Note that this setup currently works only on Windows.

Enjoy!
