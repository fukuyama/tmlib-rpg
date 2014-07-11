
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
      for e in @events.children
        @map.events[e.name] = e.character
        e.character.name = e.character.name ? e.name

    @_screenCX = rpg.system.screen.width / 2 - cw / 2
    @_screenCY = rpg.system.screen.height / 2 - ch / 2
    @_screenMX = @width - @_screenCX - cw
    @_screenMY = @height - @_screenCY - ch

  updatePosition: () ->
    pc = rpg.system.player.character
    @x = @_screenCX - pc.x if @_screenCX <= pc.x and pc.x <= @_screenMX
    @y = @_screenCY - pc.y if @_screenCY <= pc.y and pc.y <= @_screenMY
    return
