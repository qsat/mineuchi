# coffee --watch --compile --output ./ ./
# http://liginc.co.jp/programmer/archives/4848
# http://blog.sarabande.jp/post/52095868617

# node_modules
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
jsdom = require 'jsdom'
colors = require 'colors'
jquery = fs.readFileSync "./bower_components/jquery/jquery.min.js", "utf-8"
_ = require 'underscore'

class Yiai

  constructor: () ->
    @options = {}
    @filelist = @options.filelist || 'filelist.txt'
    @dest = @options.dest || "./dest"
    @origin = @options.origin || 'http://localhost:8080'
    @initialize()

  initialize: () ->
    lines = @lineBy(@filelist)
    lines.forEach (path, index) =>
      jsdom.env
        url: "#{@origin}#{path}"
        src: [jquery]
        done: (error, window) =>
          @complete(path, error, window)
    
  complete: (path, error, window) =>
    $ = window.$
    str = $('#container').html()
    destpath = "#{@dest}#{path}"
    @mkdir destpath, error, "mkdir"
    @writeFile destpath, str, error, "write"

  lineBy: (filename, encoding) ->
    encoding = encoding || 'utf8'
    str = fs.readFileSync filename, encoding
    lines = str.split String.fromCharCode(10)
    return _.compact(lines)

  dirname: (p) ->
    if path.extname(p) isnt ''
      p = path.dirname p
    return p

  reqfile: (p) ->
    if /\/$/.test p
      p = "#{p}index.html"
    return p

  mkdir: (path, error, cmd) ->
    mkdirp.sync @dirname(path)
    @log error, cmd, path

  writeFile: (path, str, error, cmd) ->
    path = @reqfile(path)
    fs.writeFileSync path, str,
      flag: 'a'
    @log error, cmd, path

  log: (error, cmd, path) ->
    stat = if error then "NG".red else "OK".green
    console.log "Yiai " + "#{stat} " + "#{cmd} ".magenta + path

new Yiai()

