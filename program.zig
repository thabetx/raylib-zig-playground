const ray = @cImport({
    @cInclude("raylib.h");
});

const std = @import("std");

pub fn main() !void {
    // The window should start unfocused, otherwise, hot reloading would be annoying
    // as the focus will shift from the editor to the window.

    // @HACK: This line should trigger an assertion as there is no window yet.
    // In release build of raylib this the assertion doesn't get triggered and the
    // window starts unfocused as desired.
    // But this should be done in a more robust way.
    ray.SetWindowState(ray.FLAG_WINDOW_UNFOCUSED);

    const width = 600;
    const height = 300;
    ray.SetTraceLogLevel(ray.LOG_WARNING);
    ray.InitWindow(width, height, "Program");

    ray.SetWindowPosition(0, 30);
    ray.SetTargetFPS(60);
    defer ray.CloseWindow();

    var radius: f32 = 30;
    var ball_position = ray.Vector2{ .x = radius, .y = radius };
    var ball_speed = ray.Vector2{ .x = 3, .y = 2 };

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        defer ray.EndDrawing();
        ball_position.x += ball_speed.x;
        ball_position.y += ball_speed.y;
        ball_speed.x *= 1.001;
        ball_speed.y *= 1.001;

        if (ball_position.x - radius < 0 or ball_position.x + radius > width) ball_speed.x *= -1;

        if (ball_position.y - radius < 0 or ball_position.y + radius > height) ball_speed.y *= -1;

        ray.ClearBackground(ray.BLACK);
        ray.DrawText("Hello, World!", 0, 30, 20, ray.LIGHTGRAY);
        ray.DrawFPS(0, 0);
        ray.DrawCircleV(ball_position, radius, ray.GREEN);
    }
}
