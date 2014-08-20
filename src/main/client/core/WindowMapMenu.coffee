
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

  _next: (w) ->
    @addWindow w
    @active = false
    @visible = false
  
  menuTalk: ->
    rpg.system.player.talk()
    @close()
  menuSkill: ->
    console.log 'skill'
    @
  menuItem: ->
    @_next rpg.WindowItemActorList parent: @
  menuCheck: ->
    rpg.system.player.checkEvent()
    @close()
  menuStatus: ->
    @_next rpg.WindowStatusActorList parent: @
  menuOperation: ->
    @_next rpg.WindowOperation parent: @
