BaseController = require  'controllers/base/controller'
StoryCollection = require 'models/stories'
SSView = require 'views/sidebar-view.coffee'
React =  require 'react'


'use strict'
class SB extends React.Component
  render: ->
    alert "wow"
    return null
  constructor: (@stories, filter)->
    super
    @view = new SSView @stories, filter
    
    
module.exports = class SideBarController extends BaseController
  initialize: ->
    super
    @stories = new StoryCollection
    @view = new SB @stories, (s)->
      (s.get 'siteHandle') == siteHandle

  showit: ->
    @view.render()
