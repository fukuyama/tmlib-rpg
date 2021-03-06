###*
* @file Actor.coffee
* アクタークラス
###

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# アクタークラス
class rpg.Actor extends rpg.Battler
  ###* 職業
  * @var {String} rpg.Actor#job
  ###
  ###* サブ職業
  * @var {String} rpg.Actor#subjob
  ###
  ###* 性別
  * @var {String} rpg.Actor#sex
  ###
  ###* バックパック
  * @var {rpg.Item} rpg.Actor#backpack
  ###

  ###*
  * コンストラクタ
  * @classdesc アクタークラス
  * @constructor rpg.Actor
  * @extends rpg.Battler
  * @param {Object} args
  ###
  constructor: (args={}) ->
    super(args)
    @addProperties('job', '（なし）')
    @addProperties('subjob', '（なし）')
    @addProperties('sex', '？？？')
    {
      @job
      @subjob
      @sex
      @backpack
    } = {
      backpack: {
        max: 20
        stack: on
      }
    }.$extendAll(@properties).$extendAll(args)
    # バックパック作成
    unless @backpack instanceof rpg.Item
      @backpack = new rpg.Item(name:'バックパック',container:@backpack)

  ###* アイテムを使う
  * @method rpg.Actor#useItem
  * @param {rpg.Item} item 使用するアイテム
  * @param {rpg.Battler} [target] 使用する対象
  ###
  useItem: (item, target, log={}) ->
    r = super(item, target, log)
    if item.isLost()
      @backpack.removeItem item
    r

  ###* アクターの自動戦闘
  * 行動不能でステートによるＡＩがある場合（混乱や魅了など）
  * 作戦で、自動設定されている場合
  * このメソッドでアクションを作成して返す。
  ###
  makeAction: (args) ->
    action = {}
    return action

  ###* 戦闘コマンドが入力可能か？
  * @method rpg.Actor#isActionInput
  * @return {boolean} 入力可能ならtrue
  ###
  isActionInput: ->
    return true
