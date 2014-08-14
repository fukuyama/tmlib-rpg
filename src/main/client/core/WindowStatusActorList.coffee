
# ステータス表示用メンバーリストウィンドウ
tm.define 'rpg.WindowStatusActorList',
  superClass: rpg.WindowMemberBase

  # 初期化
  init: (args={}) ->
    parent = args.parent
    @superInit(args.$extend {
      title: 'つよさ'
      menus: [
        {name:'ぜんいん',fn: @allStatus}
      ]
    })
    @x = 16
    @y = 16

    @on 'addWindow', ->
      @addWindow rpg.WindowStatusDetail(parent: @)
      @addWindow rpg.WindowStatusInfo(parent: @)
      @changeActor(@actor)

  # アクターが変更された場合
  changeActor: (actor) ->
    if actor?
      for w in @windows
        if w.changeActor?
          # 変更されたアクターを描画
          w.changeActor(actor)
          w.visible = true
        else
          w.visible = false
    else
      # ぜんいん
      for w in @windows
        if w.changeActor?
          w.visible = false
        else
          w.visible = true
      console.log @menus[@index]

  # ぜんいん
  allStatus: ->
    console.log @
