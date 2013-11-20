
# マップクラス
tm.define 'rpg.SpriteMap',

  superClass: tm.display.MapSprite

  # 初期化
  # pc: 基準になる rpg.Character （プレイヤー）
  # map: マップの基本データ rpg.Map
  init: (@pc, @map) ->
    cw = ch = rpg.system.mapChipSize
    @superInit(@map.mapSheet, cw, ch)
    @map.mapSheet = @mapSheet
    if @events?
      @map.events = (e.character for e in @events.children)
    else
      @map.events = []

    @_screenCX = rpg.system.screen.width / 2 - cw / 2
    @_screenCY = rpg.system.screen.height / 2 - ch / 2
    @_screenMX = @width - @_screenCX - cw
    @_screenMY = @height - @_screenCY - ch

  updatePosition: () ->
    @x = @_screenCX - @pc.x if @_screenCX <= @pc.x and @pc.x <= @_screenMX
    @y = @_screenCY - @pc.y if @_screenCY <= @pc.y and @pc.y <= @_screenMY
    @
