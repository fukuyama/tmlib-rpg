
# tmlib-rpg gruntfile
module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'

  # 共通系のスクリプト(tmlib.js 非依存のつもり)
  common_sections = [
      'common/utils'
      'common/Character'
      'common/Map'
      'common/Flag'
      'common/Event'
      'common/EventPage'
  ]
  # クライアントのスクリプト
  client_sections = [
      'sample'
      'tmlib/CustomizeTexture'
      'core/System'
      'core/SpriteCharacter'
      'core/SpriteCursor'
      'core/SpriteMap'
      'core/EventHandler'
      'core/WindowSkin'
      'core/WindowContent'
      'core/Window'
      'core/WindowMenu'
      'core/WindowMessage'
      'core/WindowMapMenu'
      'core/GamePlayer'
      'core/Interpreter'
      'scene/SceneBase'
      'scene/SceneLoading'
      'scene/SceneMain'
      'scene/SceneTitle'
      'scene/SceneMap'
      'scene/SceneMenuTest1'
      'scene/SceneMenuTest2'
      'main'
  ]

  genPath = 'target/generate/'
  
  coffeeConfig =
    options:
      bare: false
    test_client:
      expand: true
      cwd: 'src/test/client/'
      src: ['**.coffee']
      dest: 'target/public/client/test/'
      ext: '.js'

  watchConfig =
    express:
      files: ['target/**']
      tasks: ['express:dev']
      options:
        spawn: false
    public:
      files: ['src/**/*.html']
      tasks: ['copy']
    test_scripts:
      files: ['src/test/common/**.coffee']
      tasks: [
        'coffeelint', 'simplemocha'
      ]
    test_client:
      files: ['src/test/client/**.coffee']
      tasks: [
        'coffee:test_client'
      ]

  for f in common_sections
    js = "#{genPath}#{f}.js"
    coffee = "src/main/#{f}.coffee"
    coffeeConfig[f] = {}
    coffeeConfig[f].files = {}
    coffeeConfig[f].files[js] = coffee
    watchConfig[f] = {
      files: [coffee]
      tasks: ['coffeelint',"coffee:#{f}",'simplemocha','concat','uglify']
    }

  for f in client_sections
    js = "#{genPath}client/#{f}.js"
    coffee = "src/main/client/#{f}.coffee"
    coffeeConfig[f] = {}
    coffeeConfig[f].files = {}
    coffeeConfig[f].files[js] = coffee
    watchConfig[f] = {
      files: [coffee]
      tasks: ['coffeelint',"coffee:#{f}",'simplemocha','concat','uglify']
    }

  grunt.initConfig
    coffeelint:
      all:
        files:
          src: [
            'gruntfile.coffee'
            'src/**/*.coffee'
          ]
    simplemocha:
      options:
        reporter: 'nyan'
        ui: 'bdd'
      all:
        src: ['src/test/common/**.coffee']
    coffee: coffeeConfig
    concat:
      options:
        separator: ';'
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

    copy:
      express:
        expand: true
        cwd: 'src/main/express/'
        src: ['**']
        dest: 'target/'
      test_client:
        expand: true
        cwd: 'src/test/public/'
        src: ['**']
        dest: 'target/public/'

    express:
      options:
        background: true
      dev:
        options:
          script: 'target/app.js'

    clean:
      target: ['target']

    watch: watchConfig

  for o of pkg.devDependencies
    grunt.loadNpmTasks o if /grunt-/.test o
  
  grunt.registerTask 'server', ['express:dev', 'watch']
  grunt.registerTask 'test', ['coffeelint','simplemocha']
  grunt.registerTask 'default', [
    'coffeelint','coffee', 'simplemocha'
    'concat', 'uglify', 'copy'
  ]
