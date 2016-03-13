PageController =  require 'controllers/page'
log = require 'loglevel'

'use strict'

module.exports =  class HomeController extends PageController
    showit: () ->
      alert "Gaa Chua! Muk Muk!"
      return false

    show: () ->
      alert 'HomeController: show!!'
      log.info 'HomeController:show'
