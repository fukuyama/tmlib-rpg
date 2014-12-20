
tm.define "SceneMy",
  superClass: "tm.app.Scene"

  init: ->
    # 親の初期化
    @superInit()

    ###
    @win = w = rpg.Window(50, 50, 100, 100)
    @addChild(w)
    w.drawText("Hello",0,0)
    w.refresh()

    @onpointingmove = (e) ->
      p = e.app.pointing
      @win.contentShape.x += p.dx
      @win.contentShape.y += p.dy
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
