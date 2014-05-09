
# メイン処理(ページ読み込み後に実行される)
tm.main ->
  loader = tm.asset.Loader()
  # 初期ロード処理
  load = ->
    #loader.removeEventListener('load', load)

    # システムオブジェクト
    rpg.system = rpg.System()

    # 実行
    rpg.system.run()

  loader.addEventListener('load', load)
  
  # システム情報のAssetを読み込み
  assets = {}.$extend(SYSTEM_ASSETS)
  loader.load assets
  # rpg.System の初期化に必要な情報と
  # ロードシーンに必要な素材とか
