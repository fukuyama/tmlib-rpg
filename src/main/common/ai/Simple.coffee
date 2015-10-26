###*
* @file Simple.coffee
* シンプルＡＩクラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}
rpg.ai = rpg.ai ? {}

###
action.conds は、or 条件

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
      status: [1]
  }
]
###
class rpg.ai.Simple
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
    skills = (a.skill for a in @actions when @_isEffective a)
    action = {
      effect: null
      battler: battler
    }
    return action

  _isEffective: (action) ->
    conds = action.conds
    if action.cond?
      conds.push action.cond
    for cond in conds
      if @_checkCond cond
        return true
    return false

  _checkCond: (cond) ->
    if cond.turn?
      return rpg.utils.jsonExpression @turn,cond.op,cond.turn
    return false
