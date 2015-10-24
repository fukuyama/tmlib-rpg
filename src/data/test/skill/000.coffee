require '../requires.coffee'

SCOPE = rpg.constants.SCOPE

module.exports = {
  name: 'なにもしない'
  help: 'なにもしない'
  scope:
    type: SCOPE.TYPE.ENEMY
    range: SCOPE.RANGE.ONE
  message:
    ok: []
    ng: []
}
