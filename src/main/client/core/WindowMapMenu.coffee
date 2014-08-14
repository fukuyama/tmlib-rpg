
# マップメニュー
tm.define 'rpg.WindowMapMenu',
  superClass: rpg.WindowMenu

  # 初期化
  init: (args={}) ->
    args.$extend {
      active: false
      visible: false
      x: 16
      y: 16
      cols: 2
      rows: 3
      menus: [
        {name:'はなす',fn:@menuTalk.bind(@)}
        {name:'じゅもん',fn:@menuSkill.bind(@)}
        {name:'どうぐ',fn:@menuItem.bind(@)}
        {name:'しらべる',fn:@menuCheck.bind(@)}
        {name:'つよさ',fn:@menuStatus.bind(@)}
        {name:'さくせん',fn:@menuOperation.bind(@)}
      ]
    }
    @superInit(args)
  
  menuTalk: ->
    @close()
    rpg.system.player.talk()
    @
  menuSkill: ->
    console.log 'skill'
    @
  menuItem: ->
    @addWindow rpg.WindowItemActorList parent: @
    @active = false
    @visible = false
    @
  menuCheck: ->
    console.log 'check'
    @
  menuStatus: ->
    @addWindow rpg.WindowStatusActorList parent: @
    @active = false
    @visible = false
    @
  menuOperation: ->
    @addWindow rpg.WindowOperation parent: @
    @active = false
    @visible = false
    @
