# product list
exports.list = (req, res, next) ->
  db = req.app.get('db')
  db.Product.findAll().then (products) ->
    #res.render 'list', products: products
    #cats = products[0].getCategories()
    #console.info(cats)

    res.render 'list', products: []
    console.info('-----------------------------------------')
    console.info(products[0].getTasks({})[0])
    console.info('-----------------------------------------')

# product page
exports.show = (req, res, next) ->
  res.send('product ' + req.params.product_id)
