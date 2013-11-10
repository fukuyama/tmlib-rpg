
# システムデータとして先読みする場合の data asset
# rpg.System.assets でアクセス
# （coffee スクリプトだとこの書き方ではグローバルにならないのでこのままでＯＫ。
#  上書きされない コンパイルオプションで bare: false の場合…）
ASSETS =
  system:
    type: 'json'
    src:
      title: 'tmlib-rpg'
      assets: [
      ]
      main:
        scene: 'SceneTitle'
        param: 'scene.title'
        assets: []
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
      @temp
    } = {
      temp: {}
    }.$extendAll(ASSETS.system.src).$extendAll(args)

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

  run: ->
    # アプリケーション作成
    app = @app = tm.display.CanvasApp '#' + @canvasId

    # リサイズ
    app.resize @screen.width, @screen.height

    # 自動フィット
    app.fitWindow()

    # APバックグラウンド
    app.background = @screen.background

    sceneMain = {}.$extendAll(@main)
    sceneMain.assets = @assets.concat sceneMain.assets
    # 最初のシーンに切り替える
    @loadScene sceneMain

    # 実行
    app.run()
  
  loadScene: (args={}) ->
    args = {}.$extend(@loadingSceneDefault).$extend(args)
    rpg.system.app.replaceScene SceneLoading(args)

  replaceScene: (args={}) ->
    {
      scene
      param
    } = args
    scene = tm.global[scene] if typeof scene is 'string'
    rpg.system.app.replaceScene scene(param)

  playSe: (name) ->
    if tm.asset.AssetManager.contains name
      audio = tm.asset.AssetManager.get(name)
      audio.play()
      audio.stop(1)
