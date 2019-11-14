-- 情報を表示する

local function showreleaseinfo()
    print("管理されている Release ページ")
    local lastp = 0
    for i, v in ipairs(info.releasepages) do
        -- 連番じゃないなら区切りを入れる
        if lastp + 1 ~= v then
            print("---")
        end
        print(v)
        lastp = v
    end
end

local function showdropinfo()
    print("管理されている Drop ページ")
    for i, v in ipairs(info.droppages) do
        print(string.format("origin: %d, id: %s", v.origin, v.id))
    end
end

local function showmasterinfo()
    print("基本情報")
    showreleaseinfo()
end

function showinfo(opt)
    if not opt then
        showmasterinfo()
    elseif opt == "drop" then
        showdropinfo()
    end
end

