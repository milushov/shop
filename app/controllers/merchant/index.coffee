exports.list = (req, res, next) ->
  db = req.app.get('db')
  db.Merchant.findAll().then (merchants) ->
    res.render 'list', items: merchants
