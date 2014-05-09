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
    effect: [
      {hp: {
        type: 'fix'
        val: 10
      }}
    ]
  }
]
