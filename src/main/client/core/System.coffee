
#
# システムクラス
#
# rpg.system は、ゲーム全体を通して利用するデータを管理
# rpg.game は、１つのゲームのデータを管理
#

# システムデータとして先読みする場合の data asset
# rpg.System.assets でアクセス
# （coffee スクリプトだとこの書き方ではグローバルにならないのでこのままでＯＫ。
#  上書きされない コンパイルオプションで bare: false の場合…）
ASSETS =
  system:
    type: 'json'
    src:
      title: 'tmlib-rpg'
      assets: {}
      main:
        scene: 'SceneTitle'
        key: 'scene.title'
        src: {}
      canvasId: 'game_screen'
      loadingSceneDefault:
        gauge:
          x: 0
          y: 0
          width: 640
          height: 10
          color: 'blue'
          direction: 'left'
      windowDefault:
        windowskin: {} # WindowSkin クラスのデフォルトを使う
        textColor: 'rgb(255,255,255)'
        alpha: 0.9
        cursor:
          color: 'rgba(255,255,255,0.2)'
          borderColor: 'rgba(255,255,255,1.0)'
      textColor: 'rgb(255,255,255)'
      lineHeight: 32
      mapChipSize: 32
      'screen':
        width: 640
        height: 480
        background: 'rgb(0,0,0)'
      se: # ここのデフォルトのキー名をメソッド名に使う
        menu_decision: 'system.se.menu_decision'
        menu_cancel: 'system.se.menu_cancel'
        menu_cursor_move: 'system.se.menu_cursor_move'

# システムデータクラス
# rpg.system がインスタンス
tm.define 'rpg.System',

  # 初期化
  init: (args = 'system') ->
    args = tm.asset.AssetManager.get(args).data if typeof args == 'string'
    {
      @title
      @assets
      @main
      @canvasId
      @loadingSceneDefault
      @windowDefault
      @textColor
      @lineHeight
      @screen
      @se
      @mapChipSize
    } = {
    }.$extendAll(ASSETS.system.src).$extendAll(args)
    @clearTemp()
    @player = rpg.GamePlayer()

    # Audio 関連のメソッド作成
    # menu_decision -> rpg.system.se.menuDecision()
    # menu_cursor_move -> rpg.system.se.menuCursorMove()
    for k, v of ASSETS.system.src.se
      names = k.split '_'
      nm = names[0]
      nm += t.charAt(0).toUpperCase() + t.slice(1) for t in names[1..]
      @se[nm] = @playSe.bind(@, @se[k])

    # カレントシーンの取得
    Object.defineProperty @, 'scene',
      get: -> @app.currentScene

  # テスト実行
  runMocha: ->
    console.log '* mocha mode *'
    # アプリケーション作成
    app = @app = tm.display.CanvasApp '#' + @canvasId

    # リサイズ
    app.resize @screen.width, @screen.height

    # 自動フィット
    app.fitDebugWindow = ->
      _fitFunc = (->
        e = @element
        s = e.style
        
        s.position = 'fixed'
        s.margin = '0'
        s.top  = '55px'
        s.right = '10px'
        s.zIndex = 10

        rateWidth = e.width / window.innerWidth
        rateHeight= e.height / window.innerHeight
        rate = e.height / e.width

        if (rateWidth > rateHeight)
          s.width  = innerWidth / 2 + 'px'
          s.height = innerWidth / 2 * rate + 'px'
        else
          s.width  = innerHeight / 2 / rate + 'px'
          s.height = innerHeight / 2 + 'px'
      ).bind(@)

      # 一度実行しておく
      _fitFunc()
      # リサイズ時のリスナとして登録しておく
      window.addEventListener('resize', _fitFunc, false)

    app.fitDebugWindow()
    
    # APバックグラウンド
    app.background = @screen.background

    sceneMain = {}.$extendAll(@main)
    # 最初のシーンに切り替える
    @loadScene sceneMain

    # 実行
    app.run()

    # mocha 実行
    rpg.mocha_run()

  # 通常実行
  runNomal: ->
    # アプリケーション作成
    app = @app = tm.display.CanvasApp '#' + @canvasId

    # リサイズ
    app.resize @screen.width, @screen.height

    # 自動フィット
    app.fitWindow()

    # APバックグラウンド
    app.background = @screen.background

    sceneMain = {}.$extendAll(@main)
    # 最初のシーンに切り替える
    @loadScene sceneMain

    # 実行
    app.run()

  # 実行
  run: ->
    # キャンバス確認
    unless document.querySelector('#' + @canvasId)?
      console.log 'アプリケーション なし'
      return
    if rpg.mocha
      @runMocha()
    else
      @runNomal()

  # Assetロード
  loadAsset: (assets) ->
    @loadScene
      scene: rpg.system.scene
      assets: assets
  
  # シーンロード
  loadScene: (args={}) ->
    args = {}.$extend(@loadingSceneDefault).$extend(args)
    rpg.system.app.replaceScene SceneLoading(args)

  # シーン変更
  replaceScene: (args={}) ->
    {
      scene
      param
    } = args
    if typeof scene is 'string'
      scene = tm.global[scene]
    if typeof scene is 'function'
      scene = scene(param)
    rpg.system.app.replaceScene scene

  # SEの演奏
  playSe: (name) ->
    if tm.asset.AssetManager.contains name
      audio = tm.asset.AssetManager.get(name)
      audio.play()
      audio.stop(1)
   
  clearTemp: ->
    @temp = {
      message: null
      messageEndProc: null
      select: null
      selectOptions: null
      selectEndProc: null
    }

  # 新しいゲームを開始
  newGame: () ->
    @clearTemp()
    game = rpg.game = {}
    game.flag = new rpg.Flag()
    # TODO: プレイヤーキャラクターとりあえず版
    o = tm.asset.AssetManager.get('sample.character.test')
    game.pc = new rpg.Character(o)
    game.pc.moveSpeed = 6
    
    # パーティ編成
    game.party = new rpg.Party()
    
    # TODO: アクターデータ
    game.actors = []
    
    # DUMMY
    a = new rpg.Actor(name: 'ああああ')
    game.party.add(a)
    game.actors.push a
    a = new rpg.Actor(name: 'あああい')
    game.party.add(a)
    game.actors.push a
