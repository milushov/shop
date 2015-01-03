exports.helpers = (req) ->
  return {
    truncate: (str, length) ->
      str.substr(0, length) + '..'

    buildParams: (page, q, c, m) ->
      params = ["page=#{page}", "q=#{q}", "category_id=#{c?.id}", "merchant_id=#{m?.id}"]
      params = params.filter (el) ->
        val = el.split('=')[1]
        val && val isnt 'undefined'

      '?' + params.join('&')

    activeSection: (path) ->
      'active' if req.originalUrl is path
  }

