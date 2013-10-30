
tm.define 'rpg.WindowMapMenu',
  superClass: rpg.WindowMenu

  # 初期化
  init: (args={}) ->
    args.$extend {
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
