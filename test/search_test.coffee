assert   = require('assert')
chai     = require('chai')
chaiHttp = require('chai-http')
expect   = chai.expect
cheerio  = require('cheerio')

chai.use(chaiHttp)
chai.request.addPromises(require('q').Promise)

describe 'Search', ->
  it 'should working', ->
    chai.request('http://localhost:3000')
      .get('/products?q=apple')
      .then (res) ->
        expect(res).to.have.status(200)

  it 'should search items', ->
    chai.request('http://localhost:3000')
      .get('/products?q=apple')
      .then (res) ->
        $ = cheerio.load(res.text)
        itemsCount = $('.product').length
        expect(itemsCount).to.be.above(1)

  it 'should search items with case insensitive query', ->
    query = 'aPpLe'
    chai.request('http://localhost:3000')
      .get("/products?q=#{query}")
      .then (res) ->
        $ = cheerio.load(res.text)
        itemCount = $('.product').length
        expect(itemCount).to.be.above(1)


  it 'should search items with typo', ->
    typo_query = 'aplpe'
    chai.request('http://localhost:3000')
      .get("/products?q=#{typo_query}")
      .then (res) ->
        $ = cheerio.load(res.text)
        itemCount = $('.product').length
        h3 = $('.container>h3').text()

        expect(itemCount).to.be.above(1)
        expect(h3).to.be.contain('Apple')

