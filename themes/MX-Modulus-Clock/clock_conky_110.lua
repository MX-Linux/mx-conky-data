-- clock_conky_110.lua
-- by damo, August 2020
--
-- With inspiration from:
--      Air Clock by Alison Pitt (londonali1010) (2009)
--      seamod_rings.lua    http://custom-linux.deviantart.com/art/Conky-Seamod-v0-1-283461046
--      Boris Krinkel <olgmen>

-- to be used by clock_conky_110.conf
------------------------------------------------------------------------

require 'cairo'
pcall(function() require('cairo_xlib') end)

-- called by "lua_startup_hook" in conky
-- "config" = /path/to/config file (set in conky)
function conky_load_config (config)
    if file_exists(config) then
        -- get clock settings from external config file
        clock_variables = loadfile(config)()
    else
        return
    end
end

function file_exists(name)
    local f=io.open(name,"r")
    if f~=nil then
        io.close(f) return true
    else
        print("Configuration file not found")
        return false
    end
end

-- called by "lua_draw_hook_pre" in conky
-- draw clock using settings from "config"
function conky_clock (config)

    if conky_window == nil then return end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)

    -- allow conky window to be established before trying to draw clock
    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)

    if update_num>1 then
        for i, cv in pairs(clock_vars) do
            check_settings (cv)
            cr = cairo_create (cs)
            display_clock (cv)
            cairo_destroy (cr)
        end
    end
end

function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function check_settings (t) -- lua doesn't have a case/switch statement:
    -- set default values if necessary
    if t.x == nil then  -- if x,y,radius = "nil", set up clock relative to conky window.
        t.x = conky_window.width/2
    elseif t.y == nil then
        t.y = t.x
    elseif t.radius == nil then
        t.radius = t.x*0.95     -- so it fits inside conky window
    elseif t.border == nil then
        t.border = false
    elseif t.border_out == nil then
        t.border = false
    elseif t.color == nil then
        t.color = 0xffffff
    elseif t.alpha == nil then
        t.alpha = 1
    elseif t.line_width == nil then
        t.line_width = 2
    elseif t.border_width == nil then
        t.border_width = t.line_width
    elseif t.hours_num == nil then
        t.hours_num = 12
    elseif t.color_hands == nil then
        t.color_hands = t.color
    elseif t.alpha_hands == nil then
        t.alpha_hands = 1
    elseif t.color_sec  == nil then
        t.color_sec = t.color
    elseif t.alpha_sec  == nil then
        t.alpha_sec = t.alpha
    elseif t.color_face == nil then
        t.color_face = 0xffffff
    elseif t.alpha_face == nil then
        t.alpha_face = 0.5
    elseif t.color_marks == nil then
        t.color_marks = t.color
    elseif t.alpha_marks == nil then
        t.alpha_marks = t.alpha
    elseif t.color_center == nil then
        t.color_center = t.color
    elseif t.alpha_center == nil then
        t.alpha_center = 1
    elseif t.numerals == nil then
        t.numerals = false
    elseif t.text_radius == nil then
        t.text_radius = 0.75
    elseif t.font_name   == nil then
        t.font_name = "Noto Sans"
    elseif t.font_size == nil then
        t.font_size = 12
    elseif t.italic == nil then
        t.italic = false
    elseif t.oblique == nil then
        t.oblique = false
    elseif t.bold == nil then
        t.bold = false
    elseif t.font_color == nil then
        t.font_color = t.color
    elseif t.font_alpha == nil then
        t.font_alpha = t.alpha
    elseif t.clock_face == nil then
        t.clock_face = false
    elseif t.hours_marks == nil then
        t.hours_marks = true
    elseif t.minutes_marks == nil then
        t.minutes_marks = false
    elseif t.clock_center == nil then
        t.clock_center = false
    elseif t.clock_center_radius == nil then
        t.clock_center_radius = 0.1
    elseif t.marks_radius_mins == nil then
        t.marks_radius_mins = 0.95
    elseif t.marks_radius_hrs == nil then
        t.marks_radius_hrs = 0.9
    elseif t.hour_radius == nil then
        t.hour_radius = 0.65
    elseif t.minute_radius == nil then
        t.minute_radius = 0.8
    elseif t.seconds_radius == nil then
        t.seconds_radius = 0.9
    elseif hour_hand_width == nil then
        hour_hand_width = 6
    elseif minute_hand_width == nil then
        minute_hand_width = 4
    elseif seconds_hand_width == nil then
        seconds_hand_width = 2
    elseif t.hand_style == nil then
        t.hand_style = 1
    end
end

