###*
* @file WindowItemList.coffee
* アイテム一覧ウィンドウクラス
###

# アイテム一覧ウィンドウクラス
tm.define 'rpg.WindowItemList',
  superClass: rpg.WindowItemListBase

  ###* コンストラクタ
  * @classdesc アイテム一覧ウィンドウクラス
  * @constructor rpg.WindowItemList
  * @param {Object} param
  * @param {Array} param.items アイテムインスタンスの配列
  * @param {Array} param.menus 追加メニュー
  ###
  init: (args={}) ->
    args.name = 'ItemList'
    @superInit(args)
    return

  ###* アイテム選択時の処理
  * @memberof rpg.WindowItemList#
  ###
  selectItem: (item) ->
    # アイテムメニューを表示する
    @addWindow rpg.WindowItemMenu(parent:@)
    # 自分は非アクティブに
    @active = false
    return
