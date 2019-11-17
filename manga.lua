-- manga.lua

-- ユーザーの設定を読み込む
assert(pcall(require, "setting"), "プロジェクトは開始できません: 理由: setting.lua がありません")

-- projectinfo.lua があるかを探す
local f = io.open("projectinfo.lua", "r")
if f ~= nil then
    io.close(f)
    require "projectinfo"
else
    -- 初期設定をする
    info = { releasepages = {}, droppages = {}, template_ext = nil}
    -- 拡張子を取得する
    local ext1 = setting.single_template:match("%.([%a%d]+)$")
    local ext2 = setting.mihiraki_template:match("%.([%a%d]+)$")
    if ext1 == nil then error("テンプレートには拡張子をつけてください: 理由: 拡張子を持たないテンプレートに対応させる方法を開発中のため") end
    if ext1 ~= ext2 then error("テンプレートの拡張子は揃えてください: 理由: 拡張子を揃えないで済む方法を開発中のため") end
    info.template_ext = ext1
end

-- モジュールの読み込み
require "addpage"
require "drop"
require "restore"
-- require "insert"
require "info"
-- require "move"
require "tableutil"
-- require "userinterface"


-- コマンドを変換する
local givens = {table.unpack(arg)}
local command = {name = givens[1], args = {}}
table.remove(givens, 1)
for i, v in ipairs(givens) do
    local a = tonumber(v) or v
    table.insert(command.args, a)
end

function shouldnumber(g)
    return type(g) == "number" and g
end

-- コマンドを解釈する
if command.name == "append" then
    local newpagenum = shouldnumber(command.args[1]) or (table.tail(info.releasepages) or 0) + 1
    addpage(newpagenum, nil)
elseif command.name == "insert" then
    local inum = shouldnumber(command.args[1])
    if inum then error("insert needs page number") end
    addpage(inum, insert)
elseif command.name == "drop" then
    if type(command.args[1]) == "number" then
        drop(command.args[1])
    elseif command.args[1] == "list" then
        showinfo("drop")
    elseif command.args[1] == "show" then
        show(command.args[2], "drop")
    end
elseif command.name == "restore" then
    restore(command.args[1], function(n)
        selection(drop, insert)(n)
    end)
elseif command.name == "mv" then
    move(command.args[1], command.args[2], function(n)
        selection(drop, insert)(n)
    end)
elseif command.name == "open" then
    open(command.args[1])
elseif command.name == "release" then
    release()
elseif command.name == "list" then
    showinfo(nil)
end

-- 状態を書き出す
require "tabletostr"

local infostr = "info = " .. tabletostr(info)
local fh = assert(io.open("projectinfo.lua", "w"))
fh:write(infostr)
fh:close()

