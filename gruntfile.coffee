
# tmlib-rpg gruntfile
module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'

  banner = """
  /*
   * #{pkg.name} #{pkg.version}
   * #{pkg.homepage}
   * #{pkg.license} Licensed
   *
   * Copyright (C) 2014 #{pkg.author}
   */

  """

  # 共通系のスクリプト(tmlib.js 非依存のつもり)
  common_sections = [
      'common/utils'
      'common/constants'
      'common/Character'
      'common/Battler'
      'common/Actor'
      'common/Party'
      'common/Map'
      'common/Flag'
      'common/Event'
      'common/EventPage'
      'common/ItemContainer'
      'common/Item'
      'common/UsableItem'
      'common/Skill'
      'common/EquipItem'
      'common/Weapon'
      'common/Armor'
      'common/State'
      'common/Effect'
      'common/MarkupText'
  ]
  # クライアントのスクリプト
  client_sections = [
      'sample'
      'tmlib/CustomizeTexture'
      'tmlib/TransitionShape'
      'core/DataBase'
      'core/System'
      'core/SpriteCharacter'
      'core/SpriteCursor'
      'core/SpriteMap'
      'core/SpritesetPicture'
      'core/SpritesetAnimation'
      'core/EventHandler'
      'core/WindowSkin'
      'core/Window'
      'core/WindowMenu'
      'core/WindowInputNum'
      'core/WindowMessage'
      'core/WindowMapMenu'
      'core/WindowOperation'
      'core/WindowMemberBase'
      'core/WindowStatusActorList'
      'core/WindowStatusEquip'
      'core/WindowStatusInfo'
      'core/WindowStatusDetail'
      'core/WindowMapStatus'
      'core/WindowItemActorList'
      'core/WindowItemListBase'
      'core/WindowItemList'
      'core/WindowItemMenu'
      'core/WindowItemTradeActorList'
      'core/WindowItemTradeList'
      'core/WindowItemTargetActorList'
      'core/WindowItemShop'
      'core/WindowCash'
      'core/GamePlayer'
      'core/Interpreter'
      'event_command/Function'
      'event_command/Script'
      'event_command/Return'
      'event_command/Delete'
      'event_command/Character'
      'event_command/Transition'
      'event_command/Wait'
      'event_command/Move'
      'event_command/Message'
      'event_command/Option'
      'event_command/Select'
      'event_command/InputNum'
      'event_command/Flag'
      'event_command/Block'
      'event_command/IfElse'
      'event_command/Loop'
      'event_command/End'
      'event_command/Item'
      'event_command/Shop'
      'event_command/Cash'
      'event_command/Picture'
      'event_command/Animation'
      'core/EventGenerator'
      'scene/SceneBase'
      'scene/SceneLoading3'
      'scene/SceneMain'
      'scene/SceneTitle'
      'scene/SceneMap'
      'scene/SceneMy'
      'scene/SceneMenuTest1'
      'scene/SceneMenuTest2'
      'main'
  ]

  genPath = 'target/generate/'
  
  coffeelintConfig =
    options:
      configFile: 'coffeelint.json'
    all:
      files:
        src: [
          'gruntfile.coffee'
          'src/**/*.coffee'
        ]

  coffeeConfig =
    options:
      bare: false
    client_test:
      expand: true
      cwd: 'src/test/client/'
      src: ['**/*.coffee']
      dest: 'target/public/client/test/'
      ext: '.js'

  watchConfig =
    express:
      files: ['target/**']
      tasks: ['express:dev']
      options:
        nospawn: true
    public:
      files: ['src/**/*.html']
      tasks: ['copy']
    client_test:
      files: ['src/test/client/**.coffee']
      tasks: [
        'coffee:client_test'
      ]
    create_sample:
      files: ['src/main/client/sample/**']
      tasks: ['create_sample']

  simplemochaConfig =
    options:
      reporter: 'nyan'
      ui: 'bdd'
    all:
      src: ['src/test/common/**.coffee']

  for f in common_sections
    js = "#{genPath}#{f}.js"
    coffee = "src/main/#{f}.coffee"
    testcase = "src/test/#{f}Test.coffee"
    coffeeConfig[f] = {}
    coffeeConfig[f].files = {}
    coffeeConfig[f].files[js] = coffee
    watchConfig[f] = {
      files: [coffee,testcase]
      tasks: ['coffeelint',"coffee:#{f}","simplemocha:#{f}",
        'concat','uglify']
    }
    simplemochaConfig[f] = {
      src: [testcase]
    }

  for f in client_sections
    js = "#{genPath}client/#{f}.js"
    coffee = "src/main/client/#{f}.coffee"
    coffeeConfig[f] = {}
    coffeeConfig[f].files = {}
    coffeeConfig[f].files[js] = coffee
    watchConfig[f] = {
      files: [coffee]
      tasks: ['coffeelint',"coffee:#{f}",
        'concat','uglify']
    }

  grunt.initConfig
    coffeelint: coffeelintConfig
    simplemocha: simplemochaConfig
    coffee: coffeeConfig
    watch: watchConfig
    concat:
      options:
        banner: banner
      client_scripts:
        src: [
          (genPath + sec + '.js' for sec in common_sections)
          (genPath + 'client/' + sec + '.js' for sec in client_sections)
        ]
        dest: 'target/public/client/tmlib-rpg.js'
    uglify:
      client_scripts:
        files:
          'target/public/client/tmlib-rpg.min.js': ['target/public/client/tmlib-rpg.js']
    jsdoc:
      dist:
        src: [
          (genPath + sec + '.js' for sec in common_sections)
          (genPath + 'client/' + sec + '.js' for sec in client_sections)
        ]
        options:
          destination: 'doc'
          configure: 'jsdoc.json'
    copy:
      express:
        expand: true
        cwd: 'src/main/express/'
        src: ['**']
        dest: 'target/'
      client_test:
        expand: true
        cwd: 'src/test/public/'
        src: ['**']
        dest: 'target/public/'
      client_demo:
        expand: true
        cwd: 'src/demo/001/img/'
        src: ['**']
        dest: 'target/public/client/img/'
      tmlib_build:
        expand: true
        cwd: '../tmlib.js/build'
        src: ['**']
        dest: 'target/public/client/lib/build'
      bgm:
        expand: true
        cwd: '../bgm'
        src: ['**']
        dest: 'target/public/client/audio/bgm'

    express:
      options:
        background: true
      dev:
        options:
          script: 'target/app.js'

    clean:
      target: ['target','doc']

    execute:
      create_sample:
        options:
          inputDir: './src/main/client/sample'
          outputDir: './target/public/client/data'
        call: (grunt, op) ->
          grunt.file.mkdir(op.outputDir)
          op.src = grunt.file.expand({cwd:op.inputDir},'*/*.coffee')
          op.src.push 'system.coffee'
          rpgc = require './src/main/tools/RPGCompiler'
          rpgc.compile(op)
          return
      makerpg:
        call: (grunt, op) ->
          op.inputDir = grunt.option 'inputDir'
          op.outputDir = grunt.option 'outputDir'
          fs = require 'fs'
          if fs.existsSync(op.inputDir) and fs.existsSync(op.outputDir)
            op.src = grunt.file.expand({cwd:op.inputDir},'*/*.coffee')
            op.src.push 'system.coffee'
            rpgc = require './src/main/tools/RPGCompiler'
            rpgc.compile(op)
          return
      makedemo:
        options:
          inputDir: './src/demo'
          outputDir: './target/public/client'
        call: (grunt, op) ->
          path = require 'path'
          op.inputDir = grunt.option 'inputDir'
          op.outputDir = path.join(op.outputDir,path.basename(op.inputDir))
          grunt.file.mkdir(op.outputDir)
          fs = require 'fs'
          if fs.existsSync(op.inputDir) and fs.existsSync(op.outputDir)
            op.src = grunt.file.expand({cwd:op.inputDir},'*/*.coffee')
            op.src.push 'system.coffee'
            rpgc = require './src/main/tools/RPGCompiler'
            rpgc.compile(op)
          return


  for o of pkg.devDependencies
    grunt.loadNpmTasks o if /grunt-/.test o
  
  grunt.registerTask 'server', ['express:dev', 'watch']
  grunt.registerTask 'test', ['coffeelint','simplemocha:all']
  grunt.registerTask 'create_sample', ['execute:create_sample']
  grunt.registerTask 'makerpg', ['execute:makerpg']
  grunt.registerTask 'makedemo', ['execute:makedemo']
  grunt.registerTask 'doc', ['jsdoc']
  grunt.registerTask 'default', [
    'coffeelint','coffee', 'simplemocha:all'
    'concat', 'uglify', 'copy', 'create_sample'
  ]
  grunt.registerTask 'skiptest', [
    'coffeelint','coffee', 'concat', 'uglify', 'copy', 'create_sample'
  ]
