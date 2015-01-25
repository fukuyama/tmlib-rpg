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
    # スプライトセットにあって、ゲームデータに無いものは削除
    for key,sprite of @pictures when not rpg.game.pictures[key]?
      sprite.remove()
    # ゲームデータのピクチャーを表示
    for key,data of rpg.game.pictures
      unless @pictures[key]? # まだ表示してない場合スプライトを作成
        @pictures[key] = tm.display.Sprite(data.src)
          .addChildTo(@)
      # ピクチャーの設定
      pict = @pictures[key]
      # 位置
      pict.x = data.x
      pict.y = data.y
      pict.origin.x = data.origin.x
      pict.origin.y = data.origin.y
      pict.scale.x = data.scale.x
      pict.scale.y = data.scale.y
