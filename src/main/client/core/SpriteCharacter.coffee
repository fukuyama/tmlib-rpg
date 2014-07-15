
# キャラクタースプライトクラス
tm.define 'rpg.SpriteCharacter',

  superClass: tm.display.AnimationSprite

  # 初期化
  init: (@character) ->
    if typeof @character is 'string'
      data = tm.asset.Manager.get(@character).data
      @character = new rpg.Character data
    if (not (@character instanceof rpg.Character)) and
    typeof @character is 'object'
      if @character.pages?
        @character = new rpg.Event @character
      else
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
    @_prevFrameIndex = 0
    if not @character.directionFix
      @gotoAndStop(@character.direction)
    if @character.isAnimation()
      @gotoAndPlay(@animationName) if @animationName != ''

  # 向き
  updateDirection: ->
    return unless not @character.directionFix
    if @directionNum != @character.directionNum
      unless @character.directionFix
        @currentAnimation = @ss.animations[@character.direction]
      @directionNum = @character.directionNum

  # 位置
  updatePosition: ->
    @x = @character.x
    @y = @character.y

  # アニメーション
  updateAnimation: ->
    return unless @character.isAnimation()
    # TODO:　まだまだ未完成
    if @animationName != '' or @character.animationName != ''
      if @animationName != @character.animationName
        if @character.animationName != ''
          @gotoAndPlay(@character.animationName)
          @currentFrameIndex = @_prevFrameIndex + 1
          @_normalizeFrame()
        else if @animationName != ''
          @_prevFrameIndex = @currentFrameIndex
          @gotoAndStop(@animationName)
        @animationName = @character.animationName
    else
      if @character.isStop()
        if @character.isAnimationStop()
          if @currentFrameIndex == 0 or @paused
            @gotoAndPlay(@character.direction)
        else
          @gotoAndStop(@character.direction)
      if @character.isMove()
        if @character.isAnimationMove()
          if @currentFrameIndex == 0 or @paused
            @gotoAndPlay(@character.direction)
        else
          @gotoAndStop(@character.direction)

  # 更新
  update: ->
    # キャラクターの更新
    @character.update()
    # @character を監視して変更があれば自身に反映
    @updateDirection()
    @updatePosition()
    @updateAnimation()
