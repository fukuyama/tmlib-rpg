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
        @animations[key] = @_createAnimation(data).addChildTo(@)
      # ピクチャーの設定
      anime = @animations[key]
      # 位置
      anime.position.setObject data
      anime.origin.setObject data.origin
      anime.scale.setObject data.scale

  _createAnimation: (data) ->
    element = tm.display.CanvasElement()
    element.sprites = {}
    #debugger
    for key,val of data.sprites
      sprite = tm.display.Sprite(val.src).addChildTo(element)
      if val.size?
        sprite.setSize.apply sprite, val.size
      if val.frameIndex?
        sprite.setFrameIndex.apply sprite, val.frameIndex
      element.sprites[key] = sprite
    if data.timeline?
      delay = 0
      for tl in data.timeline
        for key, val of tl
          delay += val.delay if val.delay?
          element.sprites[key].timeline.set delay, val
        delay += 1

    return element
