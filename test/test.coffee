connect = require 'connect'
alchemist = require 'alchemist-middleware'

describe 'basic', ->

  it 'should set cache control based on an integer', (done) ->
    app = connect()
      .use(archivist('/': 360000))
      .use(alchemist(path.join(base_path, 'basic')))

    chai.request(app).get('/').res (res) ->
      res.headers['cache-control'].should.equal('public; max-age=360000')
      done()

  it 'should set cache control based on a string', (done) ->
    app = connect()
      .use(archivist('/': 'wow'))
      .use(alchemist(path.join(base_path, 'basic')))

    chai.request(app).get('/').res (res) ->
      res.headers['cache-control'].should.equal('wow')
      done()

  it 'should not set cache control if falsey', (done) ->
    app = connect()
      .use(archivist('/': false))
      .use(alchemist(path.join(base_path, 'basic')))

    chai.request(app).get('/').res (res) ->
      res.headers['cache-control'].should.equal('public, max-age=0')
      done()

  it 'should set different headers for different globstars', (done) ->
    app = connect()
      .use(archivist('/': 'one', '/foo.*': 'two'))
      .use(alchemist(path.join(base_path, 'basic')))

    chai.request(app).get('/').res (res) ->
      res.headers['cache-control'].should.equal('one')

      chai.request(app).get('/foo.html').res (res) ->
        res.headers['cache-control'].should.equal('two')
        done()
