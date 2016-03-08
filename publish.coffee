yamljs = require 'yamljs'
html2markdown = require 'html2markdown'
_ = require 'underscore'
Backbone = require 'backbone'
minimist = require 'minimist'
ymljsFrontMatter = require 'yamljs-front-matter'
path = require 'path'

caseMunger = require 'slug'
caseMunger.defaults.mode = 'rfc3986'
caseMunger.remove = /[.]/g

fs = require 'fs'
{	copyTreeSync
	walkTreeSync
  walkSync} = require 'walk_tree'

Story = Backbone.Model.extend idAttribute: 'title'
AllStories = Backbone.Collection.extend model: Story, comparator: 'title'
allStories = new AllStories

site = path.resolve "./site"
testFile = (fileName)->
	return fileName.match /\.md$/

getFile = (fileName)->
	fileContents = fs.readFileSync fileName, encoding: "utf-8"
	stuff = ymljsFrontMatter.parse fileContents
	stuff.path = path.relative site, fileName
	stuff.numericId = stuff.id
	delete stuff.id
	stuff.handle = stuff.Handle
	delete stuff.Handle
	stuff.content = stuff.__content
	delete stuff.__content
	allStories.push stuff
	return

walkTreeSync site, testFile, getFile

allStories.sort()
newYml = allStories.toJSON()
newYml = yamljs.stringify newYml
fs.writeFileSync 'story_xxx.yml', newYml
return


kinds = {}
try
  fs.mkdirSync "public"
catch
keyWords = {}

expandStory = (story)->
  if story.get 'debug'
    debugger
  partials = story.get 'partials'
  template = story.get 'template'
  for name, value of Object
    partial = require "site/partials/#{name}"
    try
      story.set partial, (partial story)
    catch error
      console.log "partial #{partial} failed on #{story.get 'title'}"
  template = require "site/templates/#{templateName}"  # body...
  try
    story.set "html", ( template story )
  catch error
    console.log "template #{templateName} failed on #{story.get 'title'}"


writeStory = (story)->
  if story.get 'debug'
    debugger
  content = story.get 'content'

  head = story.clone().attributes
  delete head.content
  headMatter = ymljsFrontMatter.encode head, content
  try
    fs.mkdirSync "site/"+head.category
  catch

  fileName = "site/"+head.category+"/"+head.slug+".static.md"
  fs.writeFileSync(fileName,headMatter )
  return

publishStory = (story)->
  if story.get 'debug'
    debugger
  content = story.get 'html'
  try
    fs.mkdirSync "site/"+story.get 'category'
  catch
  fileName = "site/"+head.category+"/"+head.slug+".html"
  fs.writeFileSync(fileName,content )
  return


#stories = yamljs.parseFile 'story.yml'
#allStories = new AllStories
#allStories.push stories

allStories.each (story)->
    try
      massageStory story
      console.log "massage OK: #{story.get "title"}"
    catch e
      console.log "story had problems - #{story.get "title"}"
      console.log e
allStories.each (story)->
    try
      expandStory story
      publishStory story
      console.log "massage OK: #{story.get "title"}"
    catch e
      console.log "story had problems - #{story.get "title"}"
      console.log e
