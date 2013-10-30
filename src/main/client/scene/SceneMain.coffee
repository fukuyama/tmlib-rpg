
tm.define 'SceneMain',
  superClass: rpg.SceneBase

  # 初期化
  init: ->
    # 親の初期化
    @superInit(name:'SceneMain')
    
    @window1 = rpg.WindowMenu
      active: true
      cols: 1
      rows: 2
      menus: [
        {name:'Menu1',fn:-> console.log '1'}
        {name:'Menu2',fn:-> console.log '2'}
      ]
    @addChild @window1

    @window2 = rpg.WindowMenu
      active: true
      cols: 2
      rows: 1
      x: @window1.right
      menus: [
        {name:'Menu1',fn:-> console.log '1'}
        {name:'Menu2',fn:-> console.log '2'}
      ]
    @addChild @window2

    @window3 = rpg.WindowMenu
      active: true
      cols: 2
      rows: 2
      y: @window1.bottom
      menus: [
        {name:'Menu1',fn:-> console.log '1'}
        {name:'Menu2',fn:-> console.log '2'}
        {name:'Menu3',fn:-> console.log '3'}
      ]
    @addChild @window3

    @window4 = rpg.WindowMenu
      active: true
      cols: 2
      rows: 2
      x: @window3.right
      y: @window3.top
      menus: [
        {name:'Menu1',fn:-> console.log '1'}
        {name:'Menu2',fn:-> console.log '2'}
        {name:'Menu3',fn:-> console.log '3'}
        {name:'Menu4',fn:-> console.log '4'}
      ]
    @addChild @window4

    @window5 = rpg.WindowMenu
      active: true
      cols: 3
      rows: 3
      x: @window3.left
      y: @window3.bottom
      menus: [
        {name:'Menu1',fn:-> console.log '1'}
        {name:'Menu2',fn:-> console.log '2'}
        {name:'Menu3',fn:-> console.log '3'}
        {name:'Menu4',fn:-> console.log '4'}
        {name:'Menu5',fn:-> console.log '5'}
      ]
    @addChild @window5
