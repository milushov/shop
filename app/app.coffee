express = require('express')
app     = express()
db = require('./models')

app.set('port', (process.env.PORT || 3000))
app.set('db', db)

app.set('view engine', 'jade')
app.set('views', __dirname + '/views')
app.locals.pretty = true
app.use(express.static(__dirname + '/public'))

# load controllers
require('./lib/load_controllers')(app, { verbose: !module.parent })


app.use (err, req, res, next) ->
  console.error(err.stack)
  res.status(500).render '5xx'

# assume 404 since no middleware responded
app.use (req, res, next) ->
  res.status(404).render '404', url: req.originalUrl

db.sequelize.sync().then ->
  app.listen app.get('port'), ->
    console.log "Node app is running at localhost: #{app.get('port')}"

