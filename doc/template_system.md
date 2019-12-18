# Template System

Imagemagick を利用してテンプレートを生成したり, 出力したファイルを加工する.
あらかじめ指定したテンプレートから見開きを切り出したり, テンプレートのテンプレート画像を生成する.

# ImageMagick memo
## crop
convert @in -crop [@w]x[@h]+[@x]+[@y] @out
## draw
convert @in @option -draw @command @out

### command
#### `"line x1, y1 x2, y2"`

#### `"point x, y"`
#### `"rectangle x1, y1 x2, y2"`

#### option
- `-stroke "#color"`
- `-strokewidth @px`
- `-fill "#color"`

## command connection
convert \( @in -@operation ... \) \(-@operation ... \) ... @out
