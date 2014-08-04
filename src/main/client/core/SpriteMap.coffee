
# マップクラス
tm.define 'rpg.SpriteMap',

  superClass: tm.display.MapSprite

  # 初期化
  # map: マップの基本データ rpg.Map
  init: (@map) ->
    cw = ch = rpg.system.mapChipSize
    @superInit(@map.mapSheet, cw, ch)
    @map.events = {}
    if @events?
      i = 0
      for name, e of @events when e?.character instanceof rpg.Character
        e.character.name = e.character.name ? name
        @map.events[name] = e.character

    @_screenCX = rpg.system.screen.width / 2 - cw / 2
    @_screenCY = rpg.system.screen.height / 2 - ch / 2
    @_screenMX = @width - @_screenCX - cw
    @_screenMY = @height - @_screenCY - ch

    @updatePosition()

  updatePosition: () ->
    pc = rpg.system.player.character

    if pc.x < @_screenCX
      @x = 0
    else if pc.x > @_screenMX
      @x = rpg.system.screen.width - @width
    else
      @x = @_screenCX - pc.x

    if pc.y < @_screenCY
      @y = 0
    else if pc.y > @_screenMY
      @y = rpg.system.screen.height - @height
    else
      @y = @_screenCY - pc.y

    return
