sample_files = [
  'map/001'
]

target = 'target'
main = '../../'

jc = require "#{main}tools/JsonCompiler"

path = require 'path'
fs   = require 'fs'

jc.base = path.dirname fs.realpathSync(__filename)

outputDir = path.join(target, 'public/client/data')
mapDir = path.join(outputDir,'map')

fs.exists path.join(mapDir), (exists) -> fs.mkdirSync(mapDir) unless exists

for name in sample_files
  file = path.join(outputDir, name + '.json')
  jc.compileFile file, name
