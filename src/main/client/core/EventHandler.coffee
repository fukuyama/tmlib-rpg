
# イベントで拾うキーの一覧（デフォルト）
DEFAULT_EVENT_KEYS = ['up','down','left','right','enter','escape','c','x']
DEFAULT_EVENT_KEY_ALIAS = [
  {name: 'decision', keys: ['enter','c']}
  {name: 'ok', keys: ['enter','c']}
  {name: 'cancel', keys: ['escape','x']}
]

# イベントハンドラ
tm.define 'rpg.EventHandler',

  # 初期化
  init: (args={}) ->
    {
      inputHandlers
      repeatHandlers
      @eventKeys
      @aliasKeys
      @active
      # カウントで大丈夫かな～？
      @repeatDelay
      @repeatIntarval
    } = {
      inputHandlers: {}
      repeatHandlers: {}
      eventKeys: DEFAULT_EVENT_KEYS
      aliasKeys: DEFAULT_EVENT_KEY_ALIAS
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

  # ハンドラ追加
  addHandler: (dispatcher, key, fn) ->
    if typeof key is 'string'
      dispatcher.addEventListener(key, fn)
    else
      dispatcher.addEventListener(k, f) for k, f of key

  # ハンドラ呼び出し
  callHandler: (dispatcher, key) ->
    if dispatcher.hasEventListener key
      dispatcher.dispatchEvent(tm.event.Event key)

  # ハンドラセットアップ
  # receiver のメソッド名から、自動的にハンドラを設定する
  # ex) input_up() repeat_down() など
  setupHandler: (receiver) ->
    _setupHandler = ((rec,addHandler,prefix) ->
      for key in @eventKeys when typeof rec[prefix + key] is 'function'
        addHandler key, rec[prefix + key].bind(rec)
      for a in @aliasKeys when typeof rec[prefix + a.name] is 'function'
        for key in a.keys
          addHandler key, rec[prefix + a.name].bind(rec)
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
        @callInputHandler key
        @repeatCount = 0

      for key in @eventKeys when kb.getKey(key)
        if @repeatDelay < @repeatCount++
          @callRepeatHandler key
          @repeatCount -= @repeatIntarval
