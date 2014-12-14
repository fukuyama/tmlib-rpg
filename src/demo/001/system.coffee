path = require 'path'
base = path.dirname module.filename
require path.relative(base,'./src/main/common/utils')
require path.relative(base,'./src/main/common/constants')

module.exports = {
  setting: {
    se: false
    bgm: false
    messageSpeed: 3
  }
  start:
    actors: [1]
    map:
      id: 1
      x: 14
      y: 5
  database:
    path:
      data: '001/'
  main:
    nextScene: 'SceneTitle'
    param: ['scene.title']
    assets: {
      'scene.title':
        type: 'json'
        src:
          menus: [
            {
              name:'NewGame (push enter key!)'
              action: 'NewGame'
            }
            {
              name:'Option'
            }
          ]
      'system.se.menu_decision': 'audio/se/fin.mp3'
      'system.se.menu_cursor_move': 'audio/se/fon.mp3'
      'windowskin.image': 'img/test_windowskin2.png'
      'character.hiyoko':
        type:'tmss'
        src: '001/spritesheet/hiyoko.json'
      'character.object001':
        type:'tmss'
        src: '001/spritesheet/object001.json'
      'character.object002':
        type:'tmss'
        src: '001/spritesheet/object002.json'
    }
}
