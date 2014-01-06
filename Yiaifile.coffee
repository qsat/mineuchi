'use strict'

module.exports = (yiai) ->

  header_has_class = (cls)->
    (path, window, res) ->
      window.$(".#{cls}").size() > 0

  encoding_is = ->
    (path, window, res) ->
      true

  hasPath = (str)->
    (path) ->
      path.indexOf(str) > -1


  yiai.initConfig
    dest:     "./dest"
    origin:   "http://localhost:8000"
    filelist: "filelist.txt"

    patterns:
      patternA:
        check:   [header_has_class('headerIndex'), encoding_is('utf-8')]
        replace:
          '#container p:eq(1)': (str)-> str.replace "d", "a"
          '#container p:eq(0)': (str)-> "----------"
      patternB:
        check:   [header_has_class('header'), encoding_is('utf-8')]
        replace:
          '#container p:eq(1)': (str)-> str.replace "d", "a"
          '#container p:eq(0)': (str)-> "----------"
      patternC:
        check:   [hasPath("/signup"), encoding_is('utf-8')]
        replace:
          '#container p:eq(1)': (str)-> str.replace "d", "a"
          '#container p:eq(0)': (str)-> "----------"
