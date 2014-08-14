
# アイテム一覧用メンバーリストウィンドウ
tm.define 'rpg.WindowItemActorList',
  superClass: rpg.WindowMemberBase

  # 初期化
  init: (args={}) ->
    @superInit(args.$extend {
      title: 'だれの？'
      menus: [
        {name:'ふくろ',fn: -> console.log 'ふくろ'}
      ]
    })
    @x = 16
    @y = 16

    @on 'addWindow', ->
      top = @findTopWindow()
      @window_item = rpg.WindowItemList(
        x: @right
        y: top.top
        index: -1
        visible: true
        active: false
      )
      @addWindow(@window_item)
      @changeActor(@actor)
  
  # アクターが変更された場合
  changeActor: (actor) ->
    if @window_item?
      items = []
      if actor?
        actor.backpack.eachItem (item) -> items.push item
      @window_item.setItems(items)

  selectActor: (actor) ->
    @window_item.setIndex 0
    @window_item.active = true
    @active = false
