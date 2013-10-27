
#  foo.should.be.a('string');
#  foo.should.equal('bar');
#  foo.should.have.length(3);
#  tea.should.have.property('flavors').with.length(3);

require('chai').should()

require('../../main/common/utils.coffee')

describe 'utils', () ->
  describe '$extendAll', () ->
    it 'init', ->
      h = {}
      a = {}
      h.$extendAll a
      c = 0
      c++ for i of h
      c.should.equal 0
    it 'level 1', ->
      h = {}
      a = {name:'test'}
      h.$extendAll a
      c = 0
      c++ for i of h
      c.should.equal 1
      h.name.should.equal 'test'
    it 'level 2', ->
      h = {src:{i:11,l:20}}
      a = {name:'test',src:{i:10}}
      h.src.i.should.equal 11
      h.src.l.should.equal 20
      h.$extendAll a
      c = 0
      c++ for i of h
      c.should.equal 2
      h.name.should.equal 'test'
      h.src.i.should.equal 10
      h.src.l.should.equal 20
    it 'level 3', ->
      h = {}
      a = {name:'test',src:{i:10}}
      b = {src:{i:11,l:20}}
      b.src.i.should.equal 11
      b.src.l.should.equal 20
      h.$extendAll b
      h.$extendAll a
      b.src.i.should.equal 11
      b.src.l.should.equal 20
      c = 0
      c++ for i of h
      c.should.equal 2
      h.name.should.equal 'test'
      h.src.i.should.equal 10
      h.src.l.should.equal 20
    it 'array 1', ->
      h = {list:[1,2]}
      a = {}.$extendAll h
      h.list.should.deep.equal [1,2]
      a.list.should.be.a 'array'
      a.list.push 3
      a.list.should.deep.equal [1,2,3]
      h.list.should.deep.equal [1,2]
    it 'array 2', ->
      h = {list:[
        {a:1,b:2}
        {a:3,b:4}
      ]}
      a = {}.$extendAll h
      h.list.should.deep.equal [{a:1,b:2},{a:3,b:4}]
      a.list.should.be.a 'array'
      a.list.push {a:5,b:5}
      a.list[0].a = 5
      a.list.should.deep.equal [{a:5,b:2},{a:3,b:4},{a:5,b:5}]
      h.list.should.deep.equal [{a:1,b:2},{a:3,b:4}]
    it 'array 3', ->
      h = {
        list: [
          [1,2,3]
          [4,5,6]
        ]
      }
      a = {}.$extendAll h
      a.should.deep.equal {list:[[1,2,3],[4,5,6]]}
