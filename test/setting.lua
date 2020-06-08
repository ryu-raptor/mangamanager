return {
    inherits = "./templates/adw_setting.lua",
    -- 始まりの指定
    begins = {right, left},
    viewer = "ビューワーへのパス", -- 単一引数をとりそれを表示する
    releaser = "リリースをするプログラムのパス" -- 二つ引数をとり第一引数を第に引数のディレクトリへ出力する
}
