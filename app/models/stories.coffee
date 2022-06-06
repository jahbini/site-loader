#allStories is global, as is myStories
Collection = require '../models/base/collection.coffee',
Story = require '../models/story.coffee'
 
class Stories extends Collection

  # Stories are local,, so no need to Mix in a SyncMachine
  #_.extend @prototype, Chaplin.SyncMachine

  model: Story

  initialize: (@someStories)->
    super()

    #@subscribeEvent 'login', @fetch
    #@subscribeEvent 'logout', @logout
    @fetch()

  fetch: =>
    @push @someStories
allStories = {}
myStories = {}
module.exports =
  allStories: new Stories allStories
  myStories: new Stories myStories
  Class: Stories
