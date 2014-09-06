# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


class rpg.Flag

  constructor: (args={}) ->
    @setup(args)

  setup: (args={}) ->
    {
      @values
      @url
    } = {
      values: {}
      url: 'http://localhost:3000/'
    }.$extendAll args

    if @url != 'system'
      @system = new rpg.Flag(
        url: 'system'
      )
      # 同じものを指すに様にする
      @system.values = @values
      @system.clear()

    @clear()

  exist: (key,url=@url) ->
    @values[url]?[key]?

  'is': (key,url=@url) ->
    @values[url]? and 0 != @get(key, url)

  'isnt': (key,url=@url) ->
    not @is(key,url)

  'on': (key) ->
    @set(key,1) unless @is key

  'off': (key) ->
    @set(key,0)

  get: (key,url=@url) ->
    @values[url]?[key] ? 0

  set: (key, val) ->
    unless typeof val is 'number'
      throw new Error '設定できるのは数値のみです。' + val
    @values[@url][key] = val

  plus: (key, val) ->
    @set key, @get(key) + val

  minus: (key, val) ->
    @set key, @get(key) - val

  multi: (key, val) ->
    @set key, @get(key) * val

  div: (key, val) ->
    @set key, @get(key) / val if val isnt 0

  clear: ->
    @values[@url] = {}

  ###* イベントコマンドパラメータの正規化。
  * 数値パラメータにフラグが指定出来る場合に、フラグから値を取得するために正規化する。
  * @memberof rpg.Interpreter#
  * @param {num|string} val イベントコマンドのパラメータ
  * @return {num} 正規化された値
  ###
  normalizeValue: (val) ->
    if typeof val is 'string'
      url = null
      m = val.match /^system:(.+)$/
      if m?
        val = m[1]
        url = 'system'
      if url?
        val = @get(val,url) if @exist val, url
      else
        val = @get(val) if @exist val
    return val

  normalizeBool: (val) ->
    if typeof val is 'string'
      url = null
      m = val.match /^system:(.+)$/
      if m?
        val = m[1]
        url = 'system'
      if url?
        val = @is(val,url) if @exist val, url
      else
        val = @is(val) if @exist val
    return val
