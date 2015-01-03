db         = require('./app/models')
categories = null

db.sequelize.sync()
.then ->
  db.Category.findAll()
.then (cats) ->
  categories = cats
  db.Product.findAll()
.then (products) ->
  # fuck the perfomance
  for prod in products




