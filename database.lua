-- カプセル化されたデータベースを提供する
--
-- interface:
-- local db = Database.new()
-- db.key:get() -> table
-- db.newkey:replace(newt) -> OK
-- db.newkey:get() -> nil
-- db.notablekey:insert(i) -> error

local Database = {}
local methodset = {}

local buildmethod

-- 存在しないキーに対してスタブのメソッド群を提供する
local function meta_index(table, key)
    local stub = {}
    for k, v in pairs(methodset) do
        stub[k] = buildmethod(v, table, key)
    end

    return stub
end

-- データベースを作成する
-- source は元となるテーブル
-- コピーはされないので注意
function Database.new(source)
    local o = {}
    local mt = {}
    assert(meta_index)
    mt.__index = meta_index
    mt.opener = opener
    mt.exporter = exporter
    mt.db = source
    setmetatable(o, mt)
    return o
end

-- メタテーブル内にデータベースをかくしているのでそれを取得する
local function get_db(self)
    local mt = getmetatable(self)
    return mt.db
end

local function set_db(self, newdb)
    local mt = getmetatable(self)
    mt.db = newdb
end

-- データベースを出力する
function Database.export(self, exporter)
    exporter = exporter or Database.standardexporter
    return exporter(get_db(self))
end

-- 標準 exporter
require "tabletostr"
function Database.standardexporter(db)
    return tabletostr(db)
end

-- キーに特化した操作を作成する
-- db.key:get() を実現する
-- get は内部的に methodset.get(db, key) を呼ぶ
buildmethod = function (f, self, key)
    return function (...)
        return f(self, key, ...)
    end
end

-- キーに対応する値を取り出す
function methodset.get(self, key)
    return get_db(self)[key]
end

-- キーに対応する値を変更する
function methodset.replace(self, key, newv)
    get_db(self)[key] = newv
end

-- キーに対応するテーブルに値を挿入する
function methodset.insert(self, key, elem)
    table.insert(get_db(self)[key], elem)
end

-- キーに対応するテーブルに値を挿入し, ソートする
function methodset.insertsort(self, key, elem, comp)
    methodset.insert(self, key, elem)
    table.sort(get_db(self)[key], comp)
end

return Database
