return {
    inherits = "継承する親ファイル"
    single_template = "単一ページのテンプレートへのパス",
    mihiraki_template = { path = "見開きページのテンプレートへのパス", count = 2}, -- count はページとしてカウントする枚数(見開きなら2ページ分)
    -- 始まりの指定
    begins = {right, left},
    viewer = "ビューワーへのパス", -- 単一引数をとりそれを表示する
    releaser = "リリースをするプログラムのパス" -- 二つ引数をとり第一引数を第に引数のディレクトリへ出力する
}

