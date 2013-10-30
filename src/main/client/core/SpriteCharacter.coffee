
# キャラクタースプライトクラス
tm.define 'rpg.SpriteCharacter',

  superClass: tm.app.AnimationSprite

  # 初期化
  init: (@character) ->
    if typeof @character is 'string'
      @character = new rpg.Character tm.asset.AssetManager.get(@character)
    if (not (@character instanceof rpg.Character)) and
    typeof @character is 'object'
      @character = new rpg.Character @character
    @superInit(@character.spriteSheet)
    @origin.set(0, 0)
    {
      @spriteSheet
      @x
      @y
      @animationName
      @directionNum
    } = @character
    @_animationStop = ''
    @_prevFrameIndex = 0
    if not @character.directionFix
      @gotoAndStop(@character.direction)
    if @character.isAnimation()
      @gotoAndPlay(@animationName) if @animationName != ''

  # 向き
  updateDirection: ->
    return unless not @character.directionFix
    if @directionNum != @character.directionNum
      @gotoAndStop(@character.direction)
      @directionNum = @character.directionNum

  # 位置
  updatePosition: ->
    @x = @character.x
    @y = @character.y

  # アニメーション
  updateAnimation: ->
    return unless @character.isAnimation()
    if @animationName != @character.animationName
      if @character.animationName != ''
        @gotoAndPlay(@character.animationName)
        @currentFrameIndex = @_prevFrameIndex + 1
        @_normalizeFrame()
      else if @animationName != ''
        @_prevFrameIndex = @currentFrameIndex
        @gotoAndStop(@animationName)
      @animationName = @character.animationName

  # 更新
  update: ->
    # キャラクターの更新
    @character.update()
    # @character を監視して変更があれば自身に反映
    @updateDirection()
    @updatePosition()
    @updateAnimation()
