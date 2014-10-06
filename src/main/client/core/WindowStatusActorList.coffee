###*
* @file WindowStatusActorList.coffee
* ステータス表示用メンバーリストウィンドウ
###

tm.define 'rpg.WindowStatusActorList',
  superClass: rpg.WindowMemberBase

  ###* コンストラクタ
  * @classdesc ステータス表示用メンバーリストウィンドウ
  * @constructor rpg.DataBase
  * @param {Object} args
  * @param {rpg.Window} args.parent 親ウィンドウ
  ###
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
      @addWindow rpg.WindowStatusEquip(parent: @)
      @changeActor(@actor)

  ###* アクターが選択された場合
  * @memberof rpg.WindowStatusActorList#
  * @param {rpg.Actor} actor 選択されたアクター
  ###
  selectActor: (actor) ->
    if actor?
      for w in @windows when w.selectActor?
        # 選択されたアクターを描画
        w.selectActor(actor)

  ###* アクターが変更された場合
  * @memberof rpg.WindowStatusActorList#
  * @param {rpg.Actor} actor 変更されたアクター
  ###
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
