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
    @clear()

  ###* 状態クリア
  * @method rpg.MarkupText#clear
  ###
  clear: ->
    @matched = false

  ###* マークアップ追加.
  * @method rpg.MarkupText#add
  * @param {string} mark マークアップ文字列
  * @param {rpg.MarkupText~replacecallback} func マークアップ置き換え用コールバック
  ###

  ###* マークアップ追加.
  * @method rpg.MarkupText#add
  * @param {Object} param
  * @param {string} param.mark マークアップ１文字目
  * @param {string} param.name マークアップ名
  * @param {rpg.MarkupText~replacecallback} param.func マークアップ置き換え用コールバック
  ###
  add: (args1,args2) ->
    if arguments.length == 2
      @markups.push {
        mark: args1[0]
        name: args1[1 .. ]
        func: args2 # func(obj, x, y, message, i)
      }
    else if arguments.length == 1
      @markups.push args1

  ###* マークアップ内部処理
  * @method rpg.MarkupText#_drawIntarnal
  * @return {boolean} 処理をした場合 true
  * @praivate
  ###
  _drawIntarnal: ->
    for markup in @markups when markup.mark == @message[@i]
      nm = @message[@i + 1 .. markup.name.length + @i]
      if markup.name == nm
        [@x, @y, @i, @matched] = markup.func(@obj, @x, @y, @message, @i)
        return true if @matched
    return false

  ###* マークアップ描画.
  * メッセージ処理位置が、マークアップ１文字目ではない場合は、置き換えられない.
  * @method rpg.MarkupText#draw
  * @param {Object} obj 対象オブジェクト(rpg.Window 等)
  * @param {number} x 表示位置X座標
  * @param {number} y 表示位置Y座標
  * @param {string} message 処理中のメッセージ
  * @param {number} i 処理中のメッセージ箇所のインデックス
  * @return {Array} [x,y,i] 置き換え後の表示位置とインデックスを返す
  ###
  draw: (@obj, @x, @y, @message, @i) ->
    @clear()
    while @_drawIntarnal()
      break unless @i < @message.length
    [@x, @y, @i]

###* 改行(\n)
* @var {Object} rpg.MarkupText.MARKUP_NEW_LINE
###
rpg.MarkupText.MARKUP_NEW_LINE = {
  mark: '\\'
  name: 'n'
  func: (obj, x, y, message, i) ->
    x = 0
    y += rpg.system.lineHeight
    i += 2
    [x,y,i,true]
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
  func: (obj, x, y, msg, i) ->
    if obj instanceof rpg.Window
      e = msg[i .. ].indexOf(']') + i
      if e > 0
        m = msg[i .. e]
        s = i + m.indexOf('[') + 1
        obj.textColor = COLORS[msg[s .. e - 1]]
        i = e + 1
    [x,y,i,false]
}

_default = new rpg.MarkupText()
_default.add rpg.MarkupText.MARKUP_NEW_LINE
_default.add rpg.MarkupText.MARKUP_COLOR
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
