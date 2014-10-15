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
  * @param {string} param.title ウィンドウタイトル（defult:買う）
  * @param {Array} param.items アイテムID配列
  * @param {Array} param.weapons 武器ID配列
  * @param {Array} param.armors 防具ID配列
  ###
  init: (param={}) ->
    @superInit {
      title: '買う'
      active: true
      visible: true
      rows: 8
    }.$extend param
    return

  ###* アイテム選択時の処理
  * @memberof rpg.WindowItemShop#
  ###
  selectItem: (item) ->
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

  # メニューを１つ描画
  drawMenu: (i,x,y,w,h) ->
    item = @items[i]
    @drawText(item.name, x, y)
    @drawText("#{item.price}", x + w, y , {align:'right'})
