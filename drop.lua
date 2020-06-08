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

