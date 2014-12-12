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
  main:
    nextScene: 'SceneTitle'
    param: ['scene.title']
    assets: {
      'scene.title':
        type: 'json'
        src:
          menus: [
            {
              name:'NewGame'
              action: 'NewGame'
            }
            {
              name:'Option'
            }
          ]
      'system.se.menu_decision': 'audio/se/fin.mp3'
      'system.se.menu_cursor_move': 'audio/se/fon.mp3'
      'windowskin.image': 'img/test_windowskin2.png'
      'spritesheet.hiyoko':
        type:'tmss'
        src: '001/spritesheet/hiyoko.json'
      'spritesheet.object001':
        type:'tmss'
        src: '001/spritesheet/object001.json'
    }
  start:
    actors: [1]
}
