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
publicPath = path.resolve "public"
appPath = path.resolve "app"
templateName = 'default'
Template = require "./layouts/#{templateName}"  # body...
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


analyzeStory = (story)->
  dir = "#{story.get 'category'}"
  story.set 'href', "#{dir}/#{story.get 'slug'}.html"
  content = story.get 'content'
  cooked = marked content
  story.set 'cooked', cooked
  try
    template.analyze story
  catch error
    console.log "template #{templateName} failed on #{story.get 'title'}"
  return

expandStory = (story)->
  try
    callAgain = template.expand story
  catch error
    console.log "template #{templateName} failed on #{story.get 'title'}"
  return callAgain

publishStory = (story)->
  content = template.formatStory story
  dir = "#{publicPath}/#{story.get 'sitePath'}/#{story.get 'category'}"
  fileName = "#{publicPath}/#{story.get 'sitePath'}/#{story.get 'href'}"
  try
    dir = "#{publicPath}"
    try
      fs.mkdirSync dir
    catch
    dir = "#{publicPath}/#{story.get 'sitePath'}"
    try
      fs.mkdirSync dir
    catch
    dir += "/#{story.get 'category'}"
    try
      fs.mkdirSync dir
    catch
    fs.writeFileSync(fileName,content )
  catch nasty
    console.log "Nasty Write to public #{fileName}:",nasty
  return


console.log "analyzing stories"
allStories.each (story)->
    try
      analyzeStory story
    catch e
      console.log "story analysis had problems - #{story.get "title"}"
      console.log e
console.log "Expanding stories"

allStories.each (story)->
    try
      expandStory story
    catch e
      console.log "story expansion had problems - #{story.get "title"}"
      console.log e

template.summarize allStories

console.log "Publishing stories"
allStories.each (story)->
    try
      publishStory story
    catch e
      console.log "publish of story had problems - #{story.get "title"}"
      console.log e

console.log "Publication complete."
