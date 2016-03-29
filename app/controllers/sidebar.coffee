BaseController = require  'controllers/base/controller'
StoryCollection = require 'models/stories'
SSView = require 'views/sidebar-story-view'

'use strict'

module.exports = class SideBarController extends BaseController
  initialize: ->
    super
    @stories = new StoryCollection
    @view = new SSView @stories, (s)->
      (s.get 'siteHandle') == siteHandle

  showit: ->
    @view.render()
