###*
* @file Picture.coffee
* ピクチャーイベント
* 特定の位置に画像を表示する。
###

tm.define 'rpg.event_command.Picture',

  ###* イベントコマンドの反映。
  * Interpreter インスタンスのメソッドとして実行される。
  * イベントコマンド自体のインスタンスは、@event_command で取得する。
  * @memberof rpg.event_command.Picture#
  * @return {boolean} true の場合、引き続きこのメソッドが実行される。false の場合は、次のイベントへ続ける。
  ###
  apply_command: (param) ->
    {
      key
      src
      x
      y
    } = {
      x: 0
      y: 0
    }.$extendAll param
    self = @
    @waitFlag = true
    rpg.system.db.preloadPicture [src], (images) ->
      self.waitFlag = false
      rpg.game.pictures[key] = param
    false

# ピクチャーイベント
rpg.event_command.picture = rpg.event_command.Picture()
