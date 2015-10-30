
# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}
rpg.ai = rpg.ai ? {}

_stringifyFunc = (k,v) ->
  return undefined unless v?
  if k != 'd'
    if rpg[v.constructor.name]? or rpg.ai[v.constructor.name]?
      return {
        t: v.constructor.name
        d: v
      }
  v

_parseFunc = (k,v) ->
  return undefined unless v?
  if k != 't'
    if rpg[v.t]?
      return new rpg[v.t](v.d)
    if rpg.ai[v.t]?
      return new rpg.ai[v.t](v.d)
  v

_expression = {
  '+': (l,r) -> l + r
  '-': (l,r) -> l - r
  '*': (l,r) -> l * r
  '/': (l,r) -> l / r
  '>': (l,r) -> l > r
  '<': (l,r) -> l < r
  '>=': (l,r) -> l >= r
  '<=': (l,r) -> l <= r
  '==': (l,r) -> l == r
  '!=': (l,r) -> l != r
  'and': (l,r) -> l and r
  '&&': (l,r) -> l and r
  'or': (l,r) -> l or r
  '||': (l,r) -> l or r
  'random': (min,max) -> Math.round(Math.floor( Math.random() * (max - min + 1) ) + min)
}
# Utils
rpg.utils = {
  createJsonData: (obj,op) -> JSON.stringify(obj,_stringifyFunc,op)
  createRpgObject: (json) -> JSON.parse(json,_parseFunc)
  jsonExpression: (json,op={}) ->
    switch typeof json
      when 'string'
        path = json
        last = path
        obj = op
        for k in path.split /[\[\]\.]/ when obj[k]?
          obj = obj[k]
          last = obj
        return last
      when 'number'
        return json
      when 'boolean'
        return json
    if Array.isArray json
      json =
        l: json[0]
        e: json[1]
        r: json[2]
    if json.e is '='
      r = @jsonExpression json.r, op
      path = json.l
      obj = op
      ret = obj
      for k in path.split /[\[\]\.]/ when obj[k]?
        ret = obj
        obj = obj[k]
      ret[k] = r
      return r
    l = @jsonExpression json.l, op
    r = @jsonExpression json.r, op
    return _expression[json.e] l, r
}

# extendAll 内部関数
_extendAll = (a, b) ->
  return null unless b?
  r = null
  if Array.isArray b
    r = []
    for v in b when typeof v isnt 'function'
      r.push _extendAll(null, v)
  else if typeof b is 'object'
    if b.constructor.name is 'Object'
      if a? and typeof a is 'object'
        r = a
        for k, v of b when typeof v isnt 'function'
          r[k] = _extendAll(a[k], b[k])
      else
        r = {}
        for k, v of b when typeof v isnt 'function'
          r[k] = _extendAll(null, b[k])
    else
      r = b
  else
    r = b
  r

# extend を再帰的に
# json じゃない、Object に使うと良くないかも、class ぽいのと、function には対応したつもり
Object.defineProperty Object.prototype, '$extendAll',
  value: (src) ->
    _extendAll(@,src)
  enumerable: false
  writable: true

# 数値フォーマッター
Number.prototype.formatString = (fmt) ->
  fmt.substring(0, fmt.length - @.toString().length) + @
