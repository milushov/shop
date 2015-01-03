# this variant of seed file only for development proccess,
# for a small bunch of items, not for pruduction


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


# request for getting remote page and parse products content
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
      price = parseFloat(item.find('.s-price:first-child').text())
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

      # array of functions for getting remote data
      requests = []

      for pageN in [2..LAST_PAGE]
        do (pageN) ->
          requests.push (callback) ->
            performRequest url, pageN, (data) ->
              if data.error?
                console.info('fail', data.error)
                callback(data.error, null)
              else
                callback(null, {cat: category, items: data})

      # accumulating data from all pages
      async.series requests, (err, items_array) ->
        console.info('task completed \n')

        for items in items_array
          results[items.cat] = results[items.cat] || []
          results[items.cat] = results[items.cat].concat(items.items)

        callback(null, true)


async.series tasks, (err, data) ->
  console.info('tasks completed!')
  #console.info(results)

  merchants = null

  db.sequelize.sync(force: true)
  .then ->
    db.Merchant.create(name: 'First merchant')
    db.Merchant.create(name: 'Second merchant')

  .then ->
    db.Merchant.findAll()

  .then (mers) ->
    merchants = mers

    # accumulating data from all categories
    for category_name, items of results
      do (category_name, items) ->
        db.Category.create(name: category_name).then (category) ->
          # damage! I haven't found multiple creation in sequelize docs
          # so go ahead with async for using its finish callback
          tasks = []

          # getting prepare array of functions
          for item in items
            do (item) ->
              tasks.push (callback) ->
                db.Product.create(item).then (prod) ->
                  callback(null, prod)

          # getting bunch of products and set merchant for them
          async.series tasks, (err, products) ->
            for merch, i in merchants
              _products = products.filter (el, j) ->
                (j + 1) % merchants.length is i
              merch.setProducts(_products)

            category.setProducts(products)

            # asume that all categories already created
            db.Category.findAll().then (cats) ->
              for prod in products
                do (prod) ->
                  new_cats = cats.filter((el) -> Math.round(Math.random()))
                  prod.setCategories(new_cats)


