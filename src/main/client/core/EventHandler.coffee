###*
* @file EventHandler.coffee
* イベントハンドラ
###

# イベントで拾うキーの一覧（デフォルト）
DEFAULT_EVENT_KEYS = ['up','down','left','right','enter','escape','c','x']
DEFAULT_EVENT_KEY_ALIAS = [
  {name: 'decision', keys: ['enter','c']}
  {name: 'ok', keys: ['enter','c']}
  {name: 'cancel', keys: ['escape','x']}
]

DEFAULT_EVENT_UPKEYS = ['enter','escape','c','x']
DEFAULT_EVENT_UPKEY_ALIAS = [
  {name: 'decision', keys: ['enter','c']}
  {name: 'ok', keys: ['enter','c']}
  {name: 'cancel', keys: ['escape','x']}
]

tm.input.Keyboard.prototype.clear = ->
  @press  = {}
  @down   = {}
  @up     = {}
  @last   = {}

# イベントハンドラ
tm.define 'rpg.EventHandler',

  # 初期化
  init: (args={}) ->
    {
      @name
      inputHandlers
      repeatHandlers
      @eventKeys
      @aliasKeys
      @eventUpKeys
      @aliasUpKeys
      @active
      # カウントで大丈夫かな～？
      @repeatDelay
      @repeatIntarval
    } = {
      inputHandlers: {}
      repeatHandlers: {}
      eventKeys: DEFAULT_EVENT_KEYS
      aliasKeys: DEFAULT_EVENT_KEY_ALIAS
      eventUpKeys: DEFAULT_EVENT_UPKEYS
      aliasUpKeys: DEFAULT_EVENT_UPKEY_ALIAS
      active: false
      repeatDelay: 10
      repeatIntarval: 0
    }.$extend args
    @repeatCount = 0

    # メソッド作成
    @create 'Input'
    @create 'Repeat'

    # init で渡されたハンドラの設定
    @addInputHandler(inputHandlers)
    @addRepeatHandler(repeatHandlers)

  # ハンドラーメソッドの作成
  create: (name) ->
    dispatcher = tm.event.EventDispatcher()
    @["add#{name}Handler"] = @addHandler.bind(@, dispatcher)
    @["call#{name}Handler"] = @callHandler.bind(@, dispatcher)
    @["remove#{name}Handler"] = @removeHandler.bind(@, dispatcher)
    @["clear#{name}Handler"] = @clearHandler.bind(@, dispatcher)

  # ハンドラ追加
  addHandler: (dispatcher, key, fn) ->
    if typeof key is 'object'
      dispatcher.addEventListener(k, f) for k, f of key
    else
      dispatcher.addEventListener(key, fn)

  # ハンドラ呼び出し
  callHandler: (dispatcher, key) ->
    if dispatcher.hasEventListener key
      dispatcher.dispatchEvent(tm.event.Event key)

  # ハンドラ削除
  removeHandler: (dispatcher, key, fn) ->
    if typeof key is 'string'
      dispatcher.removeEventListener(key, fn)
    else
      dispatcher.removeEventListener(k, f) for k, f of key

  # ハンドラ全削除
  clearHandler: (dispatcher, key) ->
    dispatcher.clearEventListener(key)

  # ハンドラセットアップ
  # receiver のメソッド名から、自動的にハンドラを設定する
  # ex) input_up() repeat_down() など
  setupHandler: (receiver) ->
    _setupHandler = ((rec,addHandler,prefix) ->
      _isFunc = (k) -> typeof rec[prefix + k] is 'function'
      for key in @eventKeys when _isFunc key
        addHandler key, rec[prefix + key].bind(rec)
      for a in @aliasKeys when _isFunc a.name
        for key in a.keys
          addHandler key, rec[prefix + a.name].bind(rec)
      for key in @eventUpKeys when _isFunc(key + '_up')
        addHandler key + '_up', rec[prefix + key + '_up'].bind(rec)
      for a in @aliasUpKeys when _isFunc(a.name + '_up')
        for key in a.keys
          addHandler key + '_up', rec[prefix + a.name + '_up'].bind(rec)
      ).bind(@, receiver)
    _setupHandler @addInputHandler, 'input_'
    _setupHandler @addRepeatHandler, 'repeat_'

  # 入力の更新処理
  #　必要な場合に毎回呼んでもらう。
  # ただ、１フレーム(1 update loop)で１回の呼び出しが良いと思う。（@active == true なものが１回）
  updateInput: ->
    if @active
      kb = rpg.system.app.keyboard
      for key in @eventKeys when kb.getKeyDown(key)
        @repeatCount = 0
        @callInputHandler key

      for key in @eventKeys when kb.getKey(key)
        if @repeatDelay < @repeatCount++
          @callRepeatHandler key
          @repeatCount -= @repeatIntarval

      for key in @eventUpKeys when kb.getKeyUp(key)
        @repeatCount = 0
        @callInputHandler key + '_up'
