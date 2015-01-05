db = require('../app/models')

module.exports = (app) ->

  before ->
    db.sequelize.sync().then ->
      app.listen app.get('port'), ->
        console.log "Node app is running at localhost: #{app.get('port')}"

  after ->
    # FUCK YOU
    app.close()

