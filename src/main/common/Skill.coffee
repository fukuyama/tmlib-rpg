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
    @_effect = new rpg.Effect args

  ###* 効果メソッド
  * @param {rpg.Battler} user 使用者
  * @param {Array} target 対象者(rpg.Battler配列)
  * @param {Object} log 効果ログ情報
  * @return {boolean} 効果ある場合 true
  ###
  effect: (user,targets = [],log = {}) ->
    @_effect.effect(user,targets,log)
