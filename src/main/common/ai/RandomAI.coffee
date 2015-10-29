###*
* @file RandomAI.coffee
* シンプルＡＩクラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}
rpg.ai = rpg.ai ? {}

###
action.cond が、true の場合に使用する。無い場合は常にtrue
action.conds は、conds_type　で、andかor判定 default and

actions = [
  ターン数
  {
    skill: 1
    cond:
      op: '>'
      turn: 1
  }
  相手の人数
  {
    skill: 1
    cond:
      op: '>'
      targets: 2
  }
  味方の人数
  {
    skill: 1
    cond:
      op: '>'
      friends: 2
  }
  ステータス(ON/OFF)
  {
    skill: 1
    cond:
      op: '<'
      status:
        value: 1
        targets: 2
  }
]
###
class rpg.ai.RandomAI
  ###*
  * シンプルＡＩ
  ###
  constructor: (args={}) ->
    {
      @actions
    } = {
      actions: []
    }.$extendAll(args)

    for a in @actions
      if a.skill?
        unless a.skill instanceof rpg.Skill
          a.skill = rpg.system.db.getSkill a.skill
    return

  makeAction: (args) ->
    {
      @battler
      @friends
      @targets
      @turn
    } = args
    actions = (a for a in @actions when @_isEffective a)
    return actions[ Math.rand(0, actions.length - 1) ]

  _isEffective: (action) ->
    return true unless action.cond?

    conds_type = action.conds_type ? 'and'
    conds = action.conds ? [action.cond]
    ret = true
    if conds_type is 'and'
      ret = true
      for cond in conds
        unless @_checkCond cond
          ret = false
          break
    else
      ret = false
      for cond in conds
        if @_checkCond cond
          ret = true
          break
    return ret

  _checkCond: (cond) ->
    if cond.turn?
      return rpg.utils.jsonExpression @turn,cond.op,cond.turn
    if cond.targets?
      return rpg.utils.jsonExpression @targets.length,cond.op,cond.targets
    if cond.friends?
      return rpg.utils.jsonExpression @friends.length,cond.op,cond.friends
    if cond.status?
      return @_checkCondStatus cond
    return false

  _checkCondStatus: (cond) ->
    if cond.status.targets?
      list = @targets
      value = cond.status.targets
    if cond.status.friends?
      list = @friends
      value = cond.status.friends
    count = 0
    for o in list
      count += o.getStates(cond.status.value).length
    return rpg.utils.jsonExpression count,cond.op,value
