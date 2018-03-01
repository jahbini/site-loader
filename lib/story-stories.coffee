#
# Story model and Stories collection
#
Backbone = require 'backbone'
_ = require 'underscore'
moment = require 'moment'
Cson = require 'cson'

class Story extends Backbone.Model
  canPublish:()=>
    @attributes.accepted && moment(@attributes.embargo) < moment() && !@attributes.drafts
      
  toWriteable:()=>
    raw = @.toJSON()
    delete raw.id
    delete raw.name
    delete raw.fields
    structure = 
      id: @id
      name: @.get 'name'
      fields: raw
    structure
  fieldsOf:(indent)=>
    spaces = '  '.repeat indent
    raw = Cson.createCSONString  @.attributes, indent:'  ' 
    (raw.split '\n').join "\n  "
    
class Stories extends Backbone.Collection
  model: Story
  toWriteable:()=>
    return 
      results:@.map (site)->site.toWriteable()
      count: @.size()

buildStories = (json)->
  stories = new Stories
  for story in json.results
    fields=story.fields
    fields.id = story.id
    fields.snippets ='{}' unless fields.snippets
    fields.author = '' unless fields.author
    fields.name = story.name
    delete fields.content
    stories.add fields
  stories

module.exports = { Story, Stories, buildStories }
