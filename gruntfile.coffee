
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
      'common/State'
      'common/MarkupText'
  ]
  # クライアントのスクリプト
  client_sections = [
      'sample'
      'tmlib/CustomizeTexture'
      'core/DataBase'
      'core/System'
      'core/SpriteCharacter'
      'core/SpriteCursor'
      'core/SpriteMap'
      'core/EventHandler'
      'core/WindowSkin'
      'core/WindowContent'
      'core/Window'
      'core/WindowMenu'
      'core/WindowInputNum'
      'core/WindowMessage'
      'core/WindowMapMenu'
      'core/WindowOperation'
      'core/WindowMemberBase'
      'core/WindowStatusActorList'
      'core/WindowStatusInfo'
      'core/WindowItemList'
      'core/WindowItemActorList'
      'core/GamePlayer'
      'core/Interpreter'
      'event_command/Function'
      'event_command/Script'
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
      'scene/SceneBase'
      'scene/SceneLoading2'
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
        dest: 'target/public/client/main.js'
    uglify:
      client_scripts:
        files:
          'target/public/client/main.min.js': ['target/public/client/main.js']
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
      tmlib_build:
        expand: true
        cwd: '../tmlib.js/build'
        src: ['**']
        dest: 'target/public/client/lib/build'

    express:
      options:
        background: true
      dev:
        options:
          script: 'target/app.js'

    clean:
      target: ['target','doc']

    execute:
      call_sample:
        call: (grunt, op) ->
          grunt.log.writeln('Hello!')

    exec:
      create_sample:
        cmd: 'coffee src/main/client/sample/sample.coffee'


  for o of pkg.devDependencies
    grunt.loadNpmTasks o if /grunt-/.test o
  
  grunt.registerTask 'server', ['express:dev', 'watch']
  grunt.registerTask 'test', ['coffeelint','simplemocha:all']
  grunt.registerTask 'sample', ['exec:create_sample']
  grunt.registerTask 'doc', ['jsdoc']
  grunt.registerTask 'default', [
    'coffeelint','coffee', 'simplemocha:all'
    'concat', 'uglify', 'copy', 'exec:create_sample'
  ]
  grunt.registerTask 'skiptest', [
    'coffeelint','coffee', 'concat', 'uglify', 'copy', 'exec:create_sample'
  ]
