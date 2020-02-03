function has_ampm()
    local handle = io.popen("locale  -k d_t_fmt | grep  -sqo -E '%r|%p|%I' && echo yes || echo no")
    local output = handle:read("*l")
    handle:close()
    return  output 
end

if has_ampm() == "yes" then
	ampm = true
else
	ampm = false
end

function conky_hours()
	if ampm then
		return os.date("%I")
    else
		return os.date("%H")
    end
end

function conky_ampm()
	if ampm then
		return os.date("%P")
    else
		return ''
    end
end

function conky_AMPM()
	if ampm then
		return os.date("%p")
    else
		return ''
    end
end

function conky_am_pm()
	return conky_ampm()
end

function conky_AM_PM()
	return conky_AMPM()
end

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
