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
  apply_command: (_param) ->
    {
      src
      key
    } = param = {
      x: 0
      y: 0
    }.$extendAll _param
    self = @
    @waitFlag = true
    if src?
      rpg.system.db.preloadPicture [src], (images) ->
        self.waitFlag = false
        rpg.game.pictures[key] = param
    if rpg.game.pictures[key]?
      rpg.game.pictures[key].$extend param
    false

# ピクチャーイベント
rpg.event_command.picture = rpg.event_command.Picture()

tm.define 'rpg.event_command.PictureRemove',

  ###* イベントコマンドの反映。
  * Interpreter インスタンスのメソッドとして実行される。
  * イベントコマンド自体のインスタンスは、@event_command で取得する。
  * @memberof rpg.event_command.Picture#
  * @return {boolean} true の場合、引き続きこのメソッドが実行される。false の場合は、次のイベントへ続ける。
  ###
  apply_command: (param) ->
    {key} = param
    if rpg.game.pictures[key]?
      delete rpg.game.pictures[key]
    false

# ピクチャー削除イベント
rpg.event_command.picture_remove = rpg.event_command.PictureRemove()
