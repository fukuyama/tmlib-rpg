
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

    # it '他のサイトのフラグを取得 http://hoehoe/ の test'
    #  flag.on 'test', 'http://hoehoe/'
