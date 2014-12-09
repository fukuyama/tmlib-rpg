# rpg json ファイル作成

path = require 'path'
fs   = require 'fs'
jc   = require 'src/main/tools/JsonCompiler'

SUBDIRS = [
  'map'
  'item'
  'state'
  'spritesheet'
  'actor'
  'weapon'
  'armor'
]

class RPGCompiler

  constructor: (args={}) ->
    {
      @inputDir
      @outputDir
      @src
    } = args

  create_subdirs: () ->
    for d in SUBDIRS
      nm = path.join @outputDir, d
      fs.mkdirSync(nm) unless fs.existsSync(nm)

  compile_source: () ->
    for nm in @src
      f = path.join outputDir, nm + '.json'
      jc.compileFile f, nm

module.exports = RPGCompiler
