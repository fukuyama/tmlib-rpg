
# 戦闘シーン
tm.define 'SceneBattle',

  superClass: rpg.SceneBase

  ###* 初期化
  * @classdesc 戦闘シーンクラス
  * @constructor rpg.SceneBattle
  * @param {Object} args
  * @param {rpg.Map} args.map マップオブジェクト
  *                  事前に読み込む物があるのでStringでは無理
  ###
  init: (args={}) ->
    # 親の初期化
    @superInit(name:'SceneBattle')
