###*
* @file MarkupText.coffee
* マークアップテキスト処理
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# マークアップテキスト処理
class rpg.MarkupText

  ###*
  * コンストラクタ
  * @classdesc マークアップテキスト処理
  * @constructor rpg.MarkupText
  ###
  constructor: ->
    @markups = []
    @replaces = []
    @clear()

  ###* 状態クリア
  * @method rpg.MarkupText#clear
  ###
  clear: ->
    @matched = false
    return

  ###* マークアップ追加
  * @method rpg.MarkupText#add
  * @param {string} mark マークアップ文字列
  * @param {rpg.MarkupText~replacecallback} func マークアップ置き換え用コールバック
  ###

  ###* マークアップ追加
  * @method rpg.MarkupText#addMarkup
  * @param {Object} param
  * @param {string} param.mark マークアップ１文字目
  * @param {string} param.name マークアップ名
  * @param {rpg.MarkupText~replacecallback} param.func マークアップ置き換え用コールバック
  ###
  addMarkup: (args1,args2) ->
    if arguments.length == 2
      @markups.push {
        mark: args1[0]
        name: args1[1 .. ]
        func: args2 # func(obj, x, y, message, i)
      }
    else if arguments.length == 1
      @markups.push args1

  ###* 置き換え追加
  * @method rpg.MarkupText#addReplaces
  * @param {Object} param
  * @param {string} param.mark マークアップ１文字目
  * @param {string} param.name マークアップ名
  * @param {rpg.MarkupText~replacecallback} param.func マークアップ置き換え用コールバック
  ###
  addReplace: (args1,args2) ->
    if arguments.length == 2
      @replaces.push {
        regexp: args1[0]
        func: args2
      }
    else if arguments.length == 1
      @replaces.push args1

  ###* マークアップ内部処理
  * @method rpg.MarkupText#_drawIntarnal
  * @return {boolean} 処理をした場合 true
  * @praivate
  ###
  _drawIntarnal: ->
    for markup in @markups when markup.mark == @message[@i]
      nm = @message[@i + 1 .. markup.name.length + @i]
      if markup.name == nm
        if markup.func.call @
          @matched = true
          return true
    return false

  ###* マークアップ描画
  * メッセージ処理位置が、マークアップ１文字目ではない場合は、置き換えられない
  * @method rpg.MarkupText#draw
  * @param {Object} obj 対象オブジェクト(rpg.Window 等)
  * @param {number} x 表示位置X座標
  * @param {number} y 表示位置Y座標
  * @param {string} message 処理中のメッセージ
  * @param {number} i 処理中のメッセージ箇所のインデックス
  * @return {Array} [x,y,i,msg] 置き換え後の表示位置とインデックス,文字列を返す
  ###
  draw: (@obj, @x, @y, @message, @i) ->
    @clear()
    while @_drawIntarnal()
      break unless @i < @message.length
    [@x, @y, @i, @message]

  _replaceIntarnal: ->
    ret = false
    for rep in @replaces
      if rep.regexp.test @message
        @message = @message.replace rep.regexp, rep.func
        ret = true
    return ret

  replace: (@message) ->
    true while @_replaceIntarnal()
    return @message

###* 改行(\n)
* @var {Object} rpg.MarkupText.MARKUP_NEW_LINE
###
rpg.MarkupText.MARKUP_NEW_LINE = {
  mark: '\\'
  name: 'n'
  func: ->
    @x = 0
    @y += rpg.system.lineHeight
    @i += 2
    true
}

COLORS = [
  'rgb(255,255,255)'
  'rgb(  0,  0,  0)'
  'rgb(230,  0, 18)'
  'rgb(255,251,  0)'
  'rgb(  0,153, 68)'
  'rgb(  0,160,233)'
  'rgb( 29, 32,136)'
  'rgb(228,  0,127)'
]

###* カラー(\C[0-7])
* @var {Object} rpg.MarkupText.MARKUP_COLOR
###
rpg.MarkupText.MARKUP_COLOR = {
  mark: '\\'
  name: 'C'
  func: ->
    if @obj instanceof rpg.Window
      e = @message[@i .. ].indexOf(']') + @i
      if e > 0
        m = @message[@i .. e]
        s = @i + m.indexOf('[') + 1
        @obj.textColor = COLORS[@message[s .. e - 1]]
        @i = e + 1
    false
}

###* ポーズスキップ
* @var {Object} rpg.MarkupText.MARKUP_SKIP
###
rpg.MarkupText.MARKUP_SKIP = {
  mark: '\\'
  name: 'skip'
  func: ->
    if @obj instanceof rpg.WindowMessage
      e = @message[@i .. ].indexOf(']')
      if e > 0
        e += @i
        m = @message[@i .. e]
        s = @i + m.indexOf('[') + 1
        @obj.pauseSkip(@message[s .. e - 1])
        @i = e + 1
      else
        @obj.pauseSkip()
        @i += 5
    false
}

###* コンテンツクリア
* @var {Object} rpg.MarkupText.MARKUP_CLEAR
###
rpg.MarkupText.MARKUP_CLEAR = {
  mark: '\\'
  name: 'clear'
  func: ->
    if @obj instanceof rpg.WindowMessage
      @obj.clearContent()
      @x = @y = 0
      @i += 6
    false
}

###* フラグ置き換え(\F[any])
* @var {Object} rpg.MarkupText.REPLACE_FLAG
###
rpg.MarkupText.REPLACE_FLAG = {
  regexp: /\\F\[([^\\]+?)\]/g
  func: (reg, key) ->
    rpg.game.flag.normalizeValue key
}

###* ログメッセージ置き換え(#{any})
* @var {Object} rpg.MarkupText.REPLACE_LOG
###
rpg.MarkupText.REPLACE_LOG = {
  regexp: /\#\{(.+?)\}/g
  func: (reg, path) ->
    log = rpg.system.temp.log
    log = log[k] for k in path.split /[\[\]\.]/ when log[k]?
    log
}

###* ワード置き換え(\W[any])
* @var {Object} rpg.MarkupText.REPLACE_WORD
###
rpg.MarkupText.REPLACE_WORD = {
  regexp: /\\W\[([^\\]+?)\]/g
  func: (reg, path) ->
    word = rpg.constants.WORDS
    word = word[k] for k in path.split /[\[\]\.]/ when word[k]?
    word
}

# デフォルトのMarkupText
_default = new rpg.MarkupText()

# マークアップ
_default.addMarkup rpg.MarkupText.MARKUP_NEW_LINE
_default.addMarkup rpg.MarkupText.MARKUP_COLOR
_default.addMarkup rpg.MarkupText.MARKUP_SKIP
_default.addMarkup rpg.MarkupText.MARKUP_CLEAR

# 置き換え
_default.addReplace rpg.MarkupText.REPLACE_FLAG
_default.addReplace rpg.MarkupText.REPLACE_LOG
_default.addReplace rpg.MarkupText.REPLACE_WORD

rpg.MarkupText.default = _default



###* マークアップ置き換え用コールバック
* (obj, x, y, message, i)->[x,y,i])
* @callback rpg.MarkupText~replacecallback
* @param {Object} obj 対象オブジェクト(rpg.Window 等)
* @param {number} x 表示位置X座標
* @param {number} y 表示位置Y座標
* @param {string} message 処理中のメッセージ
* @param {number} i 処理中のメッセージ箇所のインデックス
* @return {Array} [x,y,i] 置き換え後の表示位置とインデックスを返す
###
