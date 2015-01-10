###*
* @file SpritesetPicture.coffee
* スプライトピクチャー
* 画像表示用のスプライト
###

tm.define 'rpg.SpritesetPicture',

  superClass: tm.display.CanvasElement

  ###* 初期化
  * @param {Object} args 初期化パラメータ
  ###
  init: (args) ->
    @superInit()
    @pictures = {}

  ###* 更新処理
  * 画像を表示する。
  ###
  update: ->
    for key,sprite of @pictures when not rpg.game.pictures[key]?
      sprite.remove()
    for key,data of rpg.game.pictures
      unless @pictures[key]?
        @pictures[key] = tm.display.Sprite(data.src).addChildTo(@)
      pict = @pictures[key]
      pict.x = data.x
      pict.y = data.y
