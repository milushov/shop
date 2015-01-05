express     = require('express')
db          = require('./models')
extend      = require('extend')
app         = module.exports = express()
viewHelpers = require('./lib/view_helpers').helpers

app.use (req, res, next) ->
  extend(false, res.locals, viewHelpers(req)) && next()
  res.locals.isDev = !process.env.PORT?

port = if process.env.PORT
  process.env.PORT
else if process.env.NODE_ENV is 'test'
  3001
else
  3000

app.set('port', port)
app.set('db', db)
app.set('perPage', 12)
app.set('view engine', 'jade')
app.set('views', __dirname + '/views')
app.locals.pretty = true
app.use(express.static(__dirname + '/public'))

# load controllers
require('./lib/load_controllers')(app, verbose: no)

app.use (err, req, res, next) ->
  console.error(err.stack)
  res.status(500).render '5xx'

# assume 404 since no middleware responded
app.use (req, res, next) ->
  res.status(404).render '404', url: req.originalUrl

unless module.parent
  db.sequelize.sync().then ->
    app.listen app.get('port'), ->
      console.log "Node app is running at localhost: #{app.get('port')}"
