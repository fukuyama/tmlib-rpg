
tm.define "SceneMy",
  superClass: "tm.app.Scene"

  init: ->
    # 親の初期化
    @superInit()

    #@windowMenu()
    @shapeMessageLine()
    #@windowMessage()

  windowMessage: ->
    @windowMessage = rpg.WindowMessage
      messageSpeed: rpg.system.setting.messageSpeed
    @windowMessage.addChildTo @
    return

  shapeMessageLine: ->
    @bg = tm.display.RectangleShape(
      x: 0
      y: 0
      width: rpg.system.screen.width
      height: rpg.system.screen.height
      fillStyle: 'rgb(128,128,128)'
      strokeStyle: 'rgb(128,128,128)'
    ).addChildTo @
    @bg.setOrigin(0,0)

    @lines = []
    for i in [0 .. 5]
      line = rpg.ShapeMessageLine
        x: 0
        y: i * 24
        height: 24
        width: 140
      line.addChildTo @
      @lines.push line
    for line,i in @lines
      next = @lines[i + 1]
      unless next?
        break
      line.on 'start', ((i)->
        console.log 'start ' + i
        return
      ).bind @, i
      line.on 'end', ((next)->
        next.start()
        return
      ).bind @, next

    i = 0
    l = 0
    text = '01234\\n56789ABCDEFGHIJK'
    while i < text.length
      line = @lines[l++]
      unless line?
        break
      i = line.drawMarkup(text,i:i)
    @lines[0].start()
    return


  windowMenu: ->
    ###
    @win = w = rpg.Window(50, 50, 100, 100)
    @addChild(w)
    w.drawText("Hello",0,0)
    w.refresh()

    @onpointingmove = (e) ->
      p = e.app.pointing
      @win.content.translate(p.dx,p.dy)
      #@win.contentShape.x += p.dx
      #@win.contentShape.y += p.dy
    ###

    #w = rpg.Window(50, 50, 200, 200,title: 'title')
    #@addChild(w)
    #w.drawText("Hello",0,0)
    #w.refresh()

    #w = rpg.WindowInputNum(max:999900,step:100).open()
    #w.addCloseListener((-> console.log w.value))
    #@addChild(w)

    w = rpg.WindowMenu(
      title: 'Menu?'
      active: true
      x: 50
      y: 50
      cols: 3
      rows: 2
      menus: [
        {name:'OK',fn: -> console.log 'ok'}
        {name:'NG',fn: -> console.log 'ng'}
        {name:'TEST1',fn: -> console.log 'test1'}
        {name:'TEST2',fn: -> console.log 'test2'}
        {name:'TEST3',fn: -> console.log 'test3'}
        {name:'TEST4',fn: -> console.log 'test4'}
        {name:'TEST5',fn: -> console.log 'test5'}
        {name:'TEST6',fn: -> console.log 'test6'}
        {name:'TEST7',fn: -> console.log 'test7'}
        {name:'TEST8',fn: -> console.log 'test8'}
      ]
    )
    @addChild(w)

    ###
    rpg.WindowInputNum(
      title: 'TEST'
      unit: 'こ'
      max: 9990
      step: 10
    ).addChildTo(@).open()
    w = rpg.WindowMenu(
      active: true
      x: 50
      y: 50
      cols: 1
      rows: 3
      menus: [
        {name:'TEST',fn: -> console.log 'a'}
        {name:'B',fn: -> console.log 'b'}
        {name:'C',fn: -> console.log 'c'}
      ]
    )
    @addChild(w)
    ###
    return
