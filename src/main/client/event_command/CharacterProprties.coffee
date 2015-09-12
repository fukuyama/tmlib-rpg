###*
* @file CharacterProprties.coffee
* キャラクタープロパティ変更
###

tm.define 'rpg.event_command.CharacterProprties',

  ###* コンストラクタ
  * @classdesc キャラクタープロパティ変更
  * @constructor rpg.event_command.CharacterProprties
  * @param {string} name プロパティ名
  ###
  init: (name) ->
    @name = name

  ###* イベントコマンドの反映。
  * Interpreter インスタンスのメソッドとして実行される。
  * イベントコマンド自体のインスタンスは、@event_command で取得する。
  * @memberof rpg.event_command.CharacterProprties#
  * @param {string} chara プロパティを反映するキャラクター名（イベント名）
  *                 プレイヤーキャラクターの場合は、'player'
  * @param {any} val プロパティに設定する値
  * @return {boolean} false
  ###
  apply_command: (chara, val) ->
    c = @findCharacter(chara)
    c?[@event_command.name] = val
    false

# 表示(true) 非表示(false)
rpg.event_command.visible =
  rpg.event_command.CharacterProprties('visible')
# すり抜ける(true) すり抜けない(false)
rpg.event_command.transparent =
  rpg.event_command.CharacterProprties('transparent')
