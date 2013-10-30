
# _load を書き直しちゃを…

# [1] AssetManager で直接 hash を設定できるようにしたい
# 主にデバック用なきもするけど、json ファイルつくるのめんどうなんだもーん。
# これなら後で json ファイルにすることもできるし
# 使うほうは、json ファイル なのか hash オブジェクトなのか気にしなくてよくなるかな～と
#
# 生成するインスタンスの init() が hash を引数にすることが可能で
# 通常は、json ファイルを設定する場合
# tm.asset.AssetManager.load('character-001.spritesheet',
#   'data/character-001.tmss')
# のような場合 tm.asset.SpriteSheet を生成するのだけど
#
# これを以下の様に設定可能にする
# tm.asset.AssetManager.load('character-001.spritesheet',
#   {_type:'tmss', image: 'character-001', frame: ....})
# って感じ？
#

# 元の _load を保存
tm.asset.AssetManager._original_load = tm.asset.AssetManager._load

# _load メソッドの書き直し
tm.asset.AssetManager._load = (key, path) ->
  console.log key
  return if @contains(key)
  if typeof path == 'string'
    # path が string の場合は、元の _load を実行
    @_original_load(key, path)
  else
    # string 以外は、hadh として、_type のキーを持つ関数を実行する
    console.assert(path._type?,'asset の path._type が設定されてない。')
    @assets[key] = @_funcs[path._type](path)
    # 消してもいいよね。
    delete path._type
    # ロード処理が無いので、load イベントのつじつま合わせ、これでいいのかな？
    setTimeout(@_checkLoadedFunc.bind(@), 500)
