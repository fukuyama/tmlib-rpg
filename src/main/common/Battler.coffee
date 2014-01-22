
# バトラークラス
#
#　ゲーム内に現れるキャラクターデータのクラス（アクターとエネミーの基底クラス）
#　各キャラクター（アクターとエネミー含む）の基本的な能力を提供する。
#　ゲーム初期状態でのデータは、json で管理（読み込みは外部で…）
#

# node.js と ブラウザでの this.rpg を同じインスタンスにする
_g = window ? global ? @
rpg = _g.rpg = _g.rpg ? {}


# バトラークラス
class rpg.Battler

  constructor: (args={}) ->
    @setup(args)

  setup: (args={}) ->
    {
      @name
      @base
    } = {
      base: {
        str: 10 # ちから
        vit: 10 # たいりょく
        dex: 10 # きようさ
        agi: 10 # すばやさ
        int: 10 # かしこさ
        sen: 10 # かんせい
        luc: 10 # うんのよさ
        cha: 10 # みりょく
        minhp: 10
        minmp: 10
      }
    }.$extendAll(args)
    
    _ability = (nm) ->
      @base[nm]

    for nm of @base
      Object.defineProperty @, nm, get: _ability.bind(@,nm)

    Object.defineProperty @, 'patk',
      get: -> Math.floor(@str + @dex / 2)
    Object.defineProperty @, 'pdef',
      get: -> Math.floor(@vit + @agi / 2)
    Object.defineProperty @, 'matk',
      get: -> Math.floor(@int + @sen / 2)
    Object.defineProperty @, 'mcur',
      get: -> Math.floor(@sen + @int / 2)
    Object.defineProperty @, 'mdef',
      get: -> Math.floor(@luc / 2 + @sen / 2 + @int / 2)

    Object.defineProperty @, 'maxhp',
      get: -> Math.floor(@minhp + @vit + @str / 2 + @luc / 2)
    Object.defineProperty @, 'maxmp',
      get: -> Math.floor(@minmp + @int / 2 + @sen / 2 + @luc / 2)
