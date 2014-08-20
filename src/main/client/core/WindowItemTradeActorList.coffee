###*
* @file WindowItemTradeActorList.coffee
* トレードアイテム一覧用メンバーリストウィンドウ
###

# トレードアイテム一覧用メンバーリストウィンドウ
tm.define 'rpg.WindowItemTradeActorList',

  superClass: rpg.WindowMemberBase

  ###* コンストラクタ
  * @classdesc トレードアイテム一覧用メンバーリストウィンドウ
  * @constructor rpg.WindowItemTradeActorList
  * @param {Object} args
  ###
  init: (args={}) ->
    @superInit(args.$extend {
      title: 'だれに？'
      menus: [
        {name:'ふくろ',fn: -> console.log 'ふくろ'}
      ]
    })
    parent = args.parent
    @x = parent.right
    @y = 16

    @on 'addWindow', ->
      @window_item = rpg.WindowItemTradeList(
        x: @right
        y: 16
        index: -1
        visible: true
        active: false
      )
      @addWindow(@window_item)
      @changeActor(@actor)
  
  ###* アクターが変更された場合の処理
  * @memberof rpg.WindowItemTradeActorList#
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
  * @memberof rpg.WindowItemTradeActorList#
  * @param {rpg.Actor} actor アクター
  ###
  selectActor: (actor) ->
    # アイテムウィンドウのカーソル位置設定
    @window_item.setIndex 0
    # アイテムウィンドウをアクティブに
    @window_item.active = true
    # 自分は非アクティブに
    @active = false
    return
