-- drop/restore
require "pageutil"
require "tableutil"

function drop(pagenumber)
    local id = assert(page.drop(pagenumber))
    table.remove(info.releasepages, table.linersearch(info.releasepages, pagenumber))
    table.insert(info.droppages, {origin = pagenumber, id = id})
    table.sort(info.droppages, function (a, b)
        -- <
        return a.origin < b.origin
    end)
end

function restore(pageid, failsafe)
    local i = table.linersearch(info.droppages, {id = pageid}, function (tv, sv)
        return tv.id == sv.id
    end)
    if i == nil then error("restore 失敗: 理由: 与えられた id が見つからない") end

    local dropinfo = info.droppages[i]

    -- 安全に戻せるか?
    if table.linersearch(info.releasepages, dropinfo.origin) ~= nil then
        failsafe(dropinfo.origin)
    end
    -- 戻す
    assert(page.restore(dropinfo))

    -- テーブルを更新
    table.remove(info.droppages, table.linersearch(info.droppages, dropinfo))
    table.insert(info.releasepages, dropinfo.origin)
    table.sort(info.releasepages)
end

