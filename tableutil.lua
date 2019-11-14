-- テーブル操作

-- 最後尾の値
function table.tail(t)
    -- 配列じゃない可能性があるので線形探査
    local i = 1
    while (t[i] ~= nil) do
        i = i + 1
    end
    return t[i - 1]
end

-- 線形探査
function table.linersearch(t, sv, pred)
    pred = pred or function (a, b)
        return a == b
    end

    for k, v in ipairs(t) do
        if pred(v, sv) then
            return k
        end
    end 
    return nil
end

