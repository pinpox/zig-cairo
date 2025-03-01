const std = @import("std");
const Builder = std.build.Builder;
const FileSource = std.build.FileSource;
const Mode = std.builtin.Mode;

const EXAMPLES = [_][]const u8{
    "arc",
    "arc_negative",
    "bezier",
    "cairoscript",
    "clip",
    "clip_image",
    "compositing",
    "curve_rectangle",
    "curve_to",
    "dash",
    "ellipse",
    "fill_and_stroke2",
    "fill_style",
    "glyphs",
    "gradient",
    "grid",
    "group",
    "image",
    "image_pattern",
    "mask",
    "multi_segment_caps",
    "pango_simple",
    "pythagoras_tree",
    "rounded_rectangle",
    "save_and_restore",
    "set_line_cap",
    "set_line_join",
    "sierpinski",
    "singular",
    "spiral",
    "spirograph",
    "surface_image",
    "surface_pdf",
    "surface_svg",
    "surface_xcb",
    "text",
    "text_align_center",
    "text_extents",
    "three_phases",
};

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    // b.verbose = true;
    // b.verbose_cimport = true;
    // b.verbose_link = true;

    const test_all_modes_step = b.step("test", "Run all tests in all modes.");
    inline for ([_]Mode{ Mode.Debug, Mode.ReleaseFast, Mode.ReleaseSafe, Mode.ReleaseSmall }) |test_mode| {
        const mode_str = comptime modeToString(test_mode);
        const name = "test-" ++ mode_str;
        const desc = "Run all tests in " ++ mode_str ++ " mode.";
        const tests = b.addTest(.{
            .name = "test",
            .root_source_file = .{ .path = "src/pangocairo.zig" },
            .target = target,
            .optimize = optimize,
        });

        tests.linkLibC();
        tests.linkSystemLibrary("xcb");
        tests.linkSystemLibrary("pango-1.0");
        tests.linkSystemLibrary("cairo");
        tests.linkSystemLibrary("pangocairo-1.0");

        const test_step = b.step(name, desc);
        test_step.dependOn(&tests.step);
        test_all_modes_step.dependOn(test_step);
    }

    // const examples_step = b.step("examples", "Build all examples");
    inline for (EXAMPLES) |name| {
        const example = b.addExecutable(.{
            .name = name,
            .root_source_file = .{
                .path = "examples" ++ std.fs.path.sep_str ++ name ++ ".zig",
            },
            .target = target,
            .optimize = optimize,
        });

        const cairo = b.createModule(.{ .source_file = .{ .path = "src/cairo.zig" } });
        example.addModule("cairo", cairo);

        if (shouldIncludeXcb(name)) {
            const xcb = b.createModule(.{ .source_file = .{ .path = "src/xcb.zig" } });
            example.addModule("xcb", xcb);
        }
        if (shouldIncludePango(name)) {
            const pangocairo = b.createModule(.{ .source_file = .{ .path = "src/pangocairo.zig" } });
            example.addModule("pangocairo", pangocairo);
        }

        example.linkLibC();
        example.linkSystemLibrary("cairo");
        example.linkSystemLibrary("pango-1.0");
        example.linkSystemLibrary("pangocairo-1.0");

        if (shouldIncludeXcb(name)) {
            example.linkSystemLibrary("xcb");
        }
        // example.install(); // uncomment to build ALL examples (it takes ~2 minutes)
        // examples_step.dependOn(&example.step);

        const run_cmd = b.addRunArtifact(example);
        run_cmd.step.dependOn(b.getInstallStep());
        const desc = "Run the " ++ name ++ " example";
        const run_step = b.step(name, desc);
        run_step.dependOn(&run_cmd.step);
    }

    // b.default_step.dependOn(test_all_modes_step);
}

fn modeToString(mode: Mode) []const u8 {
    return switch (mode) {
        Mode.Debug => "debug",
        Mode.ReleaseFast => "release-fast",
        Mode.ReleaseSafe => "release-safe",
        Mode.ReleaseSmall => "release-small",
    };
}

fn shouldIncludePango(comptime name: []const u8) bool {
    var b = false;
    if (name.len > 6) {
        b = std.mem.eql(u8, name[0..6], "pango_");
    }
    return b;
}

fn shouldIncludeXcb(comptime name: []const u8) bool {
    return std.mem.eql(u8, name, "surface_xcb");
}
