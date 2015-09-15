config = require '../buildconfig.coffee'
gulp   = require 'gulp'
glob   = require 'glob'
fs     = require 'fs'
mkdirp = require 'mkdirp'
rpgc   = require '../src/main/tools/RPGCompiler'

rpg_compiler_callback = (param) ->
	(cb) ->
    op = {
      inputDir
      outputDir
    } = param
    op.src = []
    mkdirp op.outputDir, (err) ->
      if err? and err.code isnt 'EEXIST'
        cb(err)
        return
      glob op.inputDir + '*/*.coffee', (err,matches) ->
        for file in matches
          op.src.push file.replace(op.inputDir,'')
        op.src.push 'system.coffee'
        rpgc.compile(op)
      cb()
    return

tasks = []
for k,v of config.rpg
  taskname = 'build_rpg:' + k
  tasks.push taskname
  gulp.task taskname, ['build_express'], rpg_compiler_callback(v)

gulp.task 'build_rpg', tasks
