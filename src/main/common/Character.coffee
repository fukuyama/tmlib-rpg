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
CHARACTER_DIRECTION[v] = k | 0 for k,v of CHARACTER_DIRECTION

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

ASSETS =
  'sample.character':
    type: 'json'
    src:
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
      moveSpeed: 4
      moveFrequency: 4
      animation:
        mode: on  # アニメーションの ON/OFF
        fix: off  # アニメーションの固定 ON/OFF
        move: on  # 移動時のアニメーション ON/OFF
        stop: on  # 歩行後のアニメーションの停止 ON/OFF
                  # 停止時にアニメーションを続ける場合は OFF にする
        'default': '' # デフォルトのアニメーション
  'sample.spritesheet.hiyoko': 'img/hiyoco_nomal_full.png'
  'sample.spritesheet':
    type: 'tmss'
    src:
      image: 'sample.spritesheet.hiyoko'
      frame:
        width: 32
        height: 32
        count: 18
      animations:
        down: frames: [7,6,7,8], next: 'down', frequency: 4
        up: frames: [10,9,10,11], next: 'up', frequency: 4
        left: frames: [13,12,13,14], next: 'left', frequency: 4
        right: frames: [16,15,16,17], next: 'right', frequency: 4

@SAMPLE_SYSTEM_LOAD_ASSETS = @SAMPLE_SYSTEM_LOAD_ASSETS ? []
@SAMPLE_SYSTEM_LOAD_ASSETS.push ASSETS

# キャラクタークラス
#
#　ゲーム内に現れるキャラクターデータのクラス（アクターとエネミーの基底クラス）
#　各キャラクター（アクターとエネミー含む）の基本的な能力を提供する。
#
#　ゲーム初期状態でのデータは、json で管理（読み込みは外部で…）
#　このクラスは、ゲーム内で使用する実際のインスタンスとして使用する。
#
class rpg.Character

  constructor: (args={}) ->
    @setup(args)

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
      @moveRouteForce
      @stopCount
    } = {
      moveRoute: []
      moveRouteIndex: 0
      moveRouteForce: false
      stopCount: 0
    }.$extendAll(ASSETS['sample.character'].src).$extendAll(args)

    @mapChipSize = 32
    @mapFrameLength = 256.0

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

  # 移動確認
  isMove: -> @moveX != @mapX or @moveY != @mapY

  # 停止確認
  isStop: -> not @isMove()
  
  # アニメーション Mode
  isAnimation: -> @animationMode and not @animationFix
  # アニメーション Fix
  isAnimationFix: -> @animationFix
  # アニメーション Move
  isAnimationMove: -> @isAnimation() and @animationMove
  # アニメーション Stop
  isAnimationStop: -> @isAnimation() and @animationStop
 
  # 更新処理
  update: ->
    @updatePosition()
    if @moveRouteForce
      @updateMoveRoute()
    if @stopCount > @moveFrameFrequency
      @updateMoveRoute()
      @stopCount = 0

    @stopCount++ if not @isMove()

  # 位置の更新
  updatePosition: ->
    # 停止時アニメーション調整
    if @isAnimationStop() and @animationName != '' and
    @moveX == @mapX and @moveY == @mapY
      @animationName = ''
    # x 座標計算
    if @moveX != @mapX
      @moveX += @frameDistance if @moveX < @mapX
      @moveX -= @frameDistance if @moveX > @mapX
      # screen 座標計算
      @x = @_calcScreenX()
      # 歩行アニメーション調整
      if @moveX != @mapX and @isAnimationMove()
        @animationName = @direction if @animationName != @direction
    # y 座標計算
    if @moveY != @mapY
      @moveY += @frameDistance if @moveY < @mapY
      @moveY -= @frameDistance if @moveY > @mapY
      # screen 座標計算
      @y = @_calcScreenY()
      # 歩行アニメーション調整
      if @moveY != @mapY and @isAnimationMove()
        @animationName = @direction if @animationName != @direction

  # 移動メソッド実行
  applyMoveMethod: (name, args=[])->
    console.assert(@[name]?, "move メソッドが見つからない。#{name}")
    @[name].apply(@,args)

  # 移動ルートの更新
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

  # 移動ルート強制
  forceMoveRoute: (moveRoute) ->
    @moveRoute = moveRoute
    @moveRouteIndex = 0
    @moveRouteForce = true

  # 移動ルート設定
  defaultMoveRoute: (moveRoute) ->
    @moveRoute = moveRoute
    @moveRouteIndex = 0

  # スクリーン座標計算 x
  _calcScreenX: () ->
    @moveX * @mapChipSize
  # スクリーン座標計算 y
  _calcScreenY: () ->
    @moveY * @mapChipSize

  # 指定位置に変更
  moveTo: (x, y) ->
    @moveX = @mapX = x
    @moveY = @mapY = y
    @x = @_calcScreenX()
    @y = @_calcScreenY()
    @

  # 左に移動
  moveLeft: (n=1)->
    @direction = 4
    return unless @isPassable(@mapX,@mapY,4)
    @mapX -= n
    @
  # 右に移動
  moveRight: (n=1)->
    @direction = 6
    return unless @isPassable(@mapX,@mapY,6)
    @mapX += n
    @
  # 上に移動
  moveUp: (n=1)->
    @direction = 8
    return unless @isPassable(@mapX,@mapY,8)
    @mapY -= n
    @
  # 下に移動
  moveDown: (n=1)->
    @direction = 2
    return unless @isPassable(@mapX,@mapY,2)
    @mapY += n
    @
  # 移動ループ
  moveLoop: () ->
    @moveRouteIndex = 0
    @updateMoveRoute()
  # ランダム移動
  moveRundom: () ->
    name = MOVE_RUNDOM[Math.floor(Math.random() * MOVE_RUNDOM.length)]
    @applyMoveMethod name

  # 移動可能判定
  #　TODO: ななめどしよ
  isPassable: (x, y, d) ->
    # マップの取得
    map = rpg.system.scene.map
    # 向き指定が文字列の場合は、数値に
    d = CHARACTER_DIRECTION[d] if typeof d is 'string'
    # 向き設定インデックスの計算 2,4,6,8 と言うのを、0,1,2,3 に
    di = d / 2 - 1
    # 移動先座標の計算
    nx = x + X_ROUTE[di]
    ny = y + Y_ROUTE[di]
    # マップ範囲チェック
    return false if not map.isValid(nx,ny)
    # 移動可能チェック
    return false if not map.isPassable(x,y,d)
    # 向きを逆に
    rd = REVERSE_DIRECTION[di]
    return false if not map.isPassable(nx,ny,rd)
    true
