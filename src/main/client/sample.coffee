# constant
root = window ? global ? @

###
root.SYSTEM_ASSETS =
  system: 'sample/system.json'
###
root.SYSTEM_ASSETS =
  system:
    type: 'json'
    src:
      main:
        nextScene: 'SceneMy'
        assets: {
          'windowskin.image': 'img/test_windowskin2.png'
        }
