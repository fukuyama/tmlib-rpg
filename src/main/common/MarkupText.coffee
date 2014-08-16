# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# マークアップテキスト処理
class rpg.MarkupText

  # コンストラクタ
  constructor: ->
    @markups = []
    @clear()

  # 状態クリア
  clear: ->
    @matched = false

  # マークアップ追加
  # add('\\a',(obj, x, y, message, i)->[x,y,i])
  # add(mark:'\\',name:'a',func:(obj, x, y, message, i)->[x,y,i])
  add: (args1,args2) ->
    if arguments.length == 2
      @markups.push {
        mark: args1[0]
        name: args1[1 .. ]
        func: args2 # func(obj, x, y, message, i)
      }
    else if arguments.length == 1
      @markups.push args1

  # マークアップ内部処理
  _drawIntarnal: ->
    for markup in @markups when markup.mark == @message[@i]
      nm = @message[@i + 1 .. markup.name.length + @i]
      if markup.name == nm
        [@x, @y, @i, @matched] = markup.func(@obj, @x, @y, @message, @i)
        return true if @matched
    return false

  # マークアップ描画
  draw: (@obj, @x, @y, @message, @i) ->
    @clear()
    while @_drawIntarnal()
      break unless @i < @message.length
    [@x, @y, @i]

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
  'rgb(255,  0,  0)'
  'rgb(  0,255,  0)'
  'rgb(  0,  0,255)'
]

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
