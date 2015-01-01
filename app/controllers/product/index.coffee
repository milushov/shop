# product list
exports.list = (req, res, next) ->
  res.render 'list'

# product page
exports.show = (req, res, next) ->
  res.send('product ' + req.params.product_id)
