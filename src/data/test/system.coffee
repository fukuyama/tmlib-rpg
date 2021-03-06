require './requires.coffee'

module.exports = {
  'screen':
    width: 32 * 20
    height: 32 * 15
    background: 'rgb(255,255,255)'
  setting: {
    se: false
    bgm: false
    messageSpeed: 16
    moveSpeed: 6
  }
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
              name:'New Game'
              action: 'NewGame'
            }
            {
              name:'Load Game'
              action: 'LoadGame'
            }
            {
              name:'Test'
            }
          ]
      'scene.title.background.image': 'img/test_001.png'
      'system.se.menu_decision': 'audio/se/fin.mp3'
      'system.se.menu_cursor_move': 'audio/se/fon.mp3'
      # 'system.bgm.field': 'audio/bgm/game_maoudamashii_4_field10.mp3'
      'windowskin.image': 'img/test_windowskin2.png'
      'sample.spritesheet':
        type:'tmss'
        src: 'rpg/test/spritesheet/hiyoko.json'
      'spritesheet.hiyoko':
        type:'tmss'
        src: 'rpg/test/spritesheet/hiyoko.json'
      'spritesheet.object001':
        type:'tmss'
        src: 'rpg/test/spritesheet/object001.json'
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
    map:
      id: 1
      x: 0
      y: 0
      d: 2
  database:
    preload:
      skill: [1 .. 2]
    path:
      data: 'rpg/test/'
}
