require 'mocha-sinon'
expect = require('chai').expect

orderBy = require '..'

describe 'orderBy', ->
  it 'sorts by a single property', ->
    array = [
      {name: 'Michael'}
      {name: 'Ben'}
      {name: 'Danny'}
      {name: 'Max'}
    ]

    sorted = orderBy array, ['name']
    expect(sorted).to.deep.equal [
      {name: 'Ben'}
      {name: 'Danny'}
      {name: 'Max'}
      {name: 'Michael'}
    ]

  it 'sorts by multiple properties', ->
    array = [
      {age: 100 , name: 'Michael'}
      {age: 25 , name: 'Ben'}
      {age: 100, name: 'Danny'}
      {age: 25, name: 'Max'}
    ]

    sorted = orderBy array, ['age', 'name']
    expect(sorted).to.deep.equal [
      {age: 25 , name: 'Ben'}
      {age: 25, name: 'Max'}
      {age: 100, name: 'Danny'}
      {age: 100 , name: 'Michael'}
    ]

  it 'sorts by getters', ->
    array = [
      {age: 100 , name: 'Michael'}
      {age: 25 , name: 'Ben'}
      {age: 100, name: 'Danny'}
      {age: 25, name: 'Max'}
    ]

    sorted = orderBy array, [((obj) -> obj.age), 'name']
    expect(sorted).to.deep.equal [
      {age: 25 , name: 'Ben'}
      {age: 25, name: 'Max'}
      {age: 100, name: 'Danny'}
      {age: 100 , name: 'Michael'}
    ]

  it 'sorts by nested properties', ->
    array = [
      {customer: name: 'Michael'}
      {customer: name: 'Ben'}
      {customer: name: 'Danny'}
      {customer: name: 'Max'}
    ]

    sorted = orderBy array, ['customer.name']
    expect(sorted).to.deep.equal [
      {customer: name: 'Ben'}
      {customer: name: 'Danny'}
      {customer: name: 'Max'}
      {customer: name: 'Michael'}
    ]

  it 'allows reversing individual properties', ->
    array = [
      {age: 100 , name: 'Michael'}
      {age: 25 , name: 'Ben'}
      {age: 100, name: 'Danny'}
      {age: 25, name: 'Max'}
    ]

    sorted = orderBy array, [{predicate: 'age', reverse: false}, {predicate: 'name', reverse: true}]
    expect(sorted).to.deep.equal [
      {age: 25, name: 'Max'}
      {age: 25 , name: 'Ben'}
      {age: 100 , name: 'Michael'}
      {age: 100, name: 'Danny'}
    ]

    sorted = orderBy array, [{predicate: 'age', reverse: true}, {predicate: 'name', reverse: false}]
    expect(sorted).to.deep.equal [
      {age: 100, name: 'Danny'}
      {age: 100 , name: 'Michael'}
      {age: 25 , name: 'Ben'}
      {age: 25, name: 'Max'}
    ]

    # with a getter
    sorted = orderBy array, [{predicate: ((obj) -> obj.age), reverse: true}, {predicate: 'name', reverse: false}]
    expect(sorted).to.deep.equal [
      {age: 100, name: 'Danny'}
      {age: 100 , name: 'Michael'}
      {age: 25 , name: 'Ben'}
      {age: 25, name: 'Max'}
    ]
