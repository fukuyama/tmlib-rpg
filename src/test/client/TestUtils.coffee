_g = window ? global ? @

# メッセージ表示したつもり関数
_g.message_clear = ->
  rpg.system.temp.message = null
  if rpg.system.temp.messageEndProc?
    rpg.system.temp.messageEndProc()
  rpg.system.temp.messageEndProc = null

# キー操作エミュレーション
_g.emulate_key = (key,callback) ->
  setTimeout(->
    rpg.system.app.keyboard.setKey(key,true)
  150)
  setTimeout(->
    rpg.system.app.keyboard.setKey(key,false)
  300)
  setTimeout(->
    callback()
  400)
loadFlg = false
# テスト用マップロード
_g.loadTestMap = (done) ->
  if loadFlg
    done()
    return
  loadFlg = true
  rpg.system.newGame()
  check = ->
    unless rpg.system.scene.name == 'SceneMap'
      setTimeout(check,100)
    else
      done()
  check()
