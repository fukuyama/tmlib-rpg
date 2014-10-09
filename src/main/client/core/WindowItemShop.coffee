###*
* @file WindowItemShop.coffee
* アイテム販売用ウィンドウクラス
###

tm.define 'rpg.WindowItemShop',
  superClass: rpg.WindowItemListBase

  ###* コンストラクタ
  * @classdesc アイテム販売用ウィンドウクラス
  * @constructor rpg.WindowItemShop
  * @param {Object} param
  * @param {Array} param.items アイテムID配列
  * @param {Array} param.weapons 武器ID配列
  * @param {Array} param.armors 防具ID配列
  ###
  init: (param={}) ->
    @superInit {
      active: true
      visible: true
    }.$extend param
    return

  ###* アイテム選択時の処理
  * @memberof rpg.WindowItemShop#
  ###
  selectItem: (item) ->
    console.log item
    rpg.system.temp.log = {
      item:
        name: item.name
        price: item.price
    }
    @close()
    return

  ###* キャンセル時の処理
  * @memberof rpg.WindowItemListBase#
  ###
  cancel: ->
    # 選択解除
    @setIndex -1
    # 自分は非アクティブに
    @active = false
    # クローズ
    @close()
    return
