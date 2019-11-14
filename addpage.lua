-- ページを追加する
require "tableutil"
require "pageutil"

function addpage(pagenumber, failsafe)
    local n = table.linersearch(info.releasepages, pagenumber)
    if n ~= nil then
        local e = failsafe or error("ページの追加に失敗: 理由: 既にページが存在する")
        failsafe(pagenumber)
    end
    assert(page.create(pagenumber, setting.single_template))
    table.insert(info.releasepages, pagenumber)
    table.sort(info.releasepages)
end

