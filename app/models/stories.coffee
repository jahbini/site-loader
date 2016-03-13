Collection = require 'models/base/collection',
Story = require 'models/story'
allStories = require 'all-posts'


'use strict'

module.exports = class Stories extends Collection

  # Stories are local,, so no need to Mix in a SyncMachine
  #_.extend @prototype, Chaplin.SyncMachine

  model: Story

  initialize: ->
    super

    #@subscribeEvent 'login', @fetch
    #@subscribeEvent 'logout', @logout
    @fetch()

  # Custom fetch function since the Facebook graph is not
  # a REST/JSON API which might be accessed using Ajax
  fetch: =>
    console.debug 'stories#fetch'
    @push allStories
