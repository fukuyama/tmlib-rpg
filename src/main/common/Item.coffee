
# アイテムクラス

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# アイテムクラス
class rpg.Item

  # コンストラクタ
  constructor: (args={}) ->
    {
      @name
      @price
      usable
      equip
      stack
    } = {
      name: ''      # 名前
      price: 1      # 価格
      usable: false # 使えるかどうか
      equip: false  # 装備できるかどうか
      stack: false  # スタック可能かどうか
    }.$extendAll args
    Object.defineProperty @, 'usable', get: -> usable
    Object.defineProperty @, 'equip', get: -> equip
    Object.defineProperty @, 'stack', get: -> stack
