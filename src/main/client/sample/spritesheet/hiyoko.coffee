require('../../../common/utils')
require('../../../common/constants')

module.exports = {
  image: 'img/hiyoco_nomal_full.png'
  frame:
    width: 32
    height: 32
    count: 18
  animations:
    down: frames: [7,6,7,8], next: 'down', frequency: 4
    up: frames: [10,9,10,11], next: 'up', frequency: 4
    left: frames: [13,12,13,14], next: 'left', frequency: 4
    right: frames: [16,15,16,17], next: 'right', frequency: 4
}
