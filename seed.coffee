request   = require('request')
cheerio   = require('cheerio')
async     = require('async')
db        = require('./app/models')
tasks     = []
results   = {}
LAST_PAGE = 7
urls      = {
  'laptops': 'http://www.amazon.com/s/ref=sr_pg_3?rh=n%3A172282%2Cn%3A%21493964%2Cn%3A541966%2Cn%3A565108%2Cp_n_condition-type%3A2224371011%2Cp_72%3A1248880011%2Cp_n_availability%3A1248800011&bbn=565108&suppress-ve=1&ie=UTF8&qid=1420197998&page=2'
  'cameras': 'http://www.amazon.com/s/ref=lp_3017941_pg_2?rh=n%3A172282%2Cn%3A%21493964%2Cn%3A502394%2Cn%3A281052%2Cn%3A3017941&ie=UTF8&qid=1420199078&page=2'
  'cell phones': 'http://www.amazon.com/s/ref=lp_7072561011_pg_2?rh=n%3A2335752011%2Cn%3A%212335753011%2Cn%3A7072561011&ie=UTF8&qid=1420201493&page=2'
}


performRequest = (url, pageN = 2, callback) ->
  console.info("  performing request for page #{pageN}")
  _url = "#{url}&page=#{pageN}"

  request.get _url, (err, resp, body) ->
    return callback(error: err) if err

    $ = cheerio.load(body)
    items = []
    $('.s-result-list li .s-item-container').each (i, el) ->
      item = $(el)

      randPrice = (Math.random()*7000).toFixed(2)
      price = item.find('.s-price:first-child').text()
      price = price || randPrice
      price = price.split('$')[1] || randPrice

      items.push(
        image: item.find('img:first-child').attr('src')
        name: item.find('.s-access-detail-page').text()
        price: price
      )
    callback(items)


for category, url of urls
  do (category, url) ->
    tasks.push (callback) ->
      console.info("start task for category #{category}")

      requests = []

      for pageN in [2..LAST_PAGE]
        do (pageN) ->
          requests.push (callback) ->
            performRequest url, pageN, (data) ->
              if data.error?
                console.info('fail', data.error)
                callback(data.error, null)
              else
                callback(null, data)

      async.series requests, (err, data) ->
        console.info('task completed \n')
        for category, items of data
          results[category] = results[category] || []
          results[category] = results[category].concat(items)
        callback(null, data)


async.series tasks, (err, data) ->
  console.info('tasks completed!')
  #console.info(results)

  merchants = null

  for category_name, items of results
    db.sequelize.sync(force: true)
    .then ->
      db.Merchant.create(name: 'First merchant')
      db.Merchant.create(name: 'Second merchant')

    .then ->
      db.Merchant.findAll()

    .then (mers) ->
      console.info('------------', mers.length)
      merchants = mers
      db.Category.create(name: category_name)

    .then (category) ->
      # damage! I haven't found multiple creation in sequelize docs
      # so go ahead with async for using its finish callback
      tasks = []

      for item in items
        do (item) ->
          tasks.push (callback) ->
            db.Product.create(item).then (prod) ->
              callback(null, prod)

      async.series tasks, (err, products) ->
        for merch, i in merchants
          _products = products.filter (el, j) -> (j + 1) % merchants.length is i
          merch.setProducts(_products)

        category.setProducts(products)








