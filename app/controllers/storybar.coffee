BaseController = require  'controllers/base/controller'
StoryCollection = require 'models/stories'
SSView = require 'views/storybar-view'

'use strict'

module.exports = class StoryBarController extends BaseController
  initialize: ->
    super
    @stories = new StoryCollection
    @view = new SSView @stories, (s)->
      (s.get 'siteHandle') != siteHandle

  showit: ->
    @view.render ()->