function display_clock (t)
    local slant = CAIRO_FONT_SLANT_NORMAL
    local weight =CAIRO_FONT_WEIGHT_NORMAL

    if t.italic then slant = CAIRO_FONT_SLANT_ITALIC end
    if t.bold then weight = CAIRO_FONT_WEIGHT_BOLD end

    cairo_select_font_face(cr, t.font_name, slant, weight)
    cairo_set_font_size(cr, t.font_size)
    te=cairo_text_extents_t:create()
    cairo_text_extents (cr,t.text,te)

    -- make sure clock radius has been set before drawing:
    if t.radius then
        -- draw border ring
        if t.border then
            cairo_set_source_rgba(cr, rgb_to_r_g_b(t.color, t.alpha))
            cairo_set_line_width(cr, t.border_width)
            if t.border_out then -- draw border ring outside clock radius
                cairo_arc (cr, t.x, t.y,t.radius+t.border_width/2, 0, 2*math.pi)
            else
                cairo_arc (cr, t.x, t.y, t.radius-t.border_width/2, 0, 2*math.pi)
            end
            cairo_stroke (cr)
        end

        --  Set clock face
        if t.clock_face then
            if t.color_face then
                cairo_set_source_rgba(cr,rgb_to_r_g_b(t.color_face,t.alpha_face))
                cairo_arc(cr,t.x,t.y,t.radius,0,2*math.pi)
                cairo_fill(cr)
            end
        end

        --  draw hour marks
        if t.hours_marks then
            if t.color_marks then
                cairo_set_source_rgba(cr,rgb_to_r_g_b(t.color_marks,t.alpha_marks))
            end
            cairo_set_line_width(cr, t.line_width)

            local i = 0

            -- is clock 12H or 24H?
            if t.hours_num == 12 then
                num_hours = 11
                angle_hours = math.rad(30)
            else
                num_hours = 23
                angle_hours = math.rad(15)
            end

            local num = num_hours
            local angle = angle_hours

            for i= 0, num, 1 do
                cairo_move_to(cr, t.x - math.sin(angle*i)*t.radius, t.y - math.cos(angle*i)*t.radius)
                cairo_line_to(cr, t.x - math.sin(angle*i)*(t.radius*t.marks_radius_hrs), t.y - math.cos(angle*i)*(t.radius*t.marks_radius_hrs))
                cairo_stroke (cr)
            end
        end

        -- draw minute marks
        if t.minutes_marks then
            if t.hours_num == 24 then
                num_mins = 119
                angle_mins = math.rad(3)
            else
                num_mins = 59
                angle_mins = math.rad(6)
            end
            local num = num_mins
            local angle = angle_mins

            cairo_set_line_width(cr, t.line_width*0.5)

            for i=0, num, 1 do
                cairo_move_to(cr, t.x - math.sin(angle * i) * t.radius, t.y - math.cos(angle * i) * t.radius)
                cairo_line_to(cr, t.x - math.sin(angle * i) * (t.radius * t.marks_radius_mins), t.y - math.cos(angle * i) * (t.radius*t.marks_radius_mins))
                cairo_stroke (cr)
            end
        end
        --  numbers radius,color,alpha
        if t.numerals then
            cairo_save (cr)
            cairo_translate(cr, t.x, t.y)
            mx, my = 0, 0
            local i = 0

            -- is clock 12H or 24H?
            if t.hours_num == 24 then
                num_hours = 24
                angle_hours = math.rad(15)
            else
                 num_hours = 12
                 angle_hours = math.rad(30)
            end

            local num = num_hours
            local angle = angle_hours

            for i = 1, num, 1 do
                mov_x = math.sin(angle*i)*(t.radius*t.text_radius)
                mov_y = math.cos(angle*i)*(t.radius*t.text_radius)
                te=cairo_text_extents_t:create()
                cairo_text_extents (cr,i,te)
                if t.font_color then
                    cairo_set_source_rgba(cr, rgb_to_r_g_b(t.font_color, t.font_alpha))
                end
                mx = -te.width/2
                my = -te.height/2-te.y_bearing
                cairo_move_to(cr, mx + mov_x, my - mov_y)
                cairo_show_text(cr, i)
            end
            cairo_restore (cr)
        end -- end of numerals test


        local hours = os.date("%I")
        local mins = os.date("%M")
        local secs = os.date("%S")
        secs_arc = (2*math.pi/60)*secs
        mins_arc = (2*math.pi/60)*mins
        hours_arc = (2*math.pi/12)*hours + mins_arc/12

        --  hour and minute hand color
        if t.color_hands then
            cairo_set_source_rgba(cr, rgb_to_r_g_b(t.color_hands, t.alpha_hands))
            if t.hand_style == 0 then   -- set line end cap shape
                cairo_set_line_cap(cr, CAIRO_LINE_CAP_ROUND)
            else
                cairo_set_line_cap(cr, CAIRO_LINE_CAP_BUTT)
            end
            --  draw hour hand
            xh = t.x + t.hour_radius*t.radius*math.sin(hours_arc)
            yh = t.y - t.hour_radius*t.radius*math.cos(hours_arc)
            cairo_set_line_width(cr, t.hour_hand_width)
            cairo_move_to(cr, t.x, t.y)
            cairo_line_to(cr, xh, yh)
            cairo_stroke(cr)

            --  draw minute hand
            xm = t.x + t.minute_radius*t.radius*math.sin(mins_arc)
            ym = t.y - t.minute_radius*t.radius*math.cos(mins_arc)
            cairo_set_line_width(cr, t.minute_hand_width)
            cairo_move_to(cr, t.x, t.y)
            cairo_line_to(cr, xm, ym)
            cairo_stroke(cr)

            --  draw seconds hand
            -- set color for seconds hand
            if t.color_sec then
                cairo_set_source_rgba(cr, rgb_to_r_g_b(t.color_sec, t.alpha_sec))
                xs = t.x + t.seconds_radius*t.radius*math.sin(secs_arc)
                ys = t.y - t.seconds_radius*t.radius*math.cos(secs_arc)
                cairo_set_line_width(cr, t.seconds_hand_width)
                cairo_move_to(cr, t.x, t.y)
                cairo_line_to(cr,xs,ys)
                cairo_stroke (cr)
            end
        end

        --  draw centre on top of hands
        if t.clock_center then
            if t.color_center then
                cairo_set_source_rgba(cr,rgb_to_r_g_b(t.color_center,t.alpha_center))
                cairo_arc(cr,t.x,t.y,t.radius*t.clock_center_radius,0,2*math.pi)
                cairo_fill(cr)
            end
        end
    end -- end of radius test
end
