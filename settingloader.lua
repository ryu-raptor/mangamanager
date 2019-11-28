-- 設定読み込み

local function dirname(str)
    -- スラッシュチェック
    if not str:match("/") then
        return "./"
    end
    return str:match("^(.+/)")
end

function loadSetting(settingFilePath) --> table
    if not os.rename(settingFilePath, settingFilePath) then
        error("設定ファイルが見つかりませんでした. 作成するか, inherits で指定している場合はパスが正しいか確認してください: 問題のパス: " .. settingFilePath)
    end

    local tmp = dofile(settingFilePath)

    if tmp.inherits ~= nil then
        local root = loadSetting(tmp.inherits)
        -- merge setting
        -- 継承ファイルのディレクトリを取得
        local inheritsdir = dirname(tmp.inherits)
        -- root のテンプレートパスを書き換える
        for k, v in pairs(root) do
            -- テンプレートパス
            local kk = k:match("_template$")
            if kk then
                local origin = root[k]
                -- テンプレートパスを書き換え
                root[k] = inheritsdir .. origin
            end
        end

        -- ローカルを上書き
        for k, v in pairs(tmp) do
            root[k] = v
        end
        tmp = root
    end

    return tmp
end

