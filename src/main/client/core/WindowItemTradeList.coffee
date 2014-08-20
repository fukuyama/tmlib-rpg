###*
* @file WindowItemTradeList.coffee
* トレードアイテム一覧ウィンドウクラス
###

# トレードアイテム一覧ウィンドウクラス
tm.define 'rpg.WindowItemTradeList',

  superClass: rpg.WindowItemList

  ###* コンストラクタ
  * @classdesc トレードアイテム一覧ウィンドウクラス
  * @constructor rpg.WindowItemTradeList
  * @param {Object} param
  * @param {Array} param.items アイテムインスタンスの配列
  * @param {Array} param.menus 追加メニュー
  ###
  init: (args={}) ->
    @superInit({
      help: off
    }.$extend(args))
    return

  ###* アイテム選択時の処理
  * @memberof rpg.WindowItemTradeList#
  ###
  selectItem: (item) ->
    console.log item
    return
