config = require '../buildconfig.coffee'
gulp   = require 'gulp'
glob   = require 'glob'
fs     = require 'fs'
rpgc   = require '../src/main/tools/RPGCompiler'

rpg_compiler_callback = (param) ->
	(cb) ->
    op = {
      inputDir
      outputDir
    } = param
    op.src = []
    fs.mkdir op.outputDir, (err) ->
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

gulp.task 'build_rpg:sample', ['build_express'], rpg_compiler_callback(config.rpg.sample)
gulp.task 'build_rpg:demo001', ['build_express'], rpg_compiler_callback(config.rpg.demo001)
gulp.task 'build_rpg', ['build_rpg:sample','build_rpg:demo001']
