mm = require 'minimatch'

module.exports = (opts) ->

  return (req, res, next) ->
    for k, v of opts when mm(req.url, k)
      if not v then continue
      if typeof v is 'number'
        res.setHeader('cache-control', "public; max-age=#{v}")
      else
        res.setHeader('cache-control', v)

    next()
