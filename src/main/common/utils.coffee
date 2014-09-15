
# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

_effectValFunc = {
  fix: (b, p) -> p.val
  rate: (b, p) -> b * p.val / 100
  range: (b, p) -> Math.floor(Math.random() * p.max) + p.min
}

_stringifyFunc = (k,v) ->
  return undefined unless v?
  if k != 'd' and rpg[v.constructor.name]?
    return {
      t: v.constructor.name
      d: v
    }
  v

_parseFunc = (k,v) ->
  return undefined unless v?
  if k != 't' and rpg[v.t]?
    return new rpg[v.t](v.d)
  v
  
# Utils
rpg.utils = {
  effectVal: (base,param={type:'fix',val:10}) ->
    _effectValFunc[param.type](base,param)
  
  createJsonData: (obj) -> JSON.stringify(obj,_stringifyFunc)
  createRpgObject: (json) -> JSON.parse(json,_parseFunc)
}

# extendAll 内部関数
_extendAll = (a, b) ->
  return {} unless b?
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
