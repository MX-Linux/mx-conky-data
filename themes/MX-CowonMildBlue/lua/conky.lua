
-- some globals
ampm = nil
lc_time_table = nil

-- some time 12h/24h am/pm format functions 
function has_ampm()
    local handle = io.popen("date --date='2020-01-01 17:00' '+%c' 2>/dev/null")
    local result = handle:read("*a")
    handle:close()
    return result:match("(17)") ~= "17"
end

if ampm == nil then
    ampm = has_ampm()
end

-- Use force to override auto time-format detection of 12H or 24H
-- set force either to 12H, 24H, or keep empty for auto-detection
function conky_hour(force)
    if force then
        if force:match('^12') then
            return os.date("%I")
        elseif force:match('^24')  then
            return os.date("%H")
        end
    end
    
    -- If no force or invalid force, use AM/PM detection
    if ampm then
        return os.date("%I")
    else
        return os.date("%H")
    end
end

function conky_hours(force)
    return conky_hour(force)
end

function conky_minute()
     return conky_parse('${time %M}') 
end

function conky_minutes()
     return conky_minute()
end

function conky_ampm(force)
    if force then
        if force:match('^12') then
            return os.date("%P")
        elseif force:match('^24')  then
            return ''
        end
    end

    if ampm then
        return os.date("%P")
    else
        return ''
    end
end

function conky_AMPM(force)

    if force then
        if force:match('^12') then
            return os.date("%p")
        elseif force:match('^24')  then
            return ''
        end
    end

    if ampm then
        return os.date("%p")
    else
        return ''
    end
end

function conky_am_pm(force)
    return conky_ampm(force)
end

function conky_AM_PM(force)
    return conky_AMPM(force)
end


function lc_time()
    -- Get LC_TIME from locale
    local handle = io.popen("/usr/bin/locale 2>/dev/null")
    local locale_output = handle:read("*a")
    handle:close()

    -- Extract LC_TIME value
    local lc_time_match = locale_output:match("LC_TIME=([^\n]+)")
    
    -- Remove quotes if present
    if lc_time_match then
        lc_time_match = lc_time_match:gsub('^"', ''):gsub('"$', '')
    end

    -- Handle default case
    lc_time_match = lc_time_match or "C"

    -- Split into language (LL) and country code (CC)
    local LL, LL_CC
    if lc_time_match == "C" or lc_time_match == "C.UTF-8" then
        LL = "C"
        LL_CC = "C"
    else
        -- Split the locale string, removing charset
        LL = lc_time_match:match("^([^_]+)")
        LL_CC = lc_time_match:match("^([^.]+)")
    end

    -- return the table
    return {
        LL = LL,
        LL_CC = LL_CC,
        full = lc_time_match
    }
end

if lc_time_table == nil then
    lc_time_table = lc_time()
end

-- some more globals
LL = lc_time_table.LL
LL_CC = lc_time_table.LL_CC

DATE_FORMAT = '${time %A   %B %d}'

-- some locals
local date_format_table =
{
   ['en_US']   = '${time %A   %B %d}',
   ['en']      = '${time %A   %B %d}',
   ['C']       = '${time %A   %B %d}',
   ['de_DE']   = '${time %A  %-d. %B}',
   ['de']      = '${time %A  %-d. %B}',
   ['ja']      = '${time %B %d日 %A}',
   ['ko']      = '${time %B %d일 %A}',
   ['zh']      = '${time %B %d日 %A}',
   ['default'] = '${time %A  %d %B}',
}

local cjk_table =
{
   ['ja'] = 'true',
   ['ko'] = 'true',
   ['zh'] = 'true',
   ['ar'] = 'true',
   ['fa'] = 'true',
   ['he'] = 'true',
}

-- some functions
function conky_lang()
     return os.getenv("LANG")
end

function conky_cpu()
     local str=''
     str=conky_parse('${cpu cpu0}')
     return string.format("%3d", str)
end

function conky_memperc()
     local str=''
     str=conky_parse('${memperc}')
     return string.format("%2d", str)
end

-- CJK handling

function conky_cjk()
    if cjk_table[LL] then
       return 'true'
    else
       return 'false'
    end
end

function conky_time(a)
     local s='${time %' .. a .. '}'
     return conky_parse(s)
end

function conky_set_time(d)
     if ( d == 'a' or d == 'A' ) then
        TIME_A = d
     elseif ( d == 'b' or d == 'B' ) then 
        TIME_B = d
     end
     set_date_format()
     return ''
end

function date_format()
     local date_format
     if      date_format_table[LL_CC] then
             date_format = date_format_table[LL_CC]
     elseif  date_format_table[LL] then
             date_format = date_format_table[LL]
     else
        date_format = date_format_table['default']
     end
        if TIME_A == 'a' then date_format = date_format:gsub('A', 'a');  end
        if TIME_B == 'b' then date_format = date_format:gsub('B', 'b');  end
     return date_format
end

function set_date_format()
     DATE_FORMAT = date_format()
     return
end

function conky_date_format() return DATE_FORMAT; end
function conky_get_date_format() return DATE_FORMAT; end

function conky_date()
     local format_str = DATE_FORMAT
     str=conky_parse(format_str)
     return str
end
