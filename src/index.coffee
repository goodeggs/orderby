module.exports = (collection, expressions) ->
  collection.sort (a, b) ->
    for expression in expressions
      if typeof expression is 'object'
        predicate = expression.predicate
        reverse = expression.reverse
      else
        predicate = expression

      value = compareProperty(predicate, reverse)(a,b)
      unless value is 0
        return value

dot =
  get: (obj, field) ->
    keys = field.split('.')
    value = obj
    for key in keys
      value = value[key]
    value

  set: (obj, field, setValue) ->
    keys = field.split('.')
    allButLastKey = keys[0...-1]
    lastKey = keys[keys.length - 1]
    value = obj
    for key in allButLastKey
      value = value[key] ?= {}
    value[lastKey] = setValue

compareProperty = (predicate, reverse) ->
  getter =
    if typeof predicate is 'function'
      (obj) ->
        predicate(obj)
    else
      (obj) ->
        dot.get(obj, predicate)

  getter

  if not reverse
    (a, b) ->
      if getter(a) < getter(b)
        -1
      else if getter(a) > getter(b)
        1
      else
        0
  else
    (a, b) ->
      if getter(a) > getter(b)
        -1
      else if getter(a) < getter(b)
        1
      else
        0


