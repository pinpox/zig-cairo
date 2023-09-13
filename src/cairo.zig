//! zig-cairo: zig wrapper for Cairo

// Export c to allow calling the C Cairo API.
// For example, if you import zig-cairo with:
// const cairo = @import("cairo");
// you will be able to access the original C functions with cairo.c. (e.g.
// cairo.c.cairo_create(), cairo.c.cairo_surface_status())
pub const c = @import("c.zig");

pub usingnamespace @import("constants.zig");
pub usingnamespace @import("enums.zig");

pub usingnamespace @import("surfaces/surface.zig");

pub usingnamespace @import("drawing/path.zig");
pub usingnamespace @import("drawing/pattern.zig");
pub usingnamespace @import("drawing/tags_and_links.zig");
pub usingnamespace @import("drawing/text.zig");
pub usingnamespace @import("drawing/transformations.zig");
pub usingnamespace @import("drawing/context.zig");

pub usingnamespace @import("fonts/scaled_font.zig");
pub usingnamespace @import("fonts/font_options.zig");

pub usingnamespace @import("utilities/matrix.zig");
pub usingnamespace @import("utilities/error_handling.zig");
pub usingnamespace @import("utilities/version_information.zig");
