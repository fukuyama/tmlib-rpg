
# アイテム一覧用メンバーリストウィンドウ
tm.define 'rpg.WindowItemActorList',
  superClass: rpg.WindowMemberBase

  # 初期化
  init: (args={}) ->
    @superInit(args.$extend {
      title: 'だれの？'
      addMenus: [
        {name:'ふくろ',fn: -> console.log 'ふくろ'}
      ]
    })
    # 初期化時（コンストラクタ）では、まだインスタンス化中で
    # addWindow/addChildができないから開くときに追加する。
    # （perent がまだない）
    @onceOpenListener(@createItemWindow.bind(@))
  
  createItemWindow: ->
    top = @findTopWindow()
    items = []
    @window_item = rpg.WindowItemList(
      parent: @
      x: @.right
      y: top.top
      index: -1
    ).onceOpenListener((->
      @changeActor(@actor)
    ).bind(@)).open()
    @addWindow(@window_item)
    @

  # アクターが変更された場合
  changeActor: (actor) ->
    if @window_item?
      items = []
      if actor?
        actor.backpack.eachItem (item) ->
          items.push item
      @window_item.setItems(items)
