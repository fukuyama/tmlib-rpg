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
