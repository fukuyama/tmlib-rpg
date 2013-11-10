tm.define 'SceneMenuTest2',
  superClass: rpg.SceneBase

  # 初期化
  init: ->
    # 親の初期化
    @superInit(name:'SceneMenuTest2')

    @window1 = rpg.WindowMenu
      active: true
      cols: 2
      rows: 2
      x: 0
      y: 0
      menus: [
        {name:'Menu1',fn:-> console.log '1'}
        {name:'Menu2',fn:-> console.log '2'}
        {name:'Menu3',fn:-> console.log '3'}
        {name:'Menu4',fn:-> console.log '4'}
        {name:'Menu5',fn:-> console.log '5'}
        {name:'Menu6',fn:-> console.log '6'}
        {name:'Menu7',fn:-> console.log '7'}
        {name:'Menu8',fn:-> console.log '8'}
        {name:'Menu9',fn:-> console.log '9'}
        {name:'A',fn:-> console.log 'A'}
        {name:'B',fn:-> console.log 'B'}
        {name:'C',fn:-> console.log 'C'}
      ]
    @addChild @window1

    @window2 = rpg.WindowMenu
      active: true
      cols: 3
      rows: 3
      x: 0
      y: @window1.bottom
      menus: [
        {name:'Menu1',fn:-> console.log '1'}
        {name:'Menu2',fn:-> console.log '2'}
        {name:'Menu3',fn:-> console.log '3'}
        {name:'Menu4',fn:-> console.log '4'}
        {name:'Menu5',fn:-> console.log '5'}
        {name:'Menu6',fn:-> console.log '6'}
        {name:'Menu7',fn:-> console.log '7'}
        {name:'Menu8',fn:-> console.log '8'}
        {name:'Menu9',fn:-> console.log '9'}
        {name:'Item1',fn:-> console.log '1'}
        {name:'Item2',fn:-> console.log '2'}
        {name:'Item3',fn:-> console.log '3'}
        {name:'Item4',fn:-> console.log '4'}
        #{name:'Item5',fn:-> console.log '5'}
        #{name:'Item6',fn:-> console.log '6'}
        #{name:'Item7',fn:-> console.log '7'}
        #{name:'Item8',fn:-> console.log '8'}
      ]
    @addChild @window2

    @window3 = rpg.WindowMenu
      active: true
      cols: 1
      rows: 3
      x: 0
      y: @window2.bottom
      menus: [
        {name:'Menu1',fn:-> console.log '1'}
        {name:'Menu2',fn:-> console.log '2'}
        {name:'Menu3',fn:-> console.log '3'}
        {name:'Menu4',fn:-> console.log '4'}
        {name:'Menu5',fn:-> console.log '5'}
        {name:'Menu6',fn:-> console.log '6'}
        {name:'Menu7',fn:-> console.log '7'}
        {name:'Menu8',fn:-> console.log '8'}
        {name:'Menu9',fn:-> console.log '9'}
        {name:'Item1',fn:-> console.log '1'}
        {name:'Item2',fn:-> console.log '2'}
        {name:'Item3',fn:-> console.log '3'}
        {name:'Item4',fn:-> console.log '4'}
        {name:'Item5',fn:-> console.log '5'}
        {name:'Item6',fn:-> console.log '6'}
        {name:'Item7',fn:-> console.log '7'}
        {name:'Item8',fn:-> console.log '8'}
      ]
    @addChild @window3
