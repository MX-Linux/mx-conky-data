--[[
Background by londonali1010 (2009)

This script draws a background to the Conky window. It covers the whole of 
the Conky window, but you can specify rounded corners, if you wish.

To call this script in Conky, use (if script is saved to ~/.conky/scripts/):
	lua_load ~/.conky/scripts/draw_bg.lua
	lua_draw_hook_pre draw_bg

Changelog:
+ v1.0 -- Original release (07.10.2009)
]]


-- ==============
-- == Settings ==
-- ==============

-- Change these settings to affect your background. "corner_r" is the radius 
-- of rounded corners, in pixels. If you don't want rounded corners, use 0.
-- corner_r=0
-- corner_r=10
corner_r=18

-- Set the colour of your background.
bg_colour=0x000000

-- Set the transparency (alpha) of your background.
-- bg_alpha=0.10
-- bg_alpha=0.15
-- bg_alpha=0.20
-- bg_alpha=0.25
-- bg_alpha=0.30
bg_alpha=0.35
-- bg_alpha=0.40
-- bg_alpha=0.50


-- ==================
-- == Start script ==
-- ==================

require 'cairo'
require 'cairo_xlib'  -- this line needed for the latest conky package as at Jan 25
function rgb_to_r_g_b(colour,alpha)
	return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function conky_draw_bg()
	if conky_window==nil then return end
	local w=conky_window.width
	local h=conky_window.height
	local cs=cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, w, h)
	cr=cairo_create(cs)
	
	cairo_move_to(cr,corner_r,0)
	cairo_line_to(cr,w-corner_r,0)
	cairo_curve_to(cr,w,0,w,0,w,corner_r)
	cairo_line_to(cr,w,h-corner_r)
	cairo_curve_to(cr,w,h,w,h,w-corner_r,h)
	cairo_line_to(cr,corner_r,h)
	cairo_curve_to(cr,0,h,0,h,0,h-corner_r)
	cairo_line_to(cr,0,corner_r)
	cairo_curve_to(cr,0,0,0,0,corner_r,0)
	cairo_close_path(cr)
	
	cairo_set_source_rgba(cr,rgb_to_r_g_b(bg_colour,bg_alpha))
	cairo_fill(cr)
end
