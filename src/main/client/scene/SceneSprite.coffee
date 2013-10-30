tm.define "SceneSprite",

  superClass: "tm.app.Scene"

  init: ->
    tm.asset.AssetManager.load('test001','img/test001.png')

    # 親の初期化
    this.superInit()
  
    sprite = tm.app.Sprite('test001', 128, 128)
    sprite.srcRect.width = 128
    sprite.srcRect.height = 128

    this.sprite = sprite
    this.addChild(this.sprite)
