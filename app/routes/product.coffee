exports.routes = (app, obj) ->

  dispatcher = (req, res, next) ->

    if req.param('q')
      req.filter = 'search'
      obj.search(req, res, next)

    else if req.param('category_id')
      req.filter = 'byCategory'
      obj.byCategory(req, res, next)

    else if req.param('merchant_id')
      req.filter = 'byMerchant'
      obj.byMerchant(req, res, next)
    else
      req.filter = 'list'
      next()

  app.get '/products', dispatcher, obj.paginate, obj.list

  app.get '/products/:product_id', obj.show

  app
