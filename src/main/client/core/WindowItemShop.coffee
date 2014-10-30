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
      name: 'ItemShop'
      title: '買う'
      active: true
      visible: true
      rows: 8
    }.$extend param
    @cash = rpg.WindowCash().addChildTo(rpg.system.scene)
    @on 'close', ->
      @cash.close()
      @cash.remove()
      @cash = undefined
    return

  ###* アイテム選択時の処理
  * @memberof rpg.WindowItemShop#
  ###
  selectItem: (item) ->
    type = 'item'
    type = 'weapon' if item instanceof rpg.Weapon
    type = 'armor' if item instanceof rpg.Armor
    rpg.system.temp.log = {
      item:
        index: @index
        type: type
        name: item.name
        url: item.url
        num: 1
        price: item.price
    }
    @close()
    return

  ###* キャンセル時の処理
  * @memberof rpg.WindowItemShop#
  ###
  cancel: ->
    rpg.system.temp.log = {
      item:
        index: -1
    }
    # 選択解除
    @setIndex -1
    # 自分は非アクティブに
    @active = false
    # クローズ
    @close()
    return

  ###* メニューを１つ描画
  * @memberof rpg.WindowItemShop#
  * @param {number} i メニューインデックス(0<=i)
  * @param {number} x 表示範囲　X座標
  * @param {number} y 表示範囲　Y座標
  * @param {number} w 表示範囲　幅
  * @param {number} h 表示範囲　高さ
  ###
  drawMenu: (i,x,y,w,h) ->
    item = @items[i]
    @drawText(item.name, x, y)
    @drawText("#{item.price}", x + w, y , {align:'right'})
