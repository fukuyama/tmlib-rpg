###*
* @file WindowItemActorList.coffee
* アイテム一覧用メンバーリストウィンドウ
###

# アイテム一覧用メンバーリストウィンドウ
tm.define 'rpg.WindowItemActorList',

  superClass: rpg.WindowMemberBase

  ###* コンストラクタ
  * @classdesc アイテム一覧用メンバーリストウィンドウ
  * @constructor rpg.WindowItemActorList
  * @param {Object} args
  ###
  init: (args={}) ->
    @superInit(args.$extend {
      name: 'ItemActorList'
      title: 'どうぐ'
      menus: [
        {name:'ふくろ',fn: -> console.log 'ふくろ'}
      ]
    })
    @x = 16
    @y = 16

    @on 'addWindow', ->
      @window_item = rpg.WindowItemList(
        x: @right
        y: 16
        index: -1
        visible: true
        active: false
      )
      @addWindow(@window_item)
      @changeActor(@actor)
  
  ###* アクターが変更された場合の処理
  * @memberof rpg.WindowItemActorList#
  * @param {rpg.Actor} actor アクター
  ###
  changeActor: (actor) ->
    if @window_item?
      items = []
      if actor?
        actor.backpack.eachItem (item) -> items.push item
      @window_item.setItems(items)
    return

  ###* アクターが選択された場合の処理
  * @memberof rpg.WindowItemActorList#
  * @param {rpg.Actor} actor アクター
  ###
  selectActor: (actor) ->
    if @window_item?.items.length != 0
      # アイテムウィンドウのカーソル位置設定
      @window_item.setIndex 0
      # アイテムウィンドウをアクティブに
      @window_item.active = true
      # 自分は非アクティブに
      @active = false
    return
