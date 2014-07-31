
# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# イベントページ
class rpg.EventPage

  # コンストラクタ
  constructor: (args={}) ->
    @setup(args)
    @_conditionFn =
      'flag.on?': @_checkCondFlag.bind(@,'is')
      'flag.>': @_checkCondFlagValueGreater
      'flag.<': @_checkCondFlagValueLesser
      'flag.==': @_checkCondFlagValueEqual
      
    triggerFunc = (key) ->
      for t in @trigger when t is key
        return true
      return false
    for k, v of rpg.EventPage.TRIGGER_TYPE
      f = v.charAt(0).toUpperCase() + v.slice(1)
      @['trigger'+f] = triggerFunc.bind(@, v)

  # 初期化
  setup: (args={}) ->
    {
      @name
      @trigger
      @condition
      @conditionLogic
      @commands
    } = {
      name: ''
      trigger: []
      condition: []
      conditionLogic: 'and'
      commands: []
    }.$extendAll(args)

  # 条件チェック
  checkCondition: (flag=rpg.system.flag) ->
    @_flag = flag
    f = @_conditionFn
    r = (d for d in @condition when f[d.type].apply(@, d.params))
    if @conditionLogic is 'and'
      r.length == @condition.length
    else
      r.length > 0

  # フラグ条件チェック
  _checkCondFlag: (op, key, url) ->
    @_flag[op].apply(@_flag, if key? then [key] else [key, url])

  _checkCondFlagValueGreater: (key, val, url) ->
    @_flag.get(key, url) > val

  _checkCondFlagValueLesser:  (key, val, url) ->
    @_flag.get(key, url) < val

  _checkCondFlagValueEqual:   (key, val, url) ->
    @_flag.get(key, url) == val

rpg.EventPage.TRIGGER_TYPE = {
  TALK:     'talk'     # 話されたら
  CHECK:    'check'    # 調べられたら
  TOUCH:    'touch'    # イベントがプレイヤーに触ったら
  TOUCHED:  'touched'  # イベントがプレイヤーに触られたら
  AUTO:     'auto'     # 自動起動
  PARALLEL: 'parallel' # 平行起動
}
