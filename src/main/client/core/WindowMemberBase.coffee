
# メンバーリストウィンドウ基本クラス
tm.define 'rpg.WindowMemberBase',
  superClass: rpg.WindowMenu

  # 初期化
  init: (args={}) ->
    {
      menus
      @actors
    } = {
      menus: [] # {name:'name',fn:menuFunc} の配列
      actors: (rpg.game.party.getAt(i) for i in [0 ... rpg.game.party.length])
    }.$extend(args)
    
    _menus = []
    _selectActorInternal = (->
      if 0 <= @index and @index < @actors.length
        @selectActor @actor
    ).bind @
    for a in @actors
      _menus.push {
        name: a.name,
        fn: _selectActorInternal
      }
    _selectActorInternal = null
    args.menus = _menus.concat menus

    @superInit({
      menus: _menus
      active: true
      visible: true
      x: 16
      y: 16
      cols: 1
      rows: @actors.length + menus.length
      menuWidthFix: 24*5
    }.$extend(args))
  
  change_index: ->
    @changeActor(@actor)

  changeActor: (actor) ->
    console.log(actor)

  selectActor: (actor) ->
    console.log(actor)

rpg.WindowMemberBase.prototype.getter 'actor', -> @actors[@index]
