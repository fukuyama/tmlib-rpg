# rpg json ファイル作成

path = require 'path'
fs   = require 'fs'
jc   = require './JsonCompiler'

SUBDIRS = [
  'map'
  'spritesheet'
  'state'
  'item'
  'skill'
  'weapon'
  'armor'
  'actor'
  'enemy'
  'troop'
]

class RPGCompiler

  constructor: (args={}) ->
    {
      @inputDir
      @outputDir
      @src
    } = args
    console.assert fs.existsSync(@outputDir), "outputDir(#{@outputDir}) not found."
    @inputDir = path.resolve @inputDir
    @outputDir = path.resolve @outputDir

  _makesubdirs: ->
    for d in SUBDIRS
      nm = path.join @outputDir, d
      fs.mkdirSync(nm) unless fs.existsSync nm

  compile_source: ->
    for s in @src
      i = path.join @inputDir, s
      o = path.join @outputDir, s
      o = o.replace(path.extname(o),'.json')
      if fs.existsSync i
        jc.compileFile o, i

  compile_source_list: (key) ->
    o = path.join(@outputDir, key)
    i = path.join(@inputDir, key + 'list.coffee')
    if fs.existsSync i
      jc.compileFileArray o, i, key


  compile: ->
    @_makesubdirs()
    @compile_source()
    @compile_source_list(d) for d in SUBDIRS

RPGCompiler.compile = (args={}) ->
  rpgc = new RPGCompiler(args)
  rpgc.compile()

module.exports = RPGCompiler
