
# ステータス表示用メンバーリストウィンドウ
tm.define 'rpg.WindowStatusActorList',
  superClass: rpg.WindowMemberBase

  # 初期化
  init: (args={}) ->
    parent = args.parent
    @superInit(args.$extend {
      title: 'つよさ'
      menus: [
        {name:'ぜんいん',fn: -> console.log 'all'}
      ]
    })
    @x = 16
    @y = 16
    # 初期化時（コンストラクタ）では、まだインスタンス化中で
    # addWindow/addChildができないから開くときに追加する。
    # （perent がまだない）
    @onceOpenListener @init2.bind @
  
  init2: ->
    @addWindow rpg.WindowStatusDetail(parent: @)
    @addWindow rpg.WindowStatusInfo(parent: @)
    @changeActor(@actor)

  # アクターが変更された場合
  changeActor: (actor) ->
    # 変更されたアクターを描画
    for w in @windows
      w.changeActor?(actor)
