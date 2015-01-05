assert   = require('assert')
chai     = require('chai')
chaiHttp = require('chai-http')
expect   = chai.expect
cheerio  = require('cheerio')
db  = require('../app/models')
app  = require('../app/app')

chai.use(chaiHttp)
chai.request.addPromises(require('q').Promise)
url = 'http://localhost:3001'

describe 'Pagination', ->
  it 'should working', ->
    chai.request(url)
      .get('/products')
      .then (res) ->
        db.Product.count().then (count) ->
          perPage = app.get('perPage')
          expect(count).to.be.above(perPage)

          $ = cheerio.load(res.text)
          isPaginationBlock = !!$('.pagination').length
          expect(isPaginationBlock).to.be.true()


  it 'should hiding block if results count less than perPage', ->
    query = 'yo'
    chai.request(url)
      .get("/products?q=#{query}")
      .then (res) ->
        db.Product.count(where: ['name like ?', "%#{query}%"]).then (count) ->
          perPage = app.get('perPage')
          expect(count).to.be.below(perPage)

          $ = cheerio.load(res.text)
          isPaginationBlock = !!$('.pagination').length
          expect(isPaginationBlock).to.be.false()

  it 'should highlith current page', ->
    pageN = 3
    chai.request(url)
      .get("/products?page=#{pageN}")
      .then (res) ->
        $ = cheerio.load(res.text)
        curPage = parseInt($('.pagination .active>a').text())
        expect(curPage).to.be.equal(pageN)


  it 'should hide prev & next links', ->
    db.Product.count().then (count) ->
      perPage = app.get('perPage')

      firstPage = 1
      lastPage = Math.round(count/perPage)

      chai.request(url)
        .get("/products?page=#{firstPage}")
        .then (res) ->
          $ = cheerio.load(res.text)
          isPrevLink = !!$('.pagination .prev').length
          expect(isPrevLink).to.be.false()

      chai.request(url)
        .get("/products?page=#{lastPage}")
        .then (res) ->
          $ = cheerio.load(res.text)
          isNextLink = !!$('.pagination .next').length
          expect(isNextLink).to.be.false()


  it 'should working with search', ->
    query = 'apple'
    chai.request(url)
      .get('/products?q=apple&page=1')
      .then (res) ->
        db.Product.count(where: ['name like ?', "%#{query}%"]).then (count) ->
          perPage = app.get('perPage')
          expect(count).to.be.above(perPage)

          $ = cheerio.load(res.text)
          isPaginationBlock = !!$('.pagination').length
          expect(isPaginationBlock).to.be.true()
