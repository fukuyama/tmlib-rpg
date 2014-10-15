# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

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
    super args
    {
      @name # イベント名
      pages
    } = {
      name: null
    }.$extendAll(ASSETS['sample.event'].src).$extendAll(args)
    @pages = (new rpg.EventPage(page) for page in pages.reverse())
    @checkPage()

    # trigger メソッド作成
    for k, v of rpg.EventPage.TRIGGER_TYPE
      f = 'trigger' + v.charAt(0).toUpperCase() + v.slice(1)
      @[f] = ((m) -> @currentPage[m]()).bind(@,f)

    # getter メソッド作成
    Object.defineProperty @, 'commands',
      enumerable: true
      get: -> @currentPage.commands

  # 現在のページを確認
  checkPage: ->
    @currentPage = @pages[0]
    for page in @pages when page.checkCondition()
      @currentPage = page
      break
    @currentPage

  # イベント開始
  start: (@trigger) ->
    unless rpg.system.mapInterpreter.isRunning()
      @lock.stopCount = true
      rpg.system.mapInterpreter.start @

  # イベント終了
  end: ->
    @trigger = null
    @lock.stopCount = false
