# coffee --watch --compile --output ./ ./
# http://liginc.co.jp/programmer/archives/4848
# http://blog.sarabande.jp/post/52095868617

# node_modules
http = require('http')
request = require('request')
jsdom = require('jsdom')
fs = require('fs')
jquery = fs.readFileSync("./bower_components/jquery/jquery.min.js", "utf-8")

# utility関数
Yiai =
  lineBy: (filename, encoding) ->
    encoding = encoding || 'utf8'
    str = fs.readFileSync filename, encoding
    str.split String.fromCharCode(10)

# file lines
lines = Yiai.lineBy 'filelist.txt'


lines.forEach (url, index) ->
  return if url is ''
  jsdom.env
    url: url
    src: [jquery]
    done: (error, window) ->
      $ = window.$
      console.log $('body').html()
#  request url, (error, response, body) ->
#    console.log error, response, body
