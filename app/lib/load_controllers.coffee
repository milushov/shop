###*
Module dependencies.
###
express = require('../../node_modules/express/lib/express')
fs = require('fs')

module.exports = (parent, options) ->
  verbose = options.verbose
  fs.readdirSync("#{__dirname}/../controllers").forEach (name) ->
    verbose && console.log('\n   %s:', name)
    obj = require("../controllers/#{name}")
    name = obj.name or name
    prefix = obj.prefix or ''
    app = express()

    # allow specifying the view engine
    app.set 'view engine', obj.engine  if obj.engine
    app.set 'views', __dirname + '/../views/' + name
    console.info(app.get('views'))

    # generate routes based
    # on the exported methods
    for key of obj

      # 'reserved' exports
      continue  if ~['name', 'prefix', 'engine', 'before'].indexOf(key)

      # route exports
      switch key
        when 'show'
          method = 'get'
          path = "/#{name}s/:#{name}_id"
        when 'list'
          method = 'get'
          path = "/#{name}s"
        when 'edit'
          method = 'get'
          path = "/#{name}s/:#{name}_id/edit"
        when 'update'
          method = 'put'
          path = "/#{name}s/:#{name}_id"
        when 'create'
          method = 'post'
          path = "/#{name}s"
        when 'index'
          method = 'get'
          path = '/'
        else

          # istanbul ignore next 
          throw new Error('unrecognized route: ' + name + '.' + key)

      # setup
      handler = obj[key]
      path = prefix + path

      # before middleware support
      if obj.before
        app[method] path, obj.before, handler
        verbose and console.log('     %s %s -> before -> %s', method.toUpperCase(), path, key)
      else
        app[method] path, obj[key]
        verbose and console.log('     %s %s -> %s', method.toUpperCase(), path, key)

    # mount the app
    parent.use app
