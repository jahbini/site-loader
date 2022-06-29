#allStories is global, as is myStories
Collection = require '../models/base/collection.coffee',
Story = require '../models/story.coffee'
 
class Stories extends Collection
  model: Story

  initialize: (@someStories)->
    super()
    #@subscribeEvent 'login', @fetch
    #@subscribeEvent 'logout', @logout
    @fetch()

  fetch: =>
    @push @someStories

module.exports =
  allStories: new Stories allStories
  myStories: new Stories myStories
  Class: Stories
