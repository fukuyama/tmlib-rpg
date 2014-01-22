
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
    # プライベート的にしてみた。
    _members = []

    # メンバー数
    Object.defineProperty @, 'length',
      get: -> _members.length
    # メンバー追加
    @_add = (actor) ->
      _members.push actor
    # メンバー削除
    @_remove = (actor) ->
      _members.splice(_members.indexOf(actor),1)
    # メンバー取得
    @_getAt = (i) ->
      _members[i]
    # リスト処理
    @_each = (f) ->
      f.call(null,a) for a in _members

  # メンバー追加
  add: (actor) -> @_add actor
  # メンバー削除
  remove: (actor) -> @_remove actor
  # メンバー取得
  getAt: (i) -> @_getAt i
  # リスト処理
  each: (f) -> @_each f
