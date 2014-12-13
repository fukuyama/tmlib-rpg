
# マップメニュー
tm.define 'rpg.WindowMapMenu',
  superClass: rpg.WindowMenu

  # 初期化
  init: (args={}) ->
    args.$extend {
      name:'MapMenu'
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
    @on 'open', ->
      @cash = rpg.WindowCash()
      @addWindow @cash
    @on 'close', ->
      @removeWindow @cash
  update: ->
    rpg.Window.prototype.update.call @
    @cash?.visible = @visible

  _next: (w) ->
    @addWindow w
    @active = false
    @visible = false
  
  menuTalk: ->
    @close()
    rpg.game.player.talk()
    return
  menuSkill: ->
    self = @
    eg = rpg.EventGenerator()
    eg.message 'Skill'
    eg.function -> self.active = true
    interpreter = rpg.system.mapInterpreter
    interpreter.start eg.commands
    @active = false
    return
  menuItem: ->
    @_next rpg.WindowItemActorList parent: @
    return
  menuCheck: ->
    rpg.game.player.checkEvent()
    @close()
    return
  menuStatus: ->
    @_next rpg.WindowStatusActorList parent: @
    return
  menuOperation: ->
    @_next rpg.WindowOperation parent: @
    return
