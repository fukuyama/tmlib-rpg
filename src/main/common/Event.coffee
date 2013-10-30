# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

TRIGGER_TYPE = {
  TALK: 1
  CHECK: 2
  TOUCH: 3
  AUTO: 4
  PARALLEL: 5
}

ASSETS =
  'sample.event':
    name: ''
    pages: [
      {
        name: 'page1'
        condition: [
        ]
        trigger:
          type: [TRIGGER_TYPE.TALK]
      }
    ]

# イベント
class rpg.Event

  # コンストラクタ
  constructor: (args={}) ->
    @setup(args)

  # 初期化
  setup: (args={}) ->
    {
      @name # イベント名
      pages
    } = {}.$extendAll(ASSETS['sample.event']).$extendAll(args)
    @pages = new rpg.EventPage(page) for page in pages.reverse()
    @checkPage()
  
  checkPage: ->
    for page in @pages
      if page.checkCondition()
        @currentPage = page
        break
    @currentPage

# イベントページ
class rpg.EventPage

  # コンストラクタ
  constructor: (args={}) ->
    @setup(args)
    @_conditionFn = [
      @_checkCondFlag
      @_checkCondFlagValue
    ]

  # 初期化
  setup: (args={}) ->
    {
      @name
      @trigger
      @condition
    } = {}.$extendAll(args)

  # 条件チェック
  checkCondition: () ->
    for cond in @condition
      @_conditionFn[cond.type](cond)
