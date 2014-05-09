
# アクタークラス
#

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# アクタークラス
class rpg.Actor extends rpg.Battler

  # 初期化
  constructor: (args={}) ->
    super(args)
    @addProperties('job', '（なし）')
    @addProperties('subjob', '（なし）')
    @addProperties('sex', '？？？')
    {
      @job
      @subjob
      @sex
      backpack
    } = {
      backpack: {
        max:8
        stack:on
      }
    }.$extendAll(@properties).$extendAll(args)
    # バックパック作成
    @backpack = new rpg.Item(name:'バックパック',container:backpack)

  # 使う
  useItem: (item, target) ->
    super(item, target)
    if item.isLost()
      @backpack.removeItem item
