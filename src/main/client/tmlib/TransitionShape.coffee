###*
* @file TransitionShape.coffee
* トランジションシェイプ
###

tm.define 'tm.display.TransitionShape',

  superClass: 'tm.display.Shape'

  ###* コンストラクタ
  * @classdesc トランジションシェイプ
  * @constructor tm.display.TransitionShape
  * @param {number} width 幅
  * @param {number} height 高さ
  * @param {Object} options オプション
  * @param {string|tm.graphics.Bitmap} options.transition トランジション素材
  * @param {tm.graphics.Bitmap} options.source 元描画イメージビットマップ
  * @param {number} options.frame=20 トランジション処理のフレーム数
  * @param {string} options.filter='default' トランジションのフィルタ方式 (default|grace)
  * @param {boolean} options.reverse=false 白黒階調を逆に使う場合 true
  ###
  init: (width, height, options) ->
    {
      transition
      source
      frame
      filter
      reverse
    } = {
      transition: 'transition' # トランジション素材
      source: null             # 元描画イメージ {Bitmap}
      frame: 20                # フレーム数
      filter: 'default'        # フィルタ
      reverse: false           # 白黒階調を逆に使う場合 true
    }.$extend options

    @superInit(width:width, height:height)

    @_threshold = 0               # 閾値
    @_increment = 256 / frame | 0 # 閾値増加量

    # transition 素材用意
    if typeof transition is 'string'
      texture = tm.asset.Manager.get transition
      if texture?
        transition = texture.getBitmap()
      else
        transition = null
    unless transition?
      # transition が無い場合
      transition = tm.graphics.Bitmap(width, height)
      # ランダムで作成
      @_filter
        transition: transition.data
        apply: (sr,tr,th,x,y) ->
          i = @_xytoi x, y
          tr[i+0] = tr[i+1] = tr[i+2] = Math.rand(0,255)

    # source 素材用意
    unless source?
      source = tm.graphics.Bitmap(width, height)

    # reverse の場合は白黒反転(transition)
    if reverse
      @_filter
        transition: transition.data
        apply: (sr,tr,th,x,y) ->
          i = @_xytoi x, y
          tr[i+0] ^= 255
          tr[i+1] ^= 255
          tr[i+2] ^= 255

    # source は不透明にする
    @_filter
      source: source.data
      apply: (sr,tr,th,x,y) -> sr[@_xytoi(x, y)+3] = 255

    # トランジションのキャッシュを作成
    @_cache = @_createCache(source,transition,filter)

    # 初期描画
    @canvas.drawBitmap(@_cache[@_threshold],0,0)

  ###* トランジションのキャッシュを作成
  * @memberof tm.display.TransitionShape#
  * @private
  ###
  _createCache: (source,transition,filter) ->
    cache = {}
    # フィルタ処理内部メソッド
    apply = @['_apply_' + filter] ? @_apply_default
    canvas = tm.graphics.Canvas().
      resize(@width, @height).
      drawBitmap(source,0,0)
    flag = true
    threshold = 0
    while threshold < 255 or flag
      source = canvas.getBitmap()
      flag = @_filter
        source: source.data
        transition: transition.data
        threshold: threshold
        apply: apply
      canvas.drawBitmap(source,0,0)
      cache[threshold] = source
      threshold += @_increment
    return cache

  ###* ピクセル座標＞インデックス変換メソッド
  * @memberof tm.display.TransitionShape#
  * @private
  ###
  _xytoi: (x,y) -> (y * @width + x) * 4

  ###* トランジションフィルタ更新処理（基本）。
  * 閾値以下の部分を透明にする。
  * @memberof tm.display.TransitionShape#
  * @private
  ###
  _apply_default: (source, transition, threshold, x, y) ->
    i = @_xytoi x, y
    return false if source[i+3] == 0
    n = transition[i] # とりあえず赤しか見てない
    if n <= threshold
      source[i+3] = 0 # α値変更
    return true

  ###* トランジションフィルタ更新処理（緩やか）。
  * 閾値以下の部分を緩やかに透明にする。
  * @memberof tm.display.TransitionShape#
  * @private
  ###
  _apply_grace: (source, transition, threshold, x, y) ->
    i = @_xytoi x, y
    return false if source[i+3] == 0
    n = transition[i] # とりあえず赤しか見てない
    if n <= threshold
      source[i+3] -= @_increment * 2 # α値変更
    return true

  ###* トランジションフィルタ処理
  * @memberof tm.display.TransitionShape#
  * @private
  ###
  _filter: (param={}) ->
    {
      source
      transition
      threshold
      apply
    } = {
      threshold: 0
    }.$extend param
    r = false
    for y in [0 ... @height]
      for x in [0 ... @width]
        r = apply.call(@, source, transition, threshold, x, y) or r
    return r

  ###* 終了確認
  * @memberof tm.display.TransitionShape#
  * @return {boolean} トランジション処理が終わっている場合 true
  ###
  isEnd: -> not @_cache[@_threshold]?

  ###* インクリメント処理。トランジションを進める
  * @memberof tm.display.TransitionShape#
  ###
  increment: ->
    @canvas.drawBitmap(@_cache[@_threshold],0,0)
    @_threshold += @_increment
    return

# TODO: とりあえず
tm.app.BaseApp.prototype.transitionScene = (scene, options={}) ->
  if @currentScene?

    # 今の状態を描画
    @_draw()

    # トランジション作成
    transition = tm.display.TransitionShape(
      @width
      @height
      {
        source: @canvas.getBitmap() # 表示内容をBitmap化
      }.$extend options
    ).
    setOrigin(0,0).
    setPosition(0,0).
    addChildTo(scene) # 切替先のシーンに追加する

    # enterframe　用の関数
    enterframe = (e) ->
      if transition.isEnd()
        # トランジションが終わっていたら削除
        transition.remove()
        transition = null
        # イベントハンドラも削除
        @off 'enterframe', enterframe
      else
        # フレームごとにトランジションを進める
        transition.increment()

    # enterframe イベントリスナー登録
    scene.on 'enterframe', enterframe

  # シーン切り替え
  @replaceScene scene
