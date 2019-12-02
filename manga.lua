-- manga.lua

-- ユーザーの設定を読み込む
require "settingloader"
-- "プロジェクトは開始できません: 理由: setting.lua がありません"
setting = loadSetting("setting.lua")

local function getext(setting)
    for k, v in pairs(setting) do
        if k:match("_template$") then
            local ext = setting[k]:match("%.([%a%d]+)$")
            if ext then return ext end
        end
    end
end

-- projectinfo.lua があるかを探す
local f = io.open("projectinfo.lua", "r")
if f ~= nil then
    io.close(f)
    info = dofile "projectinfo.lua"
    if info.template_ext ~= getext(setting) then
        error("テンプレートの拡張子はプロジェクト作成後に変更しないでください: 理由: 拡張子を揃えないで済む方法を開発中のため: 解決法: 元の拡張子に直してください")
    end
else
    -- 初期設定をする
    info = { releasepages = {}, droppages = {}, template_ext = nil}
    -- 拡張子を取得する
    local ext = getext(setting)
    if ext == nil then error("テンプレートには拡張子をつけてください: 理由: 拡張子を持たないテンプレートに対応させる方法を開発中のため") end
    --[[
    if ext1 ~= ext2 then error("テンプレートの拡張子は揃えてください: 理由: 拡張子を揃えないで済む方法を開発中のため") end
    ]]--
    info.template_ext = ext
end

-- モジュールの読み込み
require "addpage"
require "drop"
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
    local newpagenum = (table.tail(info.releasepages) or 0) + 1
    local template_name = command.args[1]
    addpage(newpagenum, nil, template_name)
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
else
    error(command.name .. " というコマンドはありません. 終了します.: 理由: 与えられたコマンドは存在しない.")
end

-- 状態を書き出す
require "tabletostr"

local infostr = "return " .. tabletostr(info)
local fh = assert(io.open("projectinfo.lua", "w"))
fh:write(infostr)
fh:close()

