
# メイン処理(ページ読み込み後に実行される)
tm.main ->
  loader = tm.asset.Loader()
  ###
  loader.on 'progress', -> console.log 'progress'
  loader.on 'load', -> console.log 'load'
  loader.load
    'windowskin.image': 'img/test_windowskin.png'
    'system.se.menu_decision': 'audio/se/fin.mp3'
    'system.se.menu_cursor_move': 'audio/se/fon.mp3'
  ###

  load = (assets,func) ->
    loader.one('load', func)
    loader.load assets

  # 初期処理
  init = ->
    # システムオブジェクト
    rpg.system = rpg.System()
    # ユーザ定義アセットロード
    load(rpg.system.assets, run)

  # ゲーム開始
  run = ->
    # 実行
    rpg.system.run()
  
  # システム定義アセットロード
  load(SYSTEM_ASSETS, init)
