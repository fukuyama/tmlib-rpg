###*
* @file Character.coffee
* キャラクタークラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# キャラクターの向き情報
# 文字列は、アニメーション名として利用する
CHARACTER_DIRECTION =
  2: 'down'
  4: 'left'
  6: 'right'
  8: 'up'
CHARACTER_DIRECTION[v] = Math.floor(k) for k,v of CHARACTER_DIRECTION

# 方向を逆にするための定数
REVERSE_DIRECTION = [8,6,4,2]
# x 座標ルートの増減用定数
X_ROUTE = [0,-1,+1,0]
# y 座標ルートの増減用定数
Y_ROUTE = [+1,0,0,-1]

# ランダム移動時の項目
MOVE_RUNDOM = [
  'moveUp'
  'moveDown'
  'moveLeft'
  'moveRight'
]

# キャラクタークラス
class rpg.Character

  ###* コンストラクタ
  * @classdesc キャラクタークラス
  * マップ上に表示するキャラクターのクラス
  * @constructor rpg.Character
  * @param {Object} args
  ###
  constructor: (args={}) ->
    @setup(args)

  ###* セットアップ
  *　@method rpg.Character#setup
  * @param {Object} args 初期化パラメータ
  ###
  setup: (args={}) ->
    {
      @spriteSheet  # スプライト表示で使うシート名
      @x            # スプライトの x 座標 real
      @y            # スプライトの y 座標 real
      direction     # キャラクターの向き
      @mapX         # Mapでの x 座標
      @mapY         # Mapでの y 座標
      @moveX        # 移動中の x 座標 map
      @moveY        # 移動中の y 座標 map
      moveSpeed     # Mapでの移動速度
      moveFrequency # Mapでの移動頻度
      animation     # アニメーション
      @moveRoute      # 移動ルート
      @moveRouteIndex # 移動ルートのインデックス
      @moveRouteForce # 強制移動ルート
      @stopCount
      @lock
      @transparent  # すり抜け
    } = {
      moveRoute: []
      moveRouteIndex: 0
      moveRouteForce: false
      moveSpeed: 4
      moveFrequency: 4
      transparent: false
      stopCount: 0
      lock:
        stopCount: false
      spriteSheet: 'sample.spritesheet'
      x: 0
      y: 0
      direction:
        value: 'down'
        fix: false
      mapX: 0
      mapY: 0
      moveX: 0
      moveY: 0
      animation:
        mode: on  # アニメーションの ON/OFF
        fix: off  # アニメーションの固定 ON/OFF
        move: on  # 移動時のアニメーション ON/OFF
        stop: off # 歩行後のアニメーション ON/OFF
                  # 停止時にアニメーションを続ける場合は ON にする
        'default': '' # デフォルトのアニメーション
    }.$extendAll(args)

    @mapChipSize = 32
    @mapFrameLength = 256.0

    @_moved = false
    @_stopping = 0

    # @moveSpeed の定義
    # frameDistance を計算するために setter を作成する
    frameDistance = 0
    Object.defineProperty @, 'moveSpeed',
      enumerable: true
      get: ->
        moveSpeed
      set: (v) ->
        moveSpeed = v
        frameDistance = Math.pow(2, v) / @mapFrameLength
    Object.defineProperty @, 'frameDistance',
      enumerable: true
      get: ->
        frameDistance
    @moveSpeed = moveSpeed # 初期化
    # @moveFrequency の定義
    # moveFrameFrequency を計算する
    moveFrameFrequency = 0
    Object.defineProperty @, 'moveFrequency',
      enumerable: true
      get: ->
        moveFrequency
      set: (v) ->
        moveFrequency = v
        moveFrameFrequency = (30 - v * 2) * (6 - v)
    Object.defineProperty @, 'moveFrameFrequency',
      enumerable: true
      get: ->
        moveFrameFrequency
    @moveFrequency = moveFrequency
    # @diretion / @directionNum の定義
    # 数値でも文字列でもＯＫにする direction 自体は文字列を保存
    direction.num = CHARACTER_DIRECTION[direction.value]
    _dirSetter = (d) ->
      return if not CHARACTER_DIRECTION[d]?
      return if direction.fix
      d = if typeof d is 'string' then d else CHARACTER_DIRECTION[d]
      direction.value = d
      direction.num = CHARACTER_DIRECTION[d]
    Object.defineProperty @, 'direction',
      enumerable: true
      get: -> direction.value
      set: _dirSetter
    Object.defineProperty @, 'directionNum',
      enumerable: false
      get: -> direction.num
      set: _dirSetter
    Object.defineProperty @, 'directionFix',
      enumerable: true
      get: -> direction.fix
      set: (b) -> direction.fix = b if typeof b is 'boolean'

    # アニメーションプロパティ
    _animAttr = (name, type) ->
      enumerable: true
      get: -> animation[name]
      set: (v) -> animation[name] = v if typeof v is type
    Object.defineProperty @, 'animationMode', _animAttr('mode','boolean')
    Object.defineProperty @, 'animationFix', _animAttr('fix','boolean')
    Object.defineProperty @, 'animationMove', _animAttr('move','boolean')
    Object.defineProperty @, 'animationStop', _animAttr('stop','boolean')
    Object.defineProperty @, 'animationName', {
      enumerable: true
      get: -> animation.name
      set: (v) ->
        if (typeof v is 'string') and (not @isAnimationFix())
          animation.name = v
    }
    Object.defineProperty @, 'animationDefault', _animAttr('default','string')
    animation.name = animation.default

    # 初期位置
    @moveTo(@mapX,@mapY)

  ###* 移動確認
  *　@method rpg.Character#isMove
  * @return {boolean} 移動中の場合 true
  ###
  isMove: -> @moveX != @mapX or @moveY != @mapY

  ###* 移動してたか確認
  *　@method rpg.Character#isMoved
  * @return {boolean} 移動してた場合 true
  ###
  isMoved: -> @_moved

  ###* 停止確認
  *　@method rpg.Character#isStop
  * @return {boolean} 停止の場合 true
  ###
  isStop: -> not @isMove()

  isStopping: -> @_stopping > 1
  
  ###* アニメーション Mode
  *　@method rpg.Character#isAnimation
  * @return {boolean} アニメーション処理をする場合 true
  ###
  isAnimation: -> @animationMode and not @animationFix
  ###* アニメーション Fix
  *　@method rpg.Character#isAnimationFix
  * @return {boolean} アニメーションが固定されている場合 true
  ###
  isAnimationFix: -> @animationFix
  ###* アニメーション Move
  *　@method rpg.Character#isAnimationMove
  * @return {boolean} 移動時にアニメーションする場合 true
  ###
  isAnimationMove: -> @isAnimation() and @animationMove
  ###* アニメーション Stop
  *　@method rpg.Character#isAnimationStop
  * @return {boolean} 停止時にアニメーションする場合 true
  ###
  isAnimationStop: -> @isAnimation() and @animationStop
 
  ###* 更新処理
  *　@method rpg.Character#update
  ###
  update: ->
    @updatePosition()
    # 強制移動の場合
    if @moveRouteForce
      @updateMoveRoute()
      return
    # 強制移動では無く移動ルートが設定されてる場合
    if @moveRoute.length > 0
      @updateDefaultMoveRoute()
      return

  ###* 通常時の移動ルート更新
  *　@method rpg.Character#updateDefaultMoveRoute
  ###
  updateDefaultMoveRoute: ->
    if @stopCount > @moveFrameFrequency
      @updateMoveRoute()
      @stopCount = 0
    @stopCount++ unless @isMove() or @lock.stopCount

  ###* 位置の更新
  *　@method rpg.Character#updatePosition
  ###
  updatePosition: ->
    if @_moved
      @_moved = false
    if @isStop()
      @_stopping += 1
    # アニメーション調整は、スプライト側で行う
    # x 座標計算
    if @moveX != @mapX
      @_stopping = 0
      @moveX += @frameDistance if @moveX < @mapX
      @moveX -= @frameDistance if @moveX > @mapX
      # screen 座標計算
      @x = @_calcScreenX()
      @_moved = true if @isStop()
    # y 座標計算
    if @moveY != @mapY
      @_stopping = 0
      @moveY += @frameDistance if @moveY < @mapY
      @moveY -= @frameDistance if @moveY > @mapY
      # screen 座標計算
      @y = @_calcScreenY()
      @_moved = true if @isStop()

  ###* 移動メソッド実行
  *　@method rpg.Character#applyMoveMethod
  ###
  applyMoveMethod: (name, args=[])->
    console.assert(@[name]?, "move メソッドが見つからない。#{name}")
    @[name].apply(@,args)

  ###* 移動ルートの更新
  *　@method rpg.Character#updateMoveRoute
  ###
  updateMoveRoute: ->
    return if @moveRoute.length == 0 or
      @moveRoute.length <= @moveRouteIndex or
      @isMove()
    route = @moveRoute[@moveRouteIndex++]
    @applyMoveMethod route.name, route.params
    # 移動ルート完了
    if @moveRoute.length == @moveRouteIndex
      @moveRoute.length = 0
      @moveRouteIndex = 0

  ###* 移動ルート強制
  *　@method rpg.Character#forceMoveRoute
  ###
  forceMoveRoute: (moveRoute) ->
    @moveRouteOriginal = @moveRoute unless @moveRouteOriginal?
    @moveRoute = moveRoute
    @moveRouteIndex = 0
    @moveRouteForce = true

  ###* 移動ルート設定
  *　@method rpg.Character#defaultMoveRoute
  ###
  defaultMoveRoute: (moveRoute) ->
    @moveRouteOriginal = moveRoute
    @moveRoute = moveRoute
    @moveRouteIndex = 0

  ###* 移動ルート終了
  *　@method rpg.Character#endMoveRoute
  ###
  endMoveRoute: () ->
    if @moveRouteOriginal?
      @moveRoute = @moveRouteOriginal
    else
      @moveRoute.length = 0
    @moveRouteIndex = 0
    @moveRouteForce = false

  ###* スクリーン座標計算 x
  *　@method rpg.Character#_calcScreenX
  * @private
  ###
  _calcScreenX: () ->
    @moveX * @mapChipSize

  ###* スクリーン座標計算 y
  *　@method rpg.Character#_calcScreenY
  * @private
  ###
  _calcScreenY: () ->
    @moveY * @mapChipSize

  ###* 指定位置への向き変更
  *　@method rpg.Character#directionTo
  ###
  directionTo: (x, y) ->
    return if @directionFix
    if x instanceof rpg.Character
      chara = x
      x = chara.mapX
      y = chara.mapY
    if Math.abs(@mapX - x) < Math.abs(@mapY - y)
      if @mapY < y
        @direction = 'down'
      else
        @direction = 'up'
    else
      if @mapX < x
        @direction = 'right'
      else
        @direction = 'left'

  ###* 指定位置に変更
  *　@method rpg.Character#moveTo
  * @param {number} x マップX座標
  * @param {number} y マップY座標
  ###
  moveTo: (x, y) ->
    @moveX = @mapX = x
    @moveY = @mapY = y
    @x = @_calcScreenX()
    @y = @_calcScreenY()
    true
  ###* 左に移動
  *　@method rpg.Character#moveLeft
  * @param {number} [n=1] 移動歩数
  ###
  moveLeft: (n=1)->
    @direction = 4
    for i in [0...n]
      return unless @isPassable(@mapX,@mapY,4)
      @mapX -= 1
    true
  ###* 右に移動
  *　@method rpg.Character#moveRight
  * @param {number} [n=1] 移動歩数
  ###
  moveRight: (n=1)->
    @direction = 6
    for i in [0...n]
      return unless @isPassable(@mapX,@mapY,6)
      @mapX += 1
    true
  ###* 上に移動
  *　@method rpg.Character#moveUp
  * @param {number} [n=1] 移動歩数
  ###
  moveUp: (n=1)->
    @direction = 8
    for i in [0...n]
      return unless @isPassable(@mapX,@mapY,8)
      @mapY -= 1
    true
  ###* 下に移動
  *　@method rpg.Character#moveDown
  * @param {number} [n=1] 移動歩数
  ###
  moveDown: (n=1)->
    @direction = 2
    for i in [0...n]
      return unless @isPassable(@mapX,@mapY,2)
      @mapY += 1
    true
  ###* 前に移動
  *　@method rpg.Character#moveFront
  * @param {number} [n=1] 移動歩数
  ###
  moveFront: (n=1) ->
    for i in [0...n]
      return unless @isPassable()
      [@mapX,@mapY] = @frontPosition()
    true
  ###* 移動ループ
  *　@method rpg.Character#moveLoop
  ###
  moveLoop: () ->
    @moveRouteIndex = 0
    @updateMoveRoute()
    true
  ###* ランダム移動
  *　@method rpg.Character#moveRundom
  ###
  moveRundom: () ->
    name = MOVE_RUNDOM[Math.floor(Math.random() * MOVE_RUNDOM.length)]
    @applyMoveMethod name
  ###* 向き設定インデックスの計算 2,4,6,8 と言うのを、0,1,2,3 に
  *　@method rpg.Character#directionIndex
  * @param {number} d 向きを表す値 2,4,6,8
  * @return {number} 0-3 のインデックス
  ###
  directionIndex: (d) ->
    d / 2 - 1
  
  ###* 逆向きの計算
  *　@method rpg.Character#reverseDirection
  * @param {number} 向きを表す値 2,4,6,8
  * @return {number} 逆向きの値
  ###
  reverseDirection: (d=@directionNum) ->
    # 向き指定が文字列の場合は、数値に
    d = CHARACTER_DIRECTION[d] if typeof d is 'string'
    # 逆向きの計算
    REVERSE_DIRECTION[@directionIndex(d)]

  ###* 目の前の座標
  *　@method rpg.Character#frontPosition
  * @param {number} [x=this.mapX] マップX座標
  * @param {number} [y=this.mapY]　マップY座標
  * @param {number|String} [d=this.directionNum]　向き
  * @return {Array} 指定された座標の目の前の座標 [x,y]
  ###
  frontPosition: (x=@mapX, y=@mapY, d=@directionNum) ->
    d = CHARACTER_DIRECTION[d] if typeof d is 'string'
    # 向き設定インデックス
    di = @directionIndex(d)
    # 移動先座標の計算
    [x + X_ROUTE[di], y + Y_ROUTE[di]]

  ###* 移動可能判定（指定方向へ移動できるかどうか）
  *　@method rpg.Character#isPassable
  * @param {number} [x=this.mapX] マップX座標
  * @param {number} [y=this.mapY]　マップY座標
  * @param {number|String} [d=this.directionNum]　向き
  * @return {boolean} 移動可能な場合 true
  ###
  isPassable: (x=@mapX, y=@mapY, d=@directionNum) ->
    #　TODO: ななめどしよ
    d = CHARACTER_DIRECTION[d] if typeof d is 'string'
    # 移動先座標の取得
    [nx,ny] = @frontPosition(x, y, d)
    # マップの取得
    map = rpg.system.scene.map
    # マップ範囲チェック
    return false if not map.isValid(nx, ny)
    # すり抜けチェック
    return true if @transparent
    # 自分位置の移動可能チェック
    return false if not map.isPassable(x, y, d, @)
    # 向きを逆に、移動先の可能チェック
    return false if not map.isPassable(nx, ny, @reverseDirection(d))
    true

  ###* 目の前のキャラクターを取得
  *　@method rpg.Character#findFrontCharacter
  * @param {number} [x=this.mapX] マップX座標
  * @param {number} [y=this.mapY]　マップY座標
  * @param {number|String} [d=this.directionNum]　向き
  * @return {rpg.Charactor} 目の前のキャラクター
  ###
  findFrontCharacter: (x=@mapX, y=@mapY, d=@directionNum) ->
    # 目の前の座標
    [nx,ny] = @frontPosition(x,y,d)
    # マップ情報から検索
    rpg.system.scene.map.findCharacter(nx,ny,@)

  ###* キャラクターを取得
  *　@method rpg.Character#findCharacter
  * @param {number} [x=this.mapX] マップX座標
  * @param {number} [y=this.mapY]　マップY座標
  * @return {rpg.Charactor} 見つかったキャラクター
  ###
  findCharacter: (x=@mapX, y=@mapY) ->
    # マップ情報から検索
    rpg.system.scene.map.findCharacter(x,y,@)
