exports.show = (req, res, next) ->
  cid = req.params.category_id

  curPage = parseInt(req.param('page')) || 1
  perPage = req.app.get('perPage')
  db      = req.app.get('db')

  db.Product.count().then (count) ->
    lastPage    = Math.round(count/perPage)
    isLastPage  = curPage >= lastPage
    prevPage    = unless curPage is 1 then curPage - 1
    nextPage    = unless isLastPage then curPage + 1
    offset      = perPage * (curPage - 1)
    outerWindow = 4

    pagesNumbers = if curPage <= outerWindow
      [1..(outerWindow*2+1)]
    else if curPage >= lastPage - outerWindow
      start = lastPage - outerWindow*2+1
      [start..lastPage]
    else
      left = [(curPage - outerWindow)...curPage]
      right = [curPage..(curPage + outerWindow)]
      left.concat(right)

    db.Category.find(cid).then (category) ->
      category.getProducts().then (products) ->
        res.render 'show', {
          products:     products
          curPage:      curPage
          prevPage:     prevPage
          nextPage:     nextPage
          pagesNumbers: pagesNumbers
        }
