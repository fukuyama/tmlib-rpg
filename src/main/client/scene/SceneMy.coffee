
tm.define "SceneMy",
  superClass: "tm.app.Scene"

  init: ->
    # 親の初期化
    @superInit()

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
      cols: 3
      rows: 2
      menus: [
        {name:'OK',fn: -> console.log 'ok'}
        {name:'NG',fn: -> console.log 'ng'}
        {name:'TEST1',fn: -> console.log 'test1'}
        {name:'TEST1',fn: -> console.log 'test1'}
        {name:'TEST2',fn: -> console.log 'test2'}
        {name:'TEST1',fn: -> console.log 'test1'}
        {name:'TEST1',fn: -> console.log 'test1'}
        {name:'TEST2',fn: -> console.log 'test2'}
        {name:'TEST2',fn: -> console.log 'test2'}
        {name:'TEST2',fn: -> console.log 'test2'}
      ]
    )
    @addChild(w)
