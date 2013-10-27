
tm.define "Hoehoe",
  init: (@name)->
    console.log "Hoehoe #{@name}"
    
  func1: ->
    console.log "HoeHoe.func1 #{@name}"
  
  super: (klass,name) ->
    klass.prototype[name].bind(this)

tm.define "MyHoehoe1",
  superClass: "Hoehoe"
  init: (@name)->
    @superInit @name
    console.log "MyHoehoe1 #{@name}"
    
  func1: ->
    Hoehoe.prototype.func1.apply(this,arguments)
    console.log "MyHoehoe1.func1 #{@name}"

tm.define "MyHoehoe2",
  superClass: "MyHoehoe1"
  init: (@name)->
    @superInit @name
    console.log "MyHoehoe2 #{@name}"
    
  func1: ->
    @super(MyHoehoe1,'func1',arguments)
    #MyHoehoe1.prototype.func1.apply(this,arguments)
    console.log "MyHoehoe2.func1 #{@name}"


tm.define "MainScene",
  superClass: "tm.app.Scene"

  init: ->
    # 親の初期化
    @superInit()
    
    h = MyHoehoe2('TEST')
    h.func1()

    window1 = rpg.Window(50, 50, 200, 200)
#    window2 = rpg.WindowMenu(
#        top: 10
#        left: 10
#        menus: [
#          'ほえほえほえほえ'
#          'menu2'
#        ])

    #window1.content.setFillStyle('rgba(128,0,0,0.5)')
    #window1.content.fillRect(0,0,200,200)
    window1.content.setFillStyle('rgb(255,0,0)')
    window1.drawText("はろ～!",0,0)
    #window1.contentOrigin.y = 16
#    window1.resize(400,200)
    window1.refresh()
    #window2.refresh()
#    window2.cursor.setIndex(1)

    @addChild(window1)
#    @addChild(window2)
#    @$extend _MainScene.prototype
#    @func1()
