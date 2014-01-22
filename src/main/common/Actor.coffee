
# アクタークラス
#

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# アクタークラス
class rpg.Actor extends rpg.Battler

  constructor: (args={}) ->
    @setup(args)
