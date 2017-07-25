BaseController = require  'controllers/base/controller'
{allStories} = require 'models/stories'
StorybarView = require 'views/storybar-view'

'use strict'

module.exports = class StoryBarController extends BaseController
  initialize: ->
    super
    # filter is trivial now since allStories only points to neighbors in site graph
    @view = new StorybarView allStories, (s)->true

  showit: ->
    @view.render ()->
