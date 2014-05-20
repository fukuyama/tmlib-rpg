
# メンバーリストウィンドウ基本クラス
tm.define 'rpg.WindowMemberBase',
  superClass: rpg.WindowMenu

  # 初期化
  init: (args={}) ->
    {
      addMenus
      @actors
    } = {
      addMenus: [] # {name:'name',fn:menuFunc} の配列
      actors: (rpg.game.party.getAt(i) for i in [0 ... rpg.game.party.length])
    }.$extend(args)
    
    selectActorInternal = ->
      if 0 <= @index and @index < @actors.length
        @selectActor @actor

    menus = []
    for a in @actors
      menus.push {
        name: a.name,
        fn: selectActorInternal.bind(@)
      }
    menus = menus.concat addMenus

    @superInit({
      menus: menus
      active: false
      visible: false
      x: 16
      y: 16
      cols: 1
      rows: @actors.length + addMenus.length
      menuWidthFix: 24*5
    }.$extend(args))
  
  change_index: ->
    @changeActor(@actor)

  changeActor: (actor) ->
    console.log(actor)

  selectActor: (actor) ->
    console.log(actor)

rpg.WindowMemberBase.prototype.getter 'actor', -> @actors[@index]
