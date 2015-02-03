###*
* @file Animation.coffee
* アニメーションイベント
* 特定の位置にアニメーションを表示する。
###

tm.define 'rpg.event_command.Animation',

  ###* イベントコマンドの反映。
  * Interpreter インスタンスのメソッドとして実行される。
  * イベントコマンド自体のインスタンスは、@event_command で取得する。
  * @memberof rpg.event_command.Animation#
  * @return {boolean} true の場合、引き続きこのメソッドが実行される。false の場合は、次のイベントへ続ける。
  ###
  apply_command: (param) ->
    {
      key
      src
    } = param
    if src?.sprites?
      # アニメーションに使用するスプライトをプリロード
      self = @
      self.waitFlag = true
      sprites = for key,sprite of src.sprites then sprite.src
      debugger
      rpg.system.db.preloadPicture sprites, (images) ->
        self.waitFlag = false
        rpg.game.animations[key] = src
    if rpg.game.animations[key]?
      rpg.game.animations[key].$extend src
    false

# ピクチャーイベント
rpg.event_command.animation = rpg.event_command.Animation()
