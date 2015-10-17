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

class SimpleAI
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

    # BUG: ロードはここじゃないな…
    list = (a.skill for a in @actions)
    rpg.system.db.preloadSkill list, (skills) ->
      for skill,i in skills
        @actions[i].skill = skill

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
