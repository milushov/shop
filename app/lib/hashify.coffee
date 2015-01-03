md5 = require('MD5')

exports.hashify = (word) ->
  word = word.split('')
  word = word.map (el) -> el.toLowerCase(el)
  word = word.sort()
  word = word.join('')
  md5(word)
