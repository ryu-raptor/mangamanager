-- tempalte generator
-- local unit = mm
local func = require "function"

local tm = {}

-- 四捨五入
local function round(v)
    local x, xx = math.modf(v)
    if xx >= 0.5 then
        return x + 1
    end

    return x
end

-- m -> inch
function tm.meterinch(origin)
    return origin / 0.0254
end

-- mm -> inch
function tm.mminch(mm)
    return mm / 25.4
end

-- inch -> m
function tm.inchmeter(origin)
    return origin * 0.0254
end

-- ? -> inch
function tm.inchconvselector(unitstr)
    if unitstr == "mm" then
        return function (mm)
            return tm.meterinch(mm / 1000)
        end
    elseif unitstr == "cm" then
        return function (cm)
            return tm.meterinch(cm / 100)
        end
    elseif unitstr == "inch" then
        return func.id
    elseif unitstr == "m" then
        return tm.meterinch
    end
end

-- ? -> mm
function tm.mmconvselector(unit)
    if unit == "mm" then
        return func.id
    elseif unit == "cm" then
        return function (cm)
            return cm * 10
        end
    elseif unit == "inch" then
        return function(inch)
            return tm.inchmeter(inch) / 1000
        end
    elseif unit == "m" then
        return function (m)
            return m * 1000
        end
    end
end

function tm.getmm(lenstr)
    local l, unit = lenstr:match("([%.%d]+)(%w+)")
    local c = tm.mmconvselector(unit)
    return c(tonumber(l))
end

function tm.getpx(dpi, converter, origin)
    if type(dpi) == "string" then
        dpi = tonumber(dpi)
    end

    return dpi * converter(origin) 
end

function tm.mmpx(dpi, origin)
    if type(dpi) == "string" then
        dpi = tonumber(dpi)
    end

    return round(dpi * tm.mminch(origin))
end

-- lenstr :: 長さを表す文字列 [%.%d]+%w+
function tm.topx(dpi, lenstr)
    local l, unit = lenstr:match("([%.%d]+)(%w+)")
    local c = tm.mmconvselector(unit)

    return tm.getpx(dpi, tm.mminch, c(tonumber(l)))
end

function tm.parsepx(template) --> w, h, play, iplay, isafe
    -- w x h unit
    local width, height, unit = template.size:match("(%d+)x(%d+)(%w+)")
    width, height = func.map(tm.mmconvselector(unit), width, height)
    -- play
    local play, playunit = template.play:match("(%d+)(%w+)")
    -- add play
    width = width + play * 2
    height = height + play * 2

    -- get px
    local pwidth, pheight = func.map(func.l(tm.getpx, template.dpi, tm.mminch), width, height)

    -- plays
    local play, innerplay, safe = template.play, template.innerplay, template.innersafe

    -- to px
    play, innerplay, safe = func.map(func.l(tm.topx, template.dpi), play, innerplay, safe)

    return pwidth, pheight, play, innerplay, safe
end

-- 
function tm.generatepng(template, outputpath)
    local w, h, play, innerplay, safe = tm.parsepx(template)

    -- imagemagick command
    local newimg = string.format("-size %dx%d xc:white", round(w), round(h))

    -- imagemagick command
    local tombo = func.reduce(function (xs, x) return xs .. x end, "", func.map(function (x) return string.format('-draw "rectangle %d,%d %d,%d" ', func.map(round, x, x, pwidth - x, pheight - x)) end, play, play + innerplay, play + safe))

    -- imagemagick command
    local command = string.format('%s -fill none -stroke "#000000" %s', newimg, tombo)
    os.execute(string.format("convert %s %s", command, outputpath))
end

local function parse(t)
    local w, h, u = t.size:match("([%.%d]+)x([%.%d]+)(%w+)")
    w, h = func.map(tm.getmm, w..u, h..u)
    local p, ip, s = func.map(tm.getmm, t.play, t.innerplay, t.innersafe)
    return w, h, p, ip, s
end

local function concat(xs, x)
    return xs.." "..x
end

local function rect(...)
    return string.format('-draw "rectangle %d,%d %d,%d" ', func.map(func.l(tm.mmpx, singletemplate.dpi), ...))
end

local function line(...)
    return string.format('-draw "line %d,%d %d,%d" ', func.map(func.l(tm.mmpx, singletemplate.dpi), ...))
end

-- 見開きを生成する
function tm.generatemihiraki(singletemplate, out)
    -- |play|innerplay|                   |innerplay|innerplay|                   |innerplay|play|
    -- |    |   innersafe   |contents|  innersafe   |   innersafe   |contents|  innersafe   |    |
    -- |    |width                                  |width                                  |    |

    local w, h, p, ip, s = parse(singletemplate)
    local pagew = w * 2 + p * 2
    local pageh = h + p * 2
    local centerx = w + p
    
    local outerplay = rect(func.map(round, p, p, pagew - p, pageh - p))
    local innerplay = func.reduce(concat, "", 
        func.map(function (off) return rect(p + ip + off, p + ip, (w + p) - ip + off, pageh - (p + ip)) end,
        0, centerx - p))
    local safe = func.reduce(concat, "", 
        func.map(function (off) return rect(p + s + off, p + s, (w + p) - s + off, pageh - (p + s)) end, 
        0, centerx - p))
    local center = line(centerx, p, centerx, pageh - p)

    local command = func.reduce(concat, "", '-fill none -stroke "#000000"', outerplay, innerplay, safe, center)
    local page = string.format("-size %dx%d xc:white", func.map(func.l(tm.mmpx, singletemplate.dpi), pagew, pageh))
    os.execute(string.format('convert %s %s %s', page, command, out))
end

local function crop(...)
    return string.format("-crop %dx%d+%d+%d", ...)
end

-- 見開きを分割する
function tm.splitmihiraki(singletemplate, input, out1, out2)
    local w, h, p, ip, s = parse(singletemplate)
    local pagew = w * 2 + p * 2
    local pageh = h + p * 2
    local centerx = w + p


    local crop1, crop2 = func.map(function(off) 
        return crop(func.map(func.l(tm.mmpx, singletemplate.dpi), w + p * 2, h + p * 2, off, 0))
    end, 0, w)

    local function docrop(crop, out)
        os.execute(string.format('convert %s %s %s', input, crop, out))
    end

    docrop(crop1, out1)
    docrop(crop2, out2)
end

return tm
