MenuController = require 'controllers/menu'
FooterController = require 'controllers/footer'
HomeController = require 'controllers/home'
SideBarController = require 'controllers/sidebar'
StoryBarController = require 'controllers/storybar'
routes = require 'routes'
'use strict'

module.exports = class Application extends Chaplin.Application

  initialize: ->
    window.APP = @
    @initDispatcher controllerSuffix: '', controllerPath: 'controllers/'
    @initLayout()
    @initComposer()
    @initMediator()
    @initControllers()

    # Register all routes and start routing
    @initRouter routes, {root: '/', pushState: false}


    @start()


    # Freeze the object instance; prevent further changes
    Object.freeze? @

  initMediator: ->
    # Attach with semi-globals here.
    Chaplin.mediator.controllerAction = ""
    Chaplin.mediator.actionParams = {}

  initControllers: ->
    new HomeController
    new SideBarController
    new StoryBarController
    new MenuController
    new FooterController
