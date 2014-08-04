###*
* @file SceneTitle.coffee
* タイトルシーン
###

ASSETS =
  'sample.scene.title':
    _type: 'json'
    background:
      image: null
      color: 'rgb(0,0,0)'
    menus: [{
        name:'はじめる'
        action: 'NewGame'
        next:
          scene:''
      },{
        name:'つづきから'
        next:
          scene:''
      },{
        name:'おわる'
        next:
          scene:''
      }
    ]

# タイトルシーン
tm.define 'SceneTitle',
  superClass: rpg.SceneBase

  ###* コンストラクタ
  * @classdesc タイトルシーンクラス
  * @constructor SceneTitle
  * @param {Object|String} args 初期化情報
  ###
  init: (args='sample.scene.title') ->
    # 親の初期化
    @superInit(name:'SceneTitle')
    console.log args
    args = tm.asset.AssetManager.get(args).data if typeof args is 'string'
    console.log args
    {
      background
      @menus
    } = {}.$extendAll(ASSETS['sample.scene.title']).$extendAll(args)
    width = rpg.system.screen.width
    height = rpg.system.screen.height
    
    # タイトルバックグラウンドイメージ
    @addBackgroundImage(background)

    # タイトルメニューの作成
    @addTitleMenu()

  ###* ニューゲームアクション
  * @memberof SceneTitle#
  ###
  actionNewGame: ->
    rpg.system.newGame()

  ###* メニュー選択時の処理
  * @memberof SceneTitle#
  ###
  selectMenu: ->
    menu = @menus[@menu_title.index]
    if menu.action
      @['action' + menu.action].apply(@,[])
    if menu.next?
      # シーンを切り替える
      @loadScene menu.next

  ###* タイトルメニューの作成
  * @memberof SceneTitle#
  ###
  addTitleMenu: ->
    menu.fn = @selectMenu.bind(@) for menu in @menus
    @menu_title = rpg.WindowMenu
      menus: @menus
      active: true
      visible: true
      close: false
      rows: @menus.length
    @menu_title.x = rpg.system.screen.width / 2 - @menu_title.width / 2
    @menu_title.y = rpg.system.screen.height / 2
    @addChild(@menu_title)

  ###* タイトルバックグラウンドイメージ
  * @memberof SceneTitle#
  * @param {Object} background バックグラウンドイメージデータ
  * @param {String} background.image イメージのアセット名
  ###
  addBackgroundImage: (background) ->
    if background.image?
      x = 0
      y = 0
      width = rpg.system.screen.width
      height = rpg.system.screen.height
      image = background.image
      if typeof image is 'string'
        image = tm.asset.AssetManager.get(image)
      bg = tm.display.Shape(width,height)
      bg.origin.set(0,0)
      bg.canvas.drawTexture(
        image
        0,0,image.width,image.width
        x,y,width,height
      )
      @addChild bg
