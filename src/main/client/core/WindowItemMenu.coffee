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

    _menus = []
    _menus.push name:'つかう', fn: @itemUse.bind @
    _menus.push name:'わたす', fn: @itemTrade.bind @
    _menus.push name:'すてる', fn: @itemThrow.bind @
    args.menus = _menus.concat menus
    @superInit({
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
