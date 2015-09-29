# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

rpg.constants = rpg.constants ? {}
c = rpg.constants

# 移動制限定数、移動できる方向が true
# 方向は [2,4,6,8] の位置パラメータ
# VXAce にならって乗り物も入れるか…？
c.MOVE_RESTRICTION = {
  ALLOK:    [true ,true ,true ,true ]
  UPOK:     [false,false,false,true ]
  DOWNOK:   [true ,false,false,false]
  LEFTOK:   [false,true ,false,false]
  RIGHTOK:  [false,false,true ,false]
  ALLNG:    [false,false,false,false]
  HORIZON:  [false,true ,true ,false]
  VERTICAL: [true ,false,false,true ]
  CORNER1:  [false,false,true ,true ]
  CORNER3:  [false,true ,false,true ]
  CORNER7:  [true ,false,true ,false]
  CORNER9:  [true ,true ,false,false]
  UPNG:     [true ,true ,true ,false]
  DOWNNG:   [false,true ,true ,true ]
  LEFTNG:   [true ,false,true ,true ]
  RIGHTNG:  [true ,true ,false,true ]
}

# [味方、敵][単体、複数]
c.SCOPE = {
  TYPE:
    ALL: 0
    FRIEND: 1
    ENEMY: 2
  RANGE:
    ONE: 1
    MULTI: 2
}

# メッセージウィンドウの位置
c.MESSAGE_OPTION = {
  MESSAGE:
    TOP: 1
    CENTER: 2
    BOTTOM: 3
  SELECT:
    LEFT: 1
    CENTER: 2
    RIGHT: 3
  NUMBER:
    LEFT: 1
    CENTER: 2
    RIGHT: 3
}

c.BASE_ABILITIES = [
  'str'
  'vit'
  'dex'
  'agi'
  'int'
  'sen'
  'luc'
  'cha'
  'basehp'
  'basemp'
]

c.BATTLE_ABILITIES = [
  'patk'
  'pdef'
  'matk'
  'mcur'
  'mdef'
  'maxhp'
  'maxmp'
]

c.WORDS = {
  'str': 'ちから'
  'vit': 'たいりょく'
  'dex': 'きようさ'
  'agi': 'すばやさ'
  'int': 'かしこさ'
  'sen': 'かんせい'
  'luc': 'うんのよさ'
  'cha': 'みりょく'
  'hp': 'HP'
  'mp': 'MP'
  'patk': 'こうげき力'
  'pdef': 'ぼうぎょ力'
  'matk': 'こうげき魔力'
  'mcur': 'かいふく魔力'
  'mdef': '魔法ぼうぎょ'
  'maxhp': '最大HP'
  'maxmp': '最大MP'
  'right_hand': '右手'
  'left_hand': '左手'
  'head': '頭'
  'upper_body': '体上'
  'lower_body': '体下'
  'arms': '腕'
  'legs': '足'
  'cash': {
    'unit':'G'
    'name':'ゴールド'
  }
}

c.EQUIP_POSITONS = [
  'left_hand'
  'right_hand'
  'head'
  'upper_body'
  'lower_body'
  'arms'
  'legs'
]
