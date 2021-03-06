# ウィンドウスキン素材の仕様(Hiyoko 風)
sys = require 'sys'
sys.print JSON.stringify
  type: 'json'
  src:
    image: 'windowskin.image'
    borderWidth: 32
    borderHeight: 32
    backgroundPadding: 2
    backgroundColor: 'rgba(255,255,255,1.0)'
    spec:
      backgrounds: [
        [32,32,64,64]
      ]
      topLeft: [0, 0, 32, 32]
      topRight: [320 - 32, 0, 32, 32]
      bottomLeft: [0, 320 - 32, 32, 32]
      bottomRight: [320 - 32, 320 - 32, 32, 32]
      borderTop: [32, 0, 32, 32]
      borderBottom: [32, 320 - 32, 32, 32]
      borderLeft: [0, 32, 32, 32]
      borderRight: [320 - 32, 32, 32, 32]
