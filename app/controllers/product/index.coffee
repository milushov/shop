hashify = require('../../lib/hashify').hashify
extend  = require('extend')

exports.customController = yes

# product page
exports.show = (req, res, next) ->
  db  = req.app.get('db')
  pid = req.params.product_id

  # find wih include params doesn't working :-(
  prms = {
    where: id: pid
    limit: 1
    include: [db.Category, db.Merchant]
  }
  db.Product.findAll(prms).then (products) ->
    res.render 'show', product: products[0]



# product list
exports.list = (req, res, next) ->
  db    = req.app.get('db')
  query = res.locals.corrected_q || res.locals.q
  prms  = {
    where:   whereCond(req, query)
    offset:  req.offset
    limit:   req.limit
    include: [db.Category, db.Merchant]
  }

  fetcher = if req.filter is 'byCategory'
    res.locals.category.getProducts(prms)
  else
    db.Product.findAll(prms)

  fetcher.then (products) ->
    _products = []
    while(products.length)
      _products.push(products.splice(0,4))
    res.render req.filter, products: _products


exports.search = (req, res, next) ->
  db = req.app.get('db')
  res.locals.q = q = req.param('q') || ''

  if q
    db.Product.count(where: ['name like ?', "%#{q}%"]).then (count) ->
      if !count
        db.Dictionary.findAll(where: hash: hashify(q)).then (words) ->
          if words.length
            res.locals.corrected_q = words[0].word
            next()
          else
            next()
      else
        next()
  else
    next()


exports.byCategory = (req, res, next) ->
  db = req.app.get('db')
  cid = req.param('category_id') 
  db.Category.find(cid).then (category) ->
    res.locals.category = category
    next()


exports.byMerchant = (req, res, next) ->
  db = req.app.get('db')
  mid = req.param('merchant_id') 
  db.Merchant.find(mid).then (merchant) ->
    res.locals.merchant = merchant
    next()


# pagination middleware
exports.paginate = (req, res, next) ->
  curPage = parseInt(req.param('page')) || 1
  perPage = req.app.get('perPage')
  db      = req.app.get('db')
  query   = res.locals.corrected_q || res.locals.q

  # fuck you, sequelize
  fetcher = if req.filter is 'byCategory'
    res.locals.category.getProducts()
  else
    db.Product.count(where: whereCond(req))

  fetcher.then (data) ->
    count = data.length || data

    lastPage    = Math.round(count/perPage)
    isLastPage  = curPage >= lastPage
    prevPage    = unless curPage is 1 then curPage - 1
    nextPage    = unless isLastPage then curPage + 1
    offset      = perPage * (curPage - 1)
    outerWindow = Math.min(lastPage/2, 4)

    pagesNumbers = if curPage <= outerWindow
      [1..(outerWindow*2+1)]
    else if curPage >= lastPage - outerWindow
      start = lastPage - outerWindow*2+1
      [start..lastPage]
    else
      left = [(curPage - outerWindow)...curPage]
      right = [curPage..(curPage + outerWindow)]
      left.concat(right)

    pagination = {
      curPage:      curPage
      prevPage:     prevPage
      nextPage:     nextPage
      pagesNumbers: if count > perPage then pagesNumbers
    }

    extend(false, res.locals, pagination)

    req.offset = offset
    req.limit  = perPage

    next()


# just helper
whereCond = (req, q) ->
  if req.filter is 'search'
    query = q || req.param('q')
    ['name like ?', "%#{query}%"]
  else if req.filter is 'byMerchant'
    merchantId: req.param('merchant_id')


