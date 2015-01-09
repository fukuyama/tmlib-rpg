###*
* @file SpritePicture.coffee
* スプライトピクチャー
* 画像表示用のスプライト
###

tm.define 'rpg.SpritePicture',

  superClass: tm.display.Shape

  ###* 初期化
  * @param {Object} args 初期化パラメータ
  * @param {string} args.key 画像キー
  * @param {string} args.src 画像リソース
  ###
  init: (args) ->
    {
      @key
      src
    } = args
    texture = tm.asset.Manager.get(src)
    @superInit(texture.width,texture.height)
    @canvas.drawTexture(@texture,0,0)
