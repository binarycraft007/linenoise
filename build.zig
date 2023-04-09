const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});

    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "linenoise",
        .target = target,
        .optimize = optimize,
    });
    lib.addCSourceFiles(
        &.{"src/linenoise.c"},
        &.{"-Wall"},
    );
    lib.addIncludePath("src");
    lib.linkLibC();
    lib.install();

    const exe = b.addExecutable(.{
        .name = "example",
        .target = target,
        .optimize = optimize,
    });
    exe.addCSourceFiles(
        &.{"src/example.c"},
        &.{"-Wall"},
    );
    exe.linkLibrary(lib);
    exe.addIncludePath("src");
    exe.linkLibC();
    exe.install();

    const run_cmd = exe.run();

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
