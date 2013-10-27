
tm.define 'SceneMain',
  superClass: rpg.SceneBase

  # 初期化
  init: ->
    # 親の初期化
    @superInit(name:'SceneMain')

    @characters = [
      new rpg.Character(spriteSheet:'sample.spritesheet.test')
      new rpg.Character()
      new rpg.Character()
      new rpg.Character()
    ]

    @characters[0].moveTo(5,5).direction = 'left'
    @characters[1].moveTo(6,5).direction = 'right'
    @characters[2].moveTo(7,5).direction = 'up'
    @characters[3].moveTo(8,5).direction = 'down'

    @characters[0].moveFrequency = 1
    @characters[0].defaultMoveRoute [
      {name: 'moveUp'}
      {name: 'moveLeft'}
      {name: 'moveDown'}
      {name: 'moveRight'}
      {name: 'moveLoop'}
    ]
    @characters[1].moveFrequency = 2
    @characters[1].defaultMoveRoute [
      {name: 'moveRundom'}
      {name: 'moveLoop'}
    ]
    @characters[2].moveFrequency = 3
    @characters[2].defaultMoveRoute [
      {name: 'moveRundom'}
      {name: 'moveLoop'}
    ]
    @characters[3].moveFrequency = 4
    @characters[3].defaultMoveRoute [
      {name: 'moveRundom'}
      {name: 'moveLoop'}
    ]

    rpg.SpriteCharacter(c).addChildTo(@) for c in @characters

###
    window1 = rpg.Window(100,100,100,100)
    window2 = rpg.WindowMenu
      x: 100
      y: window1.bottom
      menus: [
        {name:'test1', fn:@test1.bind(@)}
        {name:'test2', fn:@test2.bind(@)}
        {name:'test3', fn:@test3.bind(@)}
        {name:'test4', fn:@test4.bind(@)}
        {name:'test5', fn:@test5.bind(@)}
      ]
    @addChild(window1)
    @addChild(window2)
    @win = window2
###


#    @player = rpg.Player(@characters[1])
    
    #window2.refresh()
    #window2.cursor.setIndex(1)
    #window2.resize(100,100)
    #window2.refresh()

#    window1.input_down = (key)->
#      console.log key
#      console.log arguments
#    window1.setupHandler()
#    window2.active = true

#  update: (app) ->
#    @player.update()

###
  test1: ->
    @characters[0].direction = 6
    @characters[0].mapX += 1

  test2: ->
    @characters[0].direction = 4
    @characters[0].mapX -= 1

  test3: ->
    @count = 0 if not @count?
    c = @characters[0]
    if not c.isMove()
      c.moveDown() if @count % 4 == 0
      c.moveLeft() if @count % 4 == 1
      c.moveUp() if @count % 4 == 2
      c.moveRight() if @count % 4 == 3
      @count++
    
  test4: ->
    @win.visible = not @win.visible
    @win.active = not @win.active
    
  test5: ->
    rpg.system.app.replaceScene TitleScene()
###
