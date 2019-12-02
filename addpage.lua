-- ページを追加する
require "tableutil"
require "pageutil"

function addpage(pagenumber, failsafe, template_name)
    local n = table.linersearch(info.releasepages, pagenumber)
    if n ~= nil then
        local e = failsafe or error("ページの追加に失敗: 理由: 既にページが存在する")
        failsafe(pagenumber)
    end
    -- テンプレート名
    local template_path = setting.single_template
    for k, v in pairs(setting) do
        local m = k:match(template_name .. "_template")
        if m then
            template_path = v
            break
        end
    end

    assert(page.create(pagenumber, template_path))
    table.insert(info.releasepages, pagenumber)
    table.sort(info.releasepages)
end

