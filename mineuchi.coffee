# coffee --watch --compile --output ./ ./
# http://liginc.co.jp/programmer/archives/4848
# http://blog.sarabande.jp/post/52095868617

# node_modules
fs = require('fs')
path = require('path')
mkdirp = require('mkdirp')
jsdom = require('jsdom')
jquery = fs.readFileSync("./bower_components/jquery/jquery.min.js", "utf-8")

# settings
dest = './dest'
origin = 'http://localhost:8080'

# utility
FileUtils =

  lineBy: (filename, encoding) ->
    encoding = encoding || 'utf8'
    str = fs.readFileSync filename, encoding
    str.split String.fromCharCode(10)

  dirname: (p) ->
    if path.extname(p) isnt ''
      p = path.dirname p
    return p

  reqfile: (p) ->
    if /\/$/.test p
      p = "#{p}index.html"
    return p

# file lines
lines = FileUtils.lineBy 'filelist.txt'

lines.forEach (path, index) ->
  return if path is ''
  jsdom.env
    url: origin + path
    src: [jquery]
    done: (error, window) ->
      $ = window.$
      str = $('#header').html()
      destpath = "#{dest}#{path}"
      mkdirp.sync FileUtils.dirname(destpath)
      fs.writeFileSync FileUtils.reqfile(destpath), str,
        flag: 'a'
