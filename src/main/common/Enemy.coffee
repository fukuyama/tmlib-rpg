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

    @ai = new rpg.ai.RandomAI(args.ai)
    @makeAction = @ai.makeAction

    # TODO:落とすアイテムとかの処理が必要

  isActionInput: ->
    return false
