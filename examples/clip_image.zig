const std = @import("std");
const pi = std.math.pi;
const cairo = @import("cairo");
const setBackground = @import("utils.zig").setBackground;

/// https://www.cairographics.org/samples/clip_image/
fn clipImage(cr: *cairo.Context) !void {
    cr.setSourceRgb(0.0, 0.0, 0.0); // black

    var image = try cairo.Surface.createFromPng("data/romedalen.png");
    defer image.destroy();

    const w = try image.getWidth();
    const h = try image.getHeight();

    cr.arc(128.0, 128.0, 76.8, 0, 2 * pi);
    cr.clip();
    cr.newPath(); // path not consumed by cr.clip()

    cr.scale(256.0 / @as(f64, @floatFromInt(w)), 256.0 / @as(f64, @floatFromInt(h)));
    cr.setSourceSurface(&image, 0, 0);
    cr.paint();
}

pub fn main() !void {
    const width: u16 = 256;
    const height: u16 = 256;
    var surface = try cairo.Surface.image(width, height);
    defer surface.destroy();

    var cr = try cairo.Context.create(&surface);
    defer cr.destroy();

    setBackground(&cr);
    try clipImage(&cr);
    _ = surface.writeToPng("examples/generated/clip_image.png");
}
