path = require 'path'
base = path.dirname module.filename
require path.relative(base,'./src/main/common/utils')
require path.relative(base,'./src/main/common/constants')

module.exports = {
  image: 'img/object002.png'
  frame:
    width: 32
    height: 32
    count: 12
  animations:
    down: frames: [0]
    left: frames: [0]
    right: frames: [0]
    up: frames: [0]
}
