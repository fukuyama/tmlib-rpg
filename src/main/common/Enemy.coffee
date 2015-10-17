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
      @actions
    } = {
      exp: 0
      actions: [
        {skill:1}
      ]
    }.$extendAll(@properties).$extendAll(args)

    @makeAction = @_simpleAction

    list = (a.skill for a in @actions)
    rpg.system.db.preloadSkill list, (skills) ->
      for skill,i in skills
        @actions[i].skill = skill

   # TODO:落とすアイテムとかの処理が必要

   _simpleAction: (args) ->
    {
      battler
      friends
      targets
      turn
    } = args
    action = {
      effect: null
      battler: battler
    }
    return action
