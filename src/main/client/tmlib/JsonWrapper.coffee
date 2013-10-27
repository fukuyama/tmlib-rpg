
# JsonWrapper クラス
# asset の Jsonファイル対応
tm.define 'tm.asset.JsonWrapper',
  superClass: tm.event.EventDispatcher

  # 初期化
  init: (path) ->
    @superInit()

    @loaded = false

    if typeof path == 'string'
      self = @
      tm.util.Ajax.load
        url: path
        dataType: 'json'
        success: (o) ->
          self.parse(o)
          self.loaded = true
          self.dispatchEvent tm.event.Event('load')
    else
      @parse(path)
      @loaded = true

  parse: (o) -> @$extend o

# AssetManager に json ファイル追加
tm.asset.AssetManager.register 'json', (path) -> tm.asset.JsonWrapper(path)
