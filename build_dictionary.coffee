async     = require('async')
db        = require('./app/models')
uniqWords = []
hashify   = require('./app/lib/hashify').hashify


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

      for _word in _words
        _word = _word.trim()
        _word = _word.replace(/[\(\),\.\!&]/g, '')

        if !~uniqWords.indexOf(_word) && !parseInt(_word) > 0 && _word.length >= 2
          uniqWords.push(_word)

    for word in uniqWords
      db.Dictionary.create(word: word, hash: hashify(word), popularity: 1)
