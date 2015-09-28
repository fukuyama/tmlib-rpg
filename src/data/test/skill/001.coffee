require '../requires.coffee'

ITEM_SCOPE = rpg.constants.ITEM_SCOPE

module.exports = {
  name: '攻撃'
  help: '攻撃'
  scope:
    type: ITEM_SCOPE.TYPE.ENEMY
    range: ITEM_SCOPE.RANGE.ONE
  target:
    effects:[
      hpdamage: [
        [['user.patk','/',2],'-',['target.pdef','/',4]]
        '*'
        [[[0,'random',15],'/',100.0],'+',1.0]
      ]
      attrs: ['物理']
    ]
}
