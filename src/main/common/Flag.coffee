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
    @values[@url] = {}
    
  'is': (key) ->
    0 != @get key

  'on': (key) ->
    @values[@url][key] = 1 unless @is key

  'off': (key) ->
    @values[@url][key] = 0

  get: (key) ->
    @values[@url][key] ? 0

  set: (key, val) ->
    @values[@url][key] = val
