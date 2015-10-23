
fs = require 'fs'

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = global ? @
rpg = _g.rpg = _g.rpg ? {}

top_dir = '../../../'

class rpg.System
  constructor: ->
    @db = new rpg.DataBase()

class rpg.DataBase
  constructor: (args={}) ->
    {
      @basedir
      @idformat
    } = {
      basedir: 'src/data/test/'
      idformat: '000'
    }.$extendAll args

  ###* ファイル名の作成
  * @memberof rpg.DataBase#
  * @param {String|Number} val
  * @return {String} データのファイル名
  * @private
  ###
  _filename: (val) ->
    if typeof val is 'number'
      val = val.formatString @idformat
    val

  _loadSkillList: (cb) ->
    if @_skillist?
      cb @_skillist
    else
      fs.readdir @basedir + 'skill', ((err, files) ->
        if err?
          throw err
          return
        @_skillist = []
        for file in files
          skill = new rpg.Skill require top_dir + @basedir + 'skill/' + file
          i = parseInt file.replace(/\..*$/, ''), 10
          @_skillist[i] = skill
        for data in require top_dir + @basedir + 'skilllist.coffee'
          skill = new rpg.Skill data
          i = parseInt data.skill,10
          @_skillist[i] = skill
        cb @_skillist
      ).bind @

  preloadSkill: (ids,cb) ->
    @_loadSkillList (skills) ->
      ret = []
      for id in ids
        ret.push skills[id]
      cb ret
    
rpg.system = new rpg.System()

