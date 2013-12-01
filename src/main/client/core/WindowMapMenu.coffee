
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
    
  menuSkill: ->
    console.log 'skill'
  menuItem: ->
    console.log 'item'
  menuCheck: ->
    console.log 'check'
  menuStatus: ->
    console.log 'status'
    @close()
    rpg.system.scene.interpreter.start [
      {
        type: 'message'
        params: ['TEST']
      },{
        type: 'message'
        params: ['TEST11111111']
      }
    ]
    rpg.system.scene.interpreter.update()
    rpg.system.temp.select = ['Yes','No']
    rpg.system.temp.selectOptions = {}
    rpg.system.temp.selectEndProc = (i) ->
      console.log 'select end = ' + i
  menuOperation: ->
    console.log 'operation'
    @close()
    rpg.system.scene.interpreter.start [
      {
        type: 'message'
        params: ['TEST']
      }
    ]
