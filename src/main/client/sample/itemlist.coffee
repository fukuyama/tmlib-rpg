require('../../common/utils')
require('../../common/constants')

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

EVENT_TEMPLATE = {
  CURE: [
    {
      type: 'message'
      params: [
        '\#{user.name} は \#{item.name} を \#{targets[0].name} に使った。'
        '\#{targets[0].name} の HP が \#{targets[0].hp} 回復した。'
      ]
    }
  ]
  CURE_ALL: [
    {type:'option',params:[{message:{close:off}}]}
    {
      type: 'message'
      params: ['\#{user.name} は \#{item.name} を使った。']
    }
    {type:'flag',params:['system:i','=',0]}
    {type:'loop'}
    {type:'block',params:[
      {
        type: 'message'
        params: ['\#{targets[\\F[system:i]].name} の HP が \#{targets[\\F[system:i]].hp} 回復した。']
      }
      {type:'flag',params:['system:i','+',1]}
      {type:'if',params:['flag','system:i','>=','log','targets.length']}
      {type:'block',params:[
        {type:'break'}
      ]}
      {type:'end'}
    ]}
    {type:'end'}
    {type:'option',params:[{message:{close:on}}]}
  ]
  ITEM_NG: [
    {
      type: 'message'
      params: [
        '\#{user.name} は \#{item.name} を使った。'
        'しかし 効果がなかった。'
      ]
    }
  ]
}


# scope 定義
FRIEND_ONE =
  type: ITEM_SCOPE.TYPE.FRIEND
  range: ITEM_SCOPE.RANGE.ONE
  hp0: false

FRIEND_ALL =
  type: ITEM_SCOPE.TYPE.FRIEND
  range: ITEM_SCOPE.RANGE.MULTI
  hp0: false

ENEMY_ONE =
  type: ITEM_SCOPE.TYPE.ENEMY
  range: ITEM_SCOPE.RANGE.ONE
  hp0: false

ENEMY_ALL =
  type: ITEM_SCOPE.TYPE.ENEMY
  range: ITEM_SCOPE.RANGE.MULTI
  hp0: false

effect = {
  hp: (n) -> hp:{type:'fix',val:n}
}


module.exports = [
  {
    type: 'Item'     # クラス名
   　item: '002'      # ID(URLになる)
    name: 'item 002' # 名前
    price: 1         # 価格
    help: 'help 002' # ヘルプテキスト
    message: null    # ログメッセージテンプレート
    usable: false    # 使えるかどうか
    equip: false     # 装備できるかどうか
    stack: false     # スタック可能かどうか
    maxStack: 99     # スタック可能な場合のスタック数
  }

  {
    type: 'Item'
   　item: '003'
   　name: 'item 003'
    price: 1
    help: 'help 003'
  }

  {
    type: 'UsableItem'
   　item: '004'
    name: 'cure I'
    price: 10
    help: '仲間一人を少し回復する'
    stack: true
    maxStack: 99
    scope: FRIEND_ONE
    effects: [effect.hp 10]
    message:
      ok: EVENT_TEMPLATE.CURE
      ng: EVENT_TEMPLATE.ITEM_NG
  }

  {
    type: 'UsableItem'
    item: '005'
    name: 'heal I'
    price: 40
    help: '仲間全員を少し回復する'
    scope: FRIEND_ALL
    effects: [effect.hp 10]
    message:
      ok: EVENT_TEMPLATE.CURE_ALL
      ng: EVENT_TEMPLATE.ITEM_NG
  }
]
