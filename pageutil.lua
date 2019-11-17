-- ファイル生成に関する実際の処理を行う
-- ページの整合性などのチェックはここでは行わず, より上位のレイヤーで行う
-- ファイルシステムに関するエラーはここで投げる

local md5 = require "md5"
local lfs = require "lfs"
page = {}

local function exists(name)
    if type(name) ~= "string" then return false end
    return os.rename(name, name) and true or false
end

function cp(source, dest)
    local fh = assert(io.open(source, "rb"))
    local dfh = assert(io.open(dest, "wb"))
    dfh:write(fh:read("a"))
    io.close(fh)
    io.close(dfh)
end

local function formatfilename(number, ext)
    return string.format("%03d.%s", number, ext)
end

function page.create(number, template)
    local path = formatfilename(number, info.template_ext)
    cp(template, path)
    return true
end

-- ページを下書きへ落とす
function page.drop(number)
    -- id の生成
    -- 時刻を用いて生成した乱数で乱数を生成する
    math.randomseed(os.time())
    math.randomseed(math.random(math.maxinteger))
    local seed = math.random(math.maxinteger)
    local m = md5.new()
    m:update(tostring(number))
    m:update(tostring(seed))
    local id = md5.tohex(m:finish())

    -- ディレクトリがあるかを調べる
    if not exists(".drop") then
        lfs.mkdir(".drop")
    end
    local originpath = formatfilename(number, info.template_ext)
    os.rename(originpath, ".drop/" .. id .. "." .. info.template_ext)
    return id
end

-- 下書きのページを元に戻す
function page.restore(dropinfo)
    local path = ".drop/" .. dropinfo.id .. "." .. info.template_ext
    local originpath = formatfilename(dropinfo.origin, info.template_ext)
    assert(os.rename(path, originpath))
end

