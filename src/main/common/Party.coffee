
# パーティクラス
#
# パーティメンバーを管理する。
#

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}

# パーティクラス
class rpg.Party

  # コンストラクタ
  constructor: ->
    # メンバーリスト（プライベートぽくしたいけれど…）
    @_members = []

    # パーティ用バックパック作成
    @backpack = new rpg.Item(name:'バックパック',container:{stack:on})

    # メンバー数
    Object.defineProperty @, 'length',
      enumerable: false
      get: -> @_members.length

  # メンバー追加
  add: (actor) ->
    @_members.push actor

  # メンバー削除
  remove: (actor) ->
    @_members.splice(@_members.indexOf(actor),1)

  # メンバー取得
  getAt: (i) ->
    @_members[i]

  # リスト処理
  each: (f) ->
    f.call(null,a) for a in @_members

  # パーティへアイテム追加
  addItem: (item) ->
    # パーティの誰かにアイテムを追加
    for a in @_members
      if a.backpack.addItem(item)
        return true
    # だれにも追加できない場合は、パーティ用のバックパックへ
    @backpack.addItem(item)

  # パーティのアイテム削除
  removeItem: (item) ->
    # パーティの誰かのアイテムを削除
    for a in @_members
      if a.backpack.removeItem(item)
        return true
    # だれも削除できない場合は、パーティ用のバックパックへ
    @backpack.removeItem(item)

  # パーティからアイテムの取得
  getItem: (nameOrId) ->
    # パーティの誰からアイテムを取得
    for a in @_members
      item = a.backpack.getItem(nameOrId)
      return item if item?
    # だれも持ってない場合は、パーティ用バックパックから取得
    @backpack.getItem(nameOrId)
