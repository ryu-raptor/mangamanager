function tabletostr(t)
    local function convmodule(t) --> string
        local result = "{"

        local function appendvalue(v)
            local vv = v
            if type(v) == "table" then
                vv = convmodule(v)
            elseif type(v) == "string" then
                vv = "\"" .. v .. "\""
            end
            result = result .. vv
            result = result .. ", "
        end

        local array = {} -- 配列のみを別で出力する

        for k, v in pairs(t) do
            if type(k) == "number" then
                array[k] = v
                goto continue
            end

            result = result .. k .. " = "
            appendvalue(v)
            ::continue::
        end
        -- 配列の出力
        -- 1. 連番
        for i, v in ipairs(array) do
            appendvalue(v)
            -- 削除(仕様上許される)
            array[i] = nil
        end
        -- 2. 飛び番
        for k, v in pairs(array) do
            result = result .. "[" .. k .. "]" .. " = "
            appendvalue(v)
        end
        result = result .. "}"
        return result
    end

    return convmodule(t)
end
