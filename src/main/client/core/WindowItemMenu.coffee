###*
* @file WindowItemMenu.coffee
* アイテムメニュー
###

tm.define 'rpg.WindowItemMenu',

  superClass: rpg.WindowMenu

  ###* コンストラクタ
  * @classdesc アイテムメニュークラス
  * @constructor rpg.WindowItemMenu
  * @param {Object} args
  ###
  init: (args={}) ->
    {
      menus
    } = {
      menus: []
    }.$extend(args)

    m = []
    m.push name:'つかう', fn: @itemUse.bind @
    m.push name:'わたす', fn: @itemTrade.bind @
    m.push name:'すてる', fn: @itemThrow.bind @
    args.menus = m.concat menus
    @superInit({
      title: 'どうする？'
      active: false
      visible: false
      x: 16
      y: 16
      cols: 1
      rows: args.menus.length
    }.$extend(args))

  itemUse: ->
    return

  itemTrade: ->
    return

  itemThrow: ->
    return
