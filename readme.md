# raylib-zig-playgournd

**raylib-zig-playground** is a small [Zig](https://ziglang.org/) environment for creating small tools or games based on [raylib](https://github.com/raysan5/raylib).

The goal of this code is to present a minimal hot-reloading setup. Whenever program.zig has new saved changes the program will get compiled and restarted.

Here is how it looks.

https://user-images.githubusercontent.com/7282243/191952771-37ded3ed-07e3-4693-8e81-fd81cd578551.mp4

The [Zig compiler](https://ziglang.org/download/) is the only dependency.

Build with `zig build`. Run with `zig build run-program`.

`program.zig` is the main program.

`watcher.zig` watches `program.zig` and restarts it on change. This makes iterating on the code more fun.

You can use `watch.bat` to start the watcher. Which runs `zig build run-watcher`.

`raylib.lib` is prebuilt by running `zig build -Drelease-fast` in `raylib/src` in [raylib's repository](https://github.com/raysan5/raylib).

Note that this setup currently works only on Windows.

Enjoy!
