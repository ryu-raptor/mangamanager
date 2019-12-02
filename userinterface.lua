-- UI
local f = require "function"

-- 候補を表示し, 選択させる
function selection(opt, conv) --> selection
    local t = opt
    local len = #t
    if len <= 0 then return nil end
    if len == 1 then return t[1] end

    conv = conv or f.id
    print("選んでください:")
    for i, v in ipairs(t) do
        print(string.format("%d: %s", i, conv(v)))
    end

    io.write(string.format("[1-%d], q for abort: ", len))
    local res = io.read("l")
    local i = tonumber(res)
    if not i then return nil end
    return t[i]
end

function UIselectionWithMessage(mes, opt, conv)
    print(mes)
    return selection(opt, conv)
end
