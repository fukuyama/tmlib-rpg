
# メンバーリストウィンドウ基本クラス
tm.define 'rpg.WindowStatusActorList',
  superClass: rpg.WindowMemberBase

  # 初期化
  init: (args={}) ->
    @superInit(args.$extend {
      title: 'つよさ'
      addMenus: [
        {name:'ぜんいん',fn: -> console.log 'all'}
      ]
    })
    # 初期化時（コンストラクタ）では、まだインスタンス化中で
    # addWindow/addChildができないから開くときに追加する。
    # （perent がまだない）
    @onceOpenListener(@init2.bind(@))
  
  init2: ->
    @info = rpg.WindowStatusInfo(
      x: @right
      y: 16
      parent: @
    )
    @addWindow(@info)
    @info.drawActor(@actor)

  # アクターが変更された場合
  changeActor: (actor) ->
    # 変更されたアクターを描画
    @info.drawActor(@actor) if @info
