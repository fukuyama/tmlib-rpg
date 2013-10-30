# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

ASSETS =
  'sample.interpreter':
    name: ''

# イベントのインタプリタ
class rpg.Interpreter

  # コンストラクタ
  constructor: (args={}) ->
    @setup(args)

  # 初期化
  setup: (args={}) ->
    {
      @name
    } = {}.$extendAll(ASSETS['sample.interpreter']).$extendAll(args)

  start: (@events=[]) ->
    
