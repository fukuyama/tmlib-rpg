
require('chai').should()

require('../../main/common/utils.coffee')
require('../../main/common/Flag.coffee')

describe 'rpg.Flag', ->

  describe '初期化', ->
    flag = new rpg.Flag()
    it 'default　の url は、http://localhost:3000/', ->
      flag.url.should.equal 'http://localhost:3000/'

  describe 'フラグ操作', ->
    flag = new rpg.Flag()
    it '初期値は、0', ->
      (flag.get 'test').should.equal 0
    it 'test を on にする', ->
      flag.on 'test'
    it 'test の値は、1 になる', ->
      (flag.get 'test').should.equal 1
    it 'test を off にする', ->
      flag.off 'test'
    it 'test の値は、0 になる', ->
      (flag.get 'test').should.equal 0
    it 'test を off にする。２回目', ->
      flag.off 'test'
    it 'test の値は、0 のまま', ->
      (flag.get 'test').should.equal 0
    it 'test を is メソッド確認 test の値は 0 なので　false', ->
      (flag.is 'test').should.equal false
    it 'test を is メソッド確認 test を on にすると true', ->
      flag.on 'test'
      (flag.is 'test').should.equal true
    it 'test を is メソッド確認 test を off にすると false', ->
      flag.off 'test'
      (flag.is 'test').should.equal false
    it 'test の実際の値を取得すると 0', ->
      (flag.get 'test').should.equal 0
    it 'test に 1 を設定', ->
      flag.set 'test', 1
    it 'test の実際の値を取得すると 1', ->
      (flag.get 'test').should.equal 1
    it 'test に 2 を設定', ->
      flag.set 'test', 2
    it 'test の実際の値を取得すると 2', ->
      (flag.get 'test').should.equal 2
    it 'test を is メソッドで確認すると　true', ->
      (flag.is 'test').should.equal true
    it 'test を on にしてから値を確認すると 2 のまま', ->
      flag.on 'test'
      (flag.get 'test').should.equal 2
    it 'test を off にしてから値を確認すると 0 になる', ->
      flag.off 'test'
      (flag.get 'test').should.equal 0

    it 'test に 10 を足す', ->
      (flag.get 'test').should.equal 0
      flag.plus 'test', 10
      (flag.get 'test').should.equal 10
    it 'test に 11 を足す', ->
      flag.plus 'test', 11
      (flag.get 'test').should.equal 21
    it 'test から 5 を引く', ->
      flag.minus 'test', 5
      (flag.get 'test').should.equal 16
    it 'test を 3 倍にする', ->
      flag.multi 'test', 3
      (flag.get 'test').should.equal 16 * 3
    it 'test を 2 で割る', ->
      flag.div 'test', 2
      (flag.get 'test').should.equal 16 * 3 / 2
    it 'test を 0 で割る、値は変わらない', ->
      flag.div 'test', 0
      (flag.get 'test').should.equal 16 * 3 / 2
    it 'test に"TEST"を設定 -> error になる', ->
      test = false
      flag.set 'test', 0
      try
        flag.set 'test', 'TEST'
      catch error
        error.name.should.equal 'Error'
        test = true
      test.should.equal true

    it '他のサイトのフラグを取得 http://hoehoe/ の test を取得 true', ->
      flag = new rpg.Flag({
        values: {
          'http://hoehoe/': {
            'test': 1
          }
        }
      })
      (flag.is 'test', 'http://hoehoe/').should.equal true
    it 'ローカルの test は false', ->
      (flag.is 'test').should.equal false
    it '別のサイトの test は false', ->
      (flag.is 'test','http://err').should.equal false
    it 'http://hoehoe/ の test1 は false', ->
      (flag.is 'test1','http://hoehoe/').should.equal false
    it 'null の url を指定すると、ローカルを取る', ->
      flag.get('local_flg1').should.equal 0
      flag.on 'local_flg1'
      flag.get('local_flg1',null).should.equal 1

    it '存在確認', ->
      (flag.exist 'flgX').should.equal false
      flag.on 'flgX'
      (flag.exist 'flgX').should.equal true
