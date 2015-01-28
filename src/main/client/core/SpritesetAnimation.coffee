###*
* @file SpritesetAnimation.coffee
* スプライトアニメーション
* アニメーション用のスプライト
* rpg.game.animations のデータ(json)からアニメーションを表示する
###

tm.define 'rpg.SpritesetAnimation',

  superClass: tm.display.CanvasElement

  ###* 初期化
  * @param {Object} args 初期化パラメータ
  ###
  init: (args) ->
    @superInit()
    @animations = {}

  ###* 更新処理
  * 画像を表示する。
  ###
  update: ->
    # スプライトセットにあって、ゲームデータに無いものは削除
    #for key,sprite of @animations when not rpg.game.animations[key]?
    #  sprite.remove()
    # ゲームデータのアニメーションを表示
    for key,data of rpg.game.animations
      unless @animations[key]? # まだ表示してない場合アニメーションを作成
        @animations[key] = rpg.Animation(data)
          .addChildTo(@)
      # ピクチャーの設定
      anime = @animations[key]
      # 位置
      anime.position.setObject data
      anime.origin.setObject data.origin
      anime.scale.setObject data.scale
