###*
* @file WindowMapStatus.coffee
* マップシーンで表示するステータスウィンドウ
###

# マップシーンで表示するステータスウィンドウ
tm.define 'rpg.WindowMapStatus',
  superClass: rpg.Window

  ###* コンストラクタ
  * @classdesc マップシーンで表示するステータスウィンドウ
  * @constructor rpg.WindowMapStatus
  * @param {Object} args
  ###
  init: (args={}) ->
    {
      @windowMapMenu
    } = args
    @stopCount = 0
    # parent = args.parent
    l = rpg.game.party.length
    w = l * (24 * 4) + 16 * 2 + (l - 1) * 8
    h = rpg.system.lineHeight * 4
    x = rpg.system.screen.width - w - 16
    y = rpg.system.screen.height - h - 16

    @superInit(x,y,w,h,{
      name: 'MapStatus'
      visible: false
    }.$extend args)
    @fontSize = '24px'
    @drawStatus()

    @on "enterframe", @updateStatus

  updateStatus: ->
    player = rpg.game.player
    pc = player.character
    if not player.active
      @visible = true
      @stopCount = 0
    else
      if player.awake and player.active and pc.isStopping()
        if @stopCount > 90
          @visible = true
        else
          @stopCount += 1
          @visible = false
      else
        @stopCount = 0
        @visible = false

  ###* ステータスの描画
  * @memberof rpg.WindowMapStatus#
  ###
  drawStatus: ->
    @content.clear()
    x = 0
    y = 0
    self = @
    rpg.game.party.each (actor) ->
      self.drawActor(actor,x,y)
      x += (24 * 4) + 8
    @refresh()

  drawActor: (a,x,y) ->
    op = {}
    @drawText(a.name,x,y,op)
    y += rpg.system.lineHeight
    @drawText("#{a.hp}/#{a.maxhp}",x,y,op)
    y += rpg.system.lineHeight
    @drawText("#{a.mp}/#{a.maxmp}",x,y,op)
