-- ページに関する情報を更新する

local pm = {}

-- *_template の内容からこのクラスで用いる構造体を生成
function pm.getpageinfofrom(template) --> PageInfo
    
end

-- ページ番号から取得
-- 1, 2, {3, 4}, {5, 6}, 7, 8 とあったとき
-- 3 や 6 と指定するだけで見開きごと取り扱えるようにする
-- insert single 3 => 1, 2, 3, {4'3, 5'4}, {6'5, 7'6}, ...
-- mv 3 7 => 1, 2, {3'5, 4'6}, {5'3, 6'4}, ...
function pm.getpageinfoat(at) --> PageInfo
    
end

-- ページを追加
-- info :: PageInfo
function pm.addpage(info)
    
end

-- ページを挿入
-- info, at :: PageInfo
function pm.insertpage(info, at)
    
end

-- ページを削除
-- at :: PageInfo
function pm.removepage(at)
    
end

-- ページをdrop
function pm.droppage(at) --> DroppedPageInfo : PageInfo
    
end

-- Drop から削除
function pm.undrop(of) --> PageInfo
    
end
