# product list
exports.list = (req, res, next) ->
  db = req.app.get('db')
  db.Product.findAll().then (products) ->
    res.render 'list', products: products[0..24]

# product page
exports.show = (req, res, next) ->
  res.send('product ' + req.params.product_id)
