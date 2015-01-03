hashify = require('../../lib/hashify').hashify
extend  = require('extend')

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


# product list
exports.list = (req, res, next) ->
  db    = req.app.get('db')
  query = res.locals.corrected_q || res.locals.q
  prms  = {
    where:   ['name like ?', "%#{query}%"]
    offset:  req.offset
    limit:   req.limit
    include: [db.Category]
  }

  db.Product.findAll(prms).then (products) ->
    res.render 'list', products: products


# product page
exports.show = (req, res, next) ->
  res.send('product ' + req.params.product_id)


# pagination middleware
exports.paginate = (req, res, next) ->
  curPage = parseInt(req.param('page')) || 1
  perPage = req.app.get('perPage')
  db      = req.app.get('db')
  query   = res.locals.corrected_q || res.locals.q

  db.Product.count(where: ['name like ?', "%#{query}%"]).then (count) ->
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
      pagesNumbers: pagesNumbers
    }

    extend(false, res.locals, pagination)

    req.offset = offset
    req.limit  = perPage

    next()
