# 使い方
## 下準備
1. プロジェクトのディレクトリへ移動する
2. プロジェクトの設定として Lua テーブルファイルを用意する
3. manga コマンドで管理を開始する

## ディレクトリ構成
```
.
|- setting.lua // 設定
|- projectinfo.lua // manga が利用するプロジェクトの構成を記録したファイル
|- .drop // 下書きを保存するディレクトリ
|  |- ... // 下書きファイル
|
|- ... // manga が生成するファイルのディレクトリ
|- ... // 作家の自由にファイルを配置する
```

## コマンド詳細
### `manga append ([template_name])`
新しくページを追加する.
`template_name` を指定した場合は, setting.lua のなかの `[template_name]_template` という項目のファイルを用いる. デフォルトは `single`.

### `manga insert [page number]`
新しくページを挿入する.
引数は挿入をしようとするページのページ番号.
既に存在する場合はその位置へページを挿入し, その位置から最後のページまでのページを後ろへずらす.

### `manga list`
プロジェクトの概要を表示する.

### `manga mv [from page number] [to page number]`
ページを移動する.
from がない場合は失敗する.
to がある場合は insert か drop の挙動を選択させ, そのようにする.

### `manga drop {[page number], list, show [page id]}`
ページを仕上がりから外す.
drop されたページは .drop というディレクトリへ移動させる.

list を指定した場合は drop されたページの一覧を表示する.

show は指定したビューワで該当のページを確認する.

### `manga restore [dropped page id]`
該当の drop ページを仕上がりへ復帰させる.
既に存在している場合は insert か drop の挙動を選択させ, そのようにする.

### `manga open [page number]`
指定した方法でページをオープンする.

### `manga release`
現在のプロジェクトを仕上げ用ディレクトリへコピーさせる.
release というディレクトリに出力される.
出力方法が指定されている場合はそれに従う.

