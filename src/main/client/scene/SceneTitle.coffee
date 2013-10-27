
ASSETS =
  'sample.scene.title':
    _type: 'json'
    background:
      image: null
      color: 'rgb(0,0,0)'
    menus: [{
        name:'はじめる'
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

  # 初期化
  init: (args='sample.scene.title') ->
    # 親の初期化
    @superInit(name:'SceneTitle')
    args = tm.asset.AssetManager.get(args) if typeof args is 'string'
    {
      background
      @menus
    } = {}.$extendAll(ASSETS['sample.scene.title']).$extendAll(args)
    width = rpg.system.screen.width
    height = rpg.system.screen.height
    
    # タイトルバックグラウンドイメージ
    if background.image?
      image = background.image
      if typeof image is 'string'
        image = tm.asset.AssetManager.get(image)
      bg = tm.app.Shape(width,height)
      bg.origin.set(0,0)
      bg.canvas.drawTexture(
        image
        0,0,image.width,image.width
        0,0,width,height
      )
      @addChild bg

    # タイトルメニューの作成
    menu.fn = @selectMenu.bind(@) for menu in @menus
    @menu_title = rpg.WindowMenu
      menus: @menus
      active: true
    @menu_title.x = width / 2 - @menu_title.width / 2
    @menu_title.y = height / 2
    @addChild(@menu_title)

  selectMenu: ->
    menu = @menus[@menu_title.index]
    if menu.next? and menu.next.scene != ''
      console.log menu.next
      # シーンを切り替える
      @loadScene menu.next
