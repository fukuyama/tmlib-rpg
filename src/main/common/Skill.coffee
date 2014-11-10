###*
* @file Skill.coffee
* スキルクラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# スキルクラス
class rpg.Skill

  ###*
  * コンストラクタ
  * @classdesc スキルクラス
  * @constructor rpg.Skill
  * @param {Object} args
  ###
  constructor: (args={}) ->

  ###* 攻撃コンテキスト作成
  * @method rpg.Skill#createAttackContext
  * @param {rpg.Actor} user 使用者
  * @param {rpg.Actor} target 使用する対象
  ###
  createAttackContext: (user, target) ->
    atkcx = {damage:100,attrs:['物理']}
