###*
* @file Picture.coffee
* ピクチャーイベント
###

tm.define 'rpg.event_command.Picture',

  ###* イベントコマンドの反映。
  * Interpreter インスタンスのメソッドとして実行される。
  * イベントコマンド自体のインスタンスは、@event_command で取得する。
  * @memberof rpg.event_command.ShopItemMenu#
  * @return {boolean} メニュー表示中は、true
  ###
  apply_command: (param) ->
    {
      src
      x
      y
    } = {
      x: 0
      y: 0
    }.$extendAll param
    return false

# ピクチャーイベント
rpg.event_command.picture = rpg.event_command.Picture()
