const std = @import("std");
const process = std.process;
const fs = std.fs;
const io = std.io;
const Allocator = std.mem.Allocator;

pub fn main() anyerror!void {
    var arena_instance = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_instance.deinit();
    const arena = &arena_instance.allocator;

    const args = try process.argsAlloc(arena);
    if (args.len != 2) {
        std.debug.print("Usage: zhexdump <file>\n", .{});
        return;
    }
    for (args) | arg | {
        std.debug.print("{s} ", .{arg});
    }
    std.debug.print("\n", .{});
    var file = try std.fs.cwd().openFile(args[1], .{});
    defer file.close();
    const contents = try file.reader().readAllAlloc(
        arena,
        1024 * 4,
    );
    std.debug.print("File: {s}\n", .{args[1]});
    for (contents) | c | {
        std.debug.print("0x:{x} ", .{c});
    }
}