
# Utils

# extendAll 内部関数
_extendAll = (a, b) ->
  r = null
  if Array.isArray b
    r = []
    r.push _extendAll(null, v) for v in b
  else if typeof b is 'object'
    if a? and typeof a is 'object'
      r = a
      r[k] = _extendAll(a[k], b[k]) for k, v of b
    else
      r = {}
      r[k] = _extendAll(null, b[k]) for k, v of b
  else
    r = b
  r

# extend を再帰的に
# json じゃない、Object に使うと良くない。
Object.defineProperty Object.prototype, '$extendAll',
  value: (src) ->
    _extendAll(@,src)
  enumerable: false
  writable: true

Number.prototype.formatString = (fmt) ->
  fmt.substring(0, fmt.length - @.toString().length) + @
