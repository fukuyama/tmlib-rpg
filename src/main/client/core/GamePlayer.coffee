###*
* @file GamePlayer.coffee
* プレイヤークラス
###

tm.define 'rpg.GamePlayer',

  superClass: tm.app.Element

  ###* コンストラクタ
  * @classdesc プレイヤークラス
  * @constructor rpg.GamePlayer
  ###
  init: () ->
    @superInit()
    @map = '' # マップ名
    @character = new rpg.Character()

    @eventHandler = rpg.EventHandler(active:true,repeatDelay:0)
    @eventHandler.setupHandler(@)

    @eventHandler.addRepeatHandler {
      up: @input_up.bind(@)
      down: @input_down.bind(@)
      left: @input_left.bind(@)
      right: @input_right.bind(@)
    }

  ###* イベントリスナーセットアップ
  * @memberof rpg.GamePlayer#
  * @param {Object} arg k=input key v=callback handlar
  ###
  setupEventListener: (arg) ->
    for k, v of arg
      @clearEventListener(k)
      @addEventListener(k,v)

  ###* 更新
  * @memberof rpg.GamePlayer#
  ###
  update: ->
    @eventHandler.updateInput()

  ###* タッチイベントチェック
  * @memberof rpg.GamePlayer#
  ###
  checkTouched: ->
    # タッチイベントチェック
    if @character.isMoved()
      c = @character.findCharacter()
      if c?.triggerTouched?()
        # 反応がある場合はイベントを実行
        c.start('touched')

  ###* 上入力処理
  * @memberof rpg.GamePlayer#
  ###
  input_up: ->
    if not @character.isMove()
      @character.moveUp()

  ###* 下入力処理
  * @memberof rpg.GamePlayer#
  ###
  input_down: ->
    if not @character.isMove()
      @character.moveDown()

  ###* 左入力処理
  * @memberof rpg.GamePlayer#
  ###
  input_left: ->
    if not @character.isMove()
      @character.moveLeft()

  ###* 右入力処理
  * @memberof rpg.GamePlayer#
  ###
  input_right: ->
    if not @character.isMove()
      @character.moveRight()

  ###* 決定処理
  * @memberof rpg.GamePlayer#
  ###
  input_ok_up: ->
    @dispatchEvent rpg.GamePlayer.EVENT_INPUT_OK

  ###* キャンセル処理
  * @memberof rpg.GamePlayer#
  ###
  input_cancel_up: ->
    @dispatchEvent rpg.GamePlayer.EVENT_INPUT_CANCEL

  ###* はなすイベント処理
  * @memberof rpg.GamePlayer#
  ###
  talk: ->
    # 目の前のキャラクターを探す
    c = @character.findFrontCharacter()
    # TODO: 壁越し判定とかカウンターテーブル判定とかどしよ
    # 目の前にキャラクターがいる場合、話しかけられるなら、話しかける
    if c?.triggerTalk?()
      # プレイヤーの方を向く
      c.directionTo(@character)
      # 反応がある場合はイベントを実行
      c.start('talk')

rpg.GamePlayer.EVENT_INPUT_OK = tm.event.Event "input_ok"
rpg.GamePlayer.EVENT_INPUT_CANCEL = tm.event.Event "input_cancel"

Object.defineProperty rpg.GamePlayer.prototype, 'active',
  enumerable: true
  get: -> @eventHandler.active
  set: (b) -> @eventHandler.active = b if typeof b is 'boolean'
