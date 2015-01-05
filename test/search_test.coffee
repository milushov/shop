assert   = require('assert')
chai     = require('chai')
chaiHttp = require('chai-http')
expect   = chai.expect
cheerio  = require('cheerio')
app      = require('../app/app')
url      = "http://localhost:#{app.get('port')}"

require('./spec_helper')(app)

chai.use(chaiHttp)
chai.request.addPromises(require('q').Promise)

describe.only 'Search', ->
  it 'should working', ->
    chai.request(url).get('/products?q=apple').then (res) ->
      expect(res).to.have.status(200)


  it 'should search items', ->
    chai.request(url).get('/products?q=apple').then (res) ->
      $ = cheerio.load(res.text)
      itemsCount = $('.product').length
      expect(itemsCount).to.be.above(1)


  it 'should search items with case insensitive query', ->
    query = 'aPpLe'
    chai.request(url).get("/products?q=#{query}").then (res) ->
      $ = cheerio.load(res.text)
      itemCount = $('.product').length
      expect(itemCount).to.be.above(1)


  it 'should search items with typo', ->
    typo_query = 'aplpe'
    chai.request(url).get("/products?q=#{typo_query}").then (res) ->
      $ = cheerio.load(res.text)
      itemCount = $('.product').length
      h3 = $('.container>h3').text()

      expect(itemCount).to.be.above(1)
      expect(h3).to.be.contain('Apple')


  it 'should search items with two and more words', ->
    query = 'apple iphone'
    chai.request(url).get("/products?q=#{query}").then (res) ->
      $ = cheerio.load(res.text)
      itemCount = $('.product').length
      h3 = $('.container>h1').text()

      expect(itemCount).to.be.above(1)
      expect(h3).to.be.contain(query)


  it 'should search items with two and more misspelled words', ->
    typo_query = 'aplep ipohne'
    chai.request(url).get("/products?q=#{typo_query}").then (res) ->
      $ = cheerio.load(res.text)
      itemCount = $('.product').length
      h3 = $('.container>h3').text()

      expect(itemCount).to.be.above(1)
      expect(h3).to.be.contain('Apple iPhone')


  it 'full text search items with two and more misspelled words', ->
    typo_query = 'ipohne blakc'
    chai.request(url).get("/products?q=#{typo_query}").then (res) ->
      $ = cheerio.load(res.text)
      itemCount = $('.product').length
      h3 = $('.container>h3').text()

      expect(itemCount).to.be.above(1)
      expect(h3).to.be.contain('iPhone Black')
