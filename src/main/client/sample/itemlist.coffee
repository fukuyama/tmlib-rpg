require('../../common/utils')
require('../../common/constants')

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

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
      ok: [
        {
          type: 'message'
          params: [
            '\#{user.name} は　\#{item.name} を　\#{targets[0].name} に使った。'
            '\#{targets[0].name} の hp が \#{targets[0].hp} 回復した。'
          ]
        }
      ]
      ng: [
        {
          type: 'message'
          params: [
            '\#{user.name} は　\#{item.name} を　\#{targets[0].name} に使った。'
            'しかし　効果がなかった。'
          ]
        }
      ]
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
  }
]
