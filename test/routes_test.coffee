assert   = require('assert')
chai     = require('chai')
chaiHttp = require('chai-http')
expect   = chai.expect
cheerio  = require('cheerio')
db  = require('../app/models')
app  = require('../app/app')

chai.use(chaiHttp)
chai.request.addPromises(require('q').Promise)
url = 'http://localhost:3000'


describe 'Routes', ->
  it '/products', ->
    chai.request(url).get('/products').then (res) ->
      expect(res).to.have.status(200)

      $ = cheerio.load(res.text)
      itemsCount = $('.product').length
      expect(itemsCount).to.be.above(1)


  it '/products/:product_id', ->
    chai.request(url).get('/products/1').then (res) ->
      expect(res).to.have.status(200)

      $ = cheerio.load(res.text)
      itemsCount = $('.product').length
      expect(itemsCount).to.be.equal(1)


  it '/categorys', ->
    chai.request(url).get('/categorys').then (res) ->
      expect(res).to.have.status(200)

      $ = cheerio.load(res.text)
      itemsCount = $('.product').length
      expect(itemsCount).to.be.above(1)


  it '/categorys/:category_id', ->
    chai.request(url).get('/categorys/1').then (res) ->
      expect(res).to.have.status(200)

      $ = cheerio.load(res.text)
      itemsCount = $('.product').length
      expect(itemsCount).to.be.equal(1)


  it '/merchants', ->
    chai.request(url).get('/categorys').then (res) ->
      expect(res).to.have.status(200)

      $ = cheerio.load(res.text)
      itemsCount = $('.merchant').length
      expect(itemsCount).to.be.above(1)


  it '/merchants/:merchant_id', ->
    chai.request(url).get('/merchants/1').then (res) ->
      expect(res).to.have.status(200)

      $ = cheerio.load(res.text)
      itemsCount = $('merchant').length
      expect(itemsCount).to.be.equal(1)

