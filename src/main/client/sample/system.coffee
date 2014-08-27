require('../../common/utils')
require('../../common/constants')

module.exports = {
  'screen':
    width: 32 * 20
    height: 32 * 15
    background: 'rgb(255,255,255)'
  main:
    nextScene: 'SceneTitle'
    param: ['scene.title']
    assets: {
      'scene.title':
        type: 'json'
        src:
          background:
            image: 'scene.title.background.image'
          menus: [
            {
              name:'NewGame'
              action: 'NewGame'
            }
            {
              name:'Test'
              next:
                nextScene: 'SceneMy'
            }
          ]
      'scene.title.background.image': 'img/test_001.png'
      'system.se.menu_decision': 'audio/se/fin.mp3'
      'system.se.menu_cursor_move': 'audio/se/fon.mp3'
      'windowskin.image': 'img/test_windowskin2.png'
      'sample.spritesheet':
        type:'tmss'
        src: 'data/spritesheet/hiyoko.json'
      'spritesheet.hiyoko':
        type:'tmss'
        src: 'data/spritesheet/hiyoko.json'
      'spritesheet.object001':
        type:'tmss'
        src: 'data/spritesheet/object001.json'
    }
  assets: {
    'i1': 'img/hiyoco_nomal_full.png'
    'i2': 'img/test_character.png'
  }
  loadingSceneDefault:
    gauge:
      color: 'rgb(96,96,96)'
      width: 32 * 20
      y: 32 * 15 - 10
  windowDefault: {}
  start:
    actors: [1,2]
}
