# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

TRIGGER_TYPE = {
  TALK: 'talk'
  CHECK: 'check'
  TOUCH: 'touch'
  TOUCHED: 'touched'
  AUTO: 'auto'
  PARALLEL: 'parallel'
}

ASSETS =
  'sample.event':
    type: 'json'
    src:
      name: ''
      pages: [
        {
          name: 'page1'
          condition: [
          ]
          trigger: [
            'talk'
          ]
          commands: [
            {
              type:'message'
              params:[
                'TEST'
              ]
            }
          ]
        }
      ]

# イベント
class rpg.Event extends rpg.Character

  # コンストラクタ
  constructor: (args={}) ->
    super args

  # 初期化
  setup: (args={}) ->
    {
      @name # イベント名
      pages
    } = {}.$extendAll(ASSETS['sample.event'].src).$extendAll(args)
    @pages = (new rpg.EventPage(page) for page in pages.reverse())
    @checkPage()

  # 現在のページを確認
  checkPage: ->
    @currentPage = @pages[0]
    for page in @pages
      if page.checkCondition()
        @currentPage = page
        break
    @currentPage
