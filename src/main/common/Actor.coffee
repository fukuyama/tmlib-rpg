
# アクタークラス
#

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# アクタークラス
class rpg.Actor extends rpg.Battler

  # 初期化
  constructor: (args={}) ->
    {
      @properties
    } = {
      properties: {}
    }.$extendAll args
    @setup(args)
    @addProperties('job', '（なし）')
    @addProperties('subjob', '（なし）')
    @addProperties('sex', '？？？')

  addProperties: (name,defaultval) ->
    get = -> if @properties[name]? then @properties[name] else defaultval
    set = (v) -> @properties[name] = v
    Object.defineProperty @,name,
      enumerable: true
      get: get.bind @
      set: set.bind @
