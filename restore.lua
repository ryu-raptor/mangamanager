-- drop と対になる関数

require "pageutil"
require "tableutil"
require "userinterface"

-- 前方一致
local function forwardmatch(basestr, pattern)
    -- パターンをエスケープ
    pattern = pattern:gsub("[%p]", "%%%0")
    
    -- n or x and y は nil か結果を返す関数を false か true を返す関数に変換する
    return (basestr:match("^" .. pattern) or false) and true
end

-- info から該当する dropinfo を取得する
local function searchdropinfo(id) --> dropinfo or nil
    local result = {}
    for _, v in ipairs(info.droppages) do
        if forwardmatch(v.id, id) then
            table.insert(result, v)
        end
    end

    -- (#result == 0 or nil) and result
    -- #result == 0 -> nil
    -- #result ~= 0 -> result
    return (#result ~= 0 or nil) and result
end

function restore(id, failsafe)
    -- 数字が先頭の場合整数型に変換されてしまうため一回文字列に落とす
    id = tostring(id)
    local cands = searchdropinfo(id)
    if not cands then error("該当する Drop ページは見つかりませんでした: 理由: 指定された ID にマッチするページがない: ヒント: ID のあいまい検索は前方一致です. 後方一致や部分一致は今のところ使えません") end
    local target
    if #cands >= 2 then
        target = UIselectionWithMessage("複数の候補が見つかりました", cands,
        function (info)
            -- TODO: Issue #3 に対応できていない
            return string.format("元のページ: %03d, ID: %s", info.origin, info.id)
        end)
        if not target then error("ユーザーによる中止") end
    else
        target = cands[1]
    end
    -- ページかぶりの検出
    if table.linersearch(info.releasepages, target.origin) then
        failsafe(target.origin)
    end
    -- 実際に移動
    page.restore(target)
    -- データベースを更新
    table.remove(info.droppages, table.linersearch(info.droppages, target))
    table.insert(info.releasepages, target.origin)
    table.sort(info.releasepages)
end

