yamljs = require 'yamljs'
html2markdown = require 'html2markdown'
_ = require 'underscore'
Backbone = require 'backbone'
minimist = require 'minimist'
ymljsFrontMatter = require 'yamljs-front-matter'
path = require 'path'
marked = require 'marked'
marked.setOptions({
  renderer: new marked.Renderer(),
  gfm: true,
  tables: true,
  breaks: false,
  pedantic: false,
  sanitize: true,
  smartLists: true,
  smartypants: false
});

caseMunger = require 'slug'
caseMunger.defaults.mode = 'rfc3986'
caseMunger.remove = /[.]/g

fs = require 'fs'
{  copyTreeSync
  walkTreeSync
  walkSync} = require 'walk_tree'

Story = Backbone.Model.extend idAttribute: 'title'
AllStories = Backbone.Collection.extend model: Story, comparator: 'title'
allStories = new AllStories

sitePath = path.resolve "./site"
publicPath = path.resolve "../brunch-with-chaplin-static/public"
appPath = path.resolve "../brunch-with-chaplin-static/app"
templateName = 'default'
Template = require "./site/layouts/#{templateName}"  # body...
template = new Template Story,AllStories,publicPath,appPath

testFile = (fileName)->
  return fileName.match /\.md$/

getFile = (fileName)->
  fileContents = fs.readFileSync fileName, encoding: "utf-8"
  stuff = ymljsFrontMatter.parse fileContents
  stuff.path = path.relative sitePath, fileName
  if stuff.id
    stuff.numericId = stuff.id
    delete stuff.id
  if stuff.Handle
    stuff.handle = stuff.Handle
    delete stuff.Handle
  stuff.content = stuff.__content
  delete stuff.__content
  allStories.push stuff
  return

walkTreeSync sitePath, testFile, getFile

allStories.sort()
newYml = allStories.toJSON()
newYml = yamljs.stringify newYml
fs.writeFileSync 'story-published.yml', newYml

kinds = {}
try
  fs.mkdirSync path.resolve publicPath
catch
keyWords = {}

expandStory = (story)->
  dir = "#{story.get 'category'}"
  story.set 'href', "#{dir}/#{story.get 'slug'}.html"
  content = story.get 'content'
  cooked = marked content
  story.set 'cooked', cooked
  callAgain = false
  try
    callAgain = template.analyze story
  catch error
    console.log "template #{templateName} failed on #{story.get 'title'}"
  return callAgain

publishStory = (story)->
  content = template.formatStory story
  dir = "../brunch-with-chaplin-static/public"
  fileName = "#{dir}/#{story.get 'href'}"
  try
    try
      fs.mkdirSync dir
    catch
    fs.writeFileSync(fileName,content )
  catch nasty
    console.log "Nasty Write to public #{fileName}:",nasty
  return
###
allStories.each (story)->
    try
      massageStory story
      console.log "massage OK: #{story.get "title"}"
    catch e
      console.log "story had problems - #{story.get "title"}"
      console.log e
###
repeat = true
while repeat
  repeat = false
  allStories.each (story)->
      try
        repeat |= expandStory story
        console.log "massage OK: #{story.get "title"}"
      catch e
        console.log "story had problems - #{story.get "title"}"
        console.log e

template.summarize allStories

allStories.each (story)->
    try
      publishStory story
      console.log "massage OK: #{story.get "title"}"
    catch e
      console.log "story had problems - #{story.get "title"}"
      console.log e
