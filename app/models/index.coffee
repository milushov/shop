"use strict"
fs = require("fs")
path = require("path")
Sequelize = require("sequelize")
basename = path.basename(module.filename)
env = process.env.NODE_ENV or "development"
config = require(__dirname + "/../../config/config.json")[env]

if db_url = process.env.HEROKU_POSTGRESQL_NAVY_URL
  match = db_url.match(/postgres:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/)
  sequelize = new Sequelize(match[5], match[1], match[2],
    dialect: "postgres"
    protocol: "postgres"
    port: match[4]
    host: match[3]
    logging: true
  )
else
  sequelize = new Sequelize(config.database, config.username, config.password, config)

db = {}

fs.readdirSync(__dirname).filter((file) ->
  (file.indexOf(".") isnt 0) and (file isnt basename)
).forEach (file) ->
  model = sequelize["import"](path.join(__dirname, file))
  db[model.name] = model

Object.keys(db).forEach (modelName) ->
  db[modelName].associate db  if "associate" of db[modelName]

db.sequelize = sequelize
db.Sequelize = Sequelize
module.exports = db