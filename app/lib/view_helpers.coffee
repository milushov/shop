exports.helpers = (req) ->
  return {
    truncate: (str, length) ->
      str.substr(0, length) + '..'

    buildParams: (page, q='') ->
      params = ["page=#{page}", "q=#{q}"]
      params = params.filter (el) -> el.split('=')[1]
      '?' + params.join('&')

    activeSection: (path) ->
      'active' if req.originalUrl is path
  }

