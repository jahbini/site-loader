yamljs = require 'yamljs'
html2markdown = require 'html2markdown'
_ = require 'underscore'
Backbone = require 'backbone'
minimist = require 'minimist'
ymljsFrontMatter = require 'yamljs-front-matter'
path = require 'path'
mkdirp = require 'mkdirp'
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

sitePath = path.resolve "./site"
publicPath = path.resolve "./public"
appPath = path.resolve "./app"

AllStories = Backbone.Collection.extend comparator: 'slug'
allStories = new AllStories

Sites = require './sites'
SubSiteStory = class Story extends Backbone.Model
  initialize: ()->
  idAttribute: 'slug'
  defaults:
    debug:""

  href: (against = false)=>
    ref = "#{@get 'category'}/#{@get 'slug'}.html"
    return ref unless against
    return  "#{against}/#{ref}" if against.match '/'
    siteUrl = Sites[against].lurl
    sitePort = Sites[against].port
    return "http://#{siteUrl}:#{sitePort}/#{ref}"

  snap: (text,force=false)->
    if force||(@.get 'debug').match text
      console.log "#{text} -- Story slug #{@.get 'slug'}"
      console.log "Attributes", @.attributes
      console.log "#{text} -----"

  death: (why,structure=null)->
    console.log 'reason ----------'
    console.log why
    console.log 'failure info----------'
    if structure
      console.log structure
    console.log 'object attributes ----------'
    console.log @attributes
    console.log 'Death----------'
    if @attributes.sourcePath
      child_process = require "child_process"
      child_process.execSync "open #{(sitePath)}/#{@attributes.sourcePath} -a atom.app"
    process.exit()

  parser: (obj)-> # override me
    return obj

  parse: (obj)=>
    # Sanitize all stories
    delete obj.numericId
    delete obj.nextID
    delete obj.previousID
    delete obj._options
    delete obj.sitePath
    delete obj.href
    delete obj.path
    #our yml engine moves 'content' to '__content' -- go figure
    if obj.debug == 'content'
      console.log "CONTENT debug"
      console.log obj
    if obj.__content && !obj.content
      obj.content = obj.__content
    delete obj.__content
    @parser obj
    if !obj.category || !obj.slug
      console.log obj
      console.log "no category? slug?"
      child_process = require "child_process"
      child_process.execSync "open #{sitePath}/#{obj.sourcePath} -a atom.app"
      process.exit()
    return obj



SubSiteStories = class extends Backbone.Collection
  comparator: 'slug'
  setFormatter: (@formatter)->

  initialize: (@siteHandle,@SiteStory = Story)->

  getPublishedFileDir: (story)->
    categories = story.get 'category'
    if !categories
      story.snap "Bad category",true
    return "#{publicPath}/#{@siteHandle}/#{categories}"

  getPublishedFileName: (story)->
    return "#{getPublishedFileDir story}/#{story.get 'slug'}.html"

  testFile: (f)=>
    result = f.match ///#{@siteHandle}.*\.md$///
    return result

  getFile: (fileName)=>
    try
      fileContents = fs.readFileSync fileName, encoding: "utf-8"
    catch badPuppy
      console.log "Trouble reading #{fileName}"
      console.log badPuppy
      return null
    #assure proper headMatter
    unless fileContents.match /^(---|###)/
      fileContents = fileContents.replace /([^]*?)(---|###)/, (match,head,dash)->
        return "#{dash}\n#{head}\n#{dash}"
    stuff = ymljsFrontMatter.parse fileContents
    throw "badly formed file #{fileName}" unless fileContents.match /^(---|###)/
    stuff.sourcePath = path.relative sitePath, fileName
    stuff.siteHandle = @siteHandle
    theStory = new @SiteStory stuff, parse: true
    @.push theStory
    allStories.push theStory

StJohnsJimStory = class extends SubSiteStory
BambooSnowStory = class extends SubSiteStory
  parser: (stuff)->
    if stuff.id
      stuff.numericId = stuff.id
      delete stuff.id
    if stuff.Handle
      stuff.handle = stuff.Handle
      delete stuff.Handle
    return
BambooSnowStories = class extends SubSiteStories

StJohnsJimStories = class extends SubSiteStories

stJohnsJimCollection = new StJohnsJimStories 'stjohnsjim'
bambooSnowCollection = new BambooSnowStories 'bamboosnow'

siteHandlers = [stJohnsJimCollection, bambooSnowCollection]



walkTreeSync sitePath, bambooSnowCollection.testFile, bambooSnowCollection.getFile
walkTreeSync sitePath, stJohnsJimCollection.testFile, stJohnsJimCollection.getFile
console.log "AllStories has #{allStories.length} elements"

for storyKind, collection of {
    story: allStories
    stjohnsjim: stJohnsJimCollection
    bamboosnow: bambooSnowCollection
    }
  console.log storyKind
  collection.sort()
  yml = collection.toJSON()
  yml = yamljs.stringify yml
  fs.writeFileSync "#{storyKind}-pub.yml", yml

# Start the publication phases
# create the publication root
# analyze the stories en-mass
# format the stories
# write the stories
try
  mkdirp.sync path.resolve publicPath
catch

templateName =  'default'
Template = require "./layouts/#{templateName}"  # body...
template = new Template SubSiteStories,AllStories,publicPath,appPath
analyzeStory = (story)->
  try
    dir = "#{story.get 'category'}"
    content = story.get 'content'
    cooked = marked content
    story.set 'cooked', cooked
    template.analyze story
  catch badPuppy
    story.death "template #{templateName} failed to analyze on #{story.get 'title'}", badPuppy
  return

expandStory = (story)->
  try
    expansion = template.expand story
  catch badPuppy
    story.death "template #{templateName} failed to expand on #{story.get 'title'}", badPuppy
  return expansion

publishStory = (story)->
  content = template.formatStory story
  if !content
    story.death "no content from formatStory"
  if ! story.get 'siteHandle'
    story.death "No siteHandle"
  dir = "#{publicPath}/#{story.get 'siteHandle'}/#{story.get 'category'}"
  fileName = "#{publicPath}/#{story.get 'siteHandle'}/#{story.href()}"
  try
    try
      mkdirp.sync dir
    catch
    fs.writeFileSync(fileName,content )
  catch nasty
    story.death "Nasty Write to public #{fileName}:",nasty
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

console.log "Publishing stories"
allStories.each (story)->
    try
      publishStory story
    catch e
      console.log "publish of story had problems - #{story.get "title"}"
      console.log e

theSummary = template.summarize allStories
fs.writeFileSync "#{appPath}/generated/all-posts.js", "module.exports = #{JSON.stringify theSummary};"
fs.writeFileSync "#{appPath}/generated/sites.js", "module.exports = #{JSON.stringify Sites};"
console.log "Publication complete."
