async             = require('async')
db                = require('./app/models')
md5               = require('MD5')
uniqWords         = []


db.sequelize.sync()
  .then ->
    db.Dictionary.drop()

  .then ->
    db.Dictionary.sync()

  .then ->
    db.Product.findAll()

  .then (products) ->
    for product in products
      _words = product.name.split(' ')

      for _word in _words[0..100]
        _word = _word.trim()
        _word = _word.replace(/[\(\),\.\!&]/g, '')

        if !~uniqWords.indexOf(_word) && !parseInt(_word) > 0 && _word.length >= 2
          uniqWords.push(_word)

    for word in uniqWords
      _word = word.split('')
      _word = _word.map (el) -> el.toLowerCase(el)
      _word = _word.sort()
      _word = _word.join('')
      hash = md5(_word)

      db.Dictionary.create(word: word, hash: hash, popularity: 1)
