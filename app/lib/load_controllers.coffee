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
    app.locals.pretty = true

    # allow specifying the view engine
    app.set 'view engine', obj.engine  if obj.engine
    app.set 'views', __dirname + '/../views/' + name

    # generate routes based
    # on the exported methods
    if obj.customController
      parent.use require("../routes/#{name}").routes(app, obj)
    else
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
            throw new Error('unrecognized route: ' + name + '.' + key)

        # setup
        handler     = obj[key]
        path        = prefix + path
        args        = [path]
        middlewares = [obj.before, handler]
        middlewares = middlewares.filter (el) -> el
        args        = args.concat(middlewares)

        app[method].apply(app, args)
        verbose and console.log('     %s %s -> %s', method.toUpperCase(), path, key)

      # mount the app
      parent.use app
