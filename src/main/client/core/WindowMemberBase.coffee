
# メンバーリストウィンドウ基本クラス
tm.define 'rpg.WindowMemberBase',
  superClass: rpg.WindowMenu

  # 初期化
  init: (args={}) ->
    @superInit({
      active: false
      visible: false
      cols: 1
      rows: rpg.game.party.length
    }.$extend(args))
    rpg.game.party.each(((a)->
      @addMenu(a.name, @selectActorInternal.bind(@))
    ).bind(@))

  selectActor: (actor) ->
    console.log(actor)

  selectActorInternal: ->
    if @index < rpg.game.party.length
      @selectActor(rpg.game.party.getAt(@index))
