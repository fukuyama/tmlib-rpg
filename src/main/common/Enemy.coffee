###*
* @file Enemy.coffee
* エネミークラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# エネミークラス
class rpg.Enemy extends rpg.Battler

  ###*
  * コンストラクタ
  * @classdesc エネミークラス
  * @constructor rpg.Enemy
  * @extends rpg.Battler
  * @param {Object} args
  ###
  constructor: (args={}) ->
    super(args)
    {
      @exp
    } = {
      exp: 0
    }.$extendAll(@properties).$extendAll(args)

    @ai = new rpg.SimpleAI(args.ai)
    @makeAction = @ai.makeAction

   # TODO:落とすアイテムとかの処理が必要

class rpg.SimpleAI
  constructor: (args={}) ->
    {
      @actions
    } = {
      actions: [
        {skill:1}
      ]
    }.$extendAll(args)

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

    return true
