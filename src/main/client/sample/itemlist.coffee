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

module.exports = [
  {type: 'Item', item: '002', name: 'item 002'}

  {type: 'Item', item: '003', name: 'item 003'}

  {
    type: 'UsableItem', item: '004', name: 'cure I'
    scope: {
      type: ITEM_SCOPE.TYPE.FRIEND
      range: ITEM_SCOPE.RANGE.ONE
    }
    effects: [
      {hp: {
        type: 'fix'
        val: 10
      }}
    ]
    message:
      ok: EVENT_TEMPLATE.CURE
      ng: EVENT_TEMPLATE.ITEM_NG
  }

  {
    type: 'UsableItem', item: '005', name: 'heal I'
    scope: {
      type: ITEM_SCOPE.TYPE.FRIEND
      range: ITEM_SCOPE.RANGE.MULTI
    }
    effects: [
      {hp: {
        type: 'fix'
        val: 10
      }}
    ]
    message:
      ok: EVENT_TEMPLATE.CURE_ALL
      ng: EVENT_TEMPLATE.ITEM_NG
  }
]
