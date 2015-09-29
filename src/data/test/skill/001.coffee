require '../requires.coffee'

SCOPE = rpg.constants.SCOPE

module.exports = {
  name: '攻撃'
  help: '攻撃'
  scope:
    type: SCOPE.TYPE.ENEMY
    range: SCOPE.RANGE.ONE
  target:
    effects:[
      hpdamage: [
        [['user.patk','/',2],'-',['target.pdef','/',4]]
        '*'
        [[[0,'random',15],'/',100.0],'+',1.0]
      ]
      attrs: ['物理']
    ]
  message:
    ok: []
    ng: []
}
