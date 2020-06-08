-- 基本関数

local func = {}

-- 恒等写像
function func.id(a)
    return a
end

-- map
function func.map(mf, ...)
    local map = {}
    for _, v in ipairs({...}) do
        table.insert(map, mf(v))
    end
    return table.unpack(map)
end

-- reduce
function func.reduce(rf, fst, ...)
    local n = fst

    for i, v in ipairs({...}) do
        n = rf(n, v)
    end

    return n
end

-- partial apply
--[[
function func.l(f, ...)
    local a = {...}
    local n = f

    for _, v in ipairs(a) do
        n = function (...)
            return n(v, ...)
        end
    end

    return n
end
--]]
function func._l(f, a)
    return function (...)
        return f(a, ...)
    end
end

function func.l(f, ...)
    local n = f
    for k, v in ipairs({...}) do
        n = func._l(n, v)
    end

    return n
end

-- curry
function func.c(f)
    return function (a)
        return function (...)
            return f(a, ...)
        end
    end
end

return func
