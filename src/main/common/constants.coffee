# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

rpg.constants = rpg.constants ? {}
c = rpg.constants

# 移動制限定数、移動できる方向が true
# 方向は [2,4,6,8] の位置パラメータ
# VXAce にならって乗り物も入れるか…？
c.MOVE_RESTRICTION = {
  ALLOK: [true,true,true,true]
  UPOK: [false,false,false,true]
  DOWNOK: [true,false,false,false]
  LEFTOK: [false,true,false,false]
  RIGHTOK: [false,false,true,false]
  ALLNG: [false,false,false,false]
  HORIZON: [false,true,true,false]
  VERTICAL: [true,false,false,true]
  CORNER1: [false,false,true,true]
  CORNER3: [false,true,false,true]
  CORNER7: [true,false,true,false]
  CORNER9: [true,true,false,false]
  UPNG: [true,true,true,false]
  DOWNNG: [false,true,true,true]
  LEFTNG: [true,false,true,true]
  RIGHTNG: [true,true,false,true]
}

# [味方、敵][単体、複数]
c.ITEM_SCOPE = {
  TYPE:
    ALL: 0
    FRIEND: 1
    ENEMY: 2
  RANGE:
    ONE: 1
    MULTI: 2
}
