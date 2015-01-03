exports.list = (req, res, next) ->
  db = req.app.get('db')
  db.Category.findAll().then (categories) ->
    res.render 'list', items: categories
