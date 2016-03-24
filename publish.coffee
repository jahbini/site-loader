yamljs = require 'yamljs'
html2markdown = require 'html2markdown'
_ = require 'underscore'
Backbone = require 'backbone'
minimist = require 'minimist'
ymljsFrontMatter = require 'yamljs-front-matter'
path = require 'path'
mkdirp = require 'mkdirp'

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

allStories = null # but only for a little while

Sites = require './sites'
SubSiteStory = class Story extends Backbone.Model
  # tmp is a holder for transient and generated attrubutes
  initialize: ()->
    @tmp = []
  idAttribute: 'slug'
  defaults:
    debug:""

  #path to the url relative story asset directory
  pathToMe: (against = false)=>
    ref = "#{@get 'category'}/#{@get 'slug'}"
    return ref unless against
    return  "#{against}/#{ref}" if against.match '/'
    siteUrl = Sites[against].lurl
    sitePort = Sites[against].port
    return "http://#{siteUrl}:#{sitePort}/#{ref}"

  #path to the url relative story
  href: (against = false)=>
    ref = "#{@get 'category'}/#{@get 'slug'}.html"
    return ref unless against
    return  "#{against}/#{ref}" if against.match '/'
    siteUrl = Sites[against].lurl
    sitePort = Sites[against].port
    return "http://#{siteUrl}:#{sitePort}/#{ref}"

  copyAsset: (name)=>
    assetDest ="#{publicPath}/#{@.get 'siteHandle'}/#{@pathToMe ''}"
    sourceDir = (@.get 'sourcePath').replace /\.[\w]*$/,''
    try
      asset =fs.readFileSync "#{sitePath}/#{sourceDir}/#{name}"
      mkdirp assetDest
      fs.writeFileSync "#{assetDest}/#{name}",asset
    catch badDog
      console.log "copyAsset #{@.get 'slug'}Bad Doggy = #{badDog}"
    return

  snap: (text,force=false)->
    if force ==true || (
        if typeof force == 'string'
          (@.get 'debug').toString().match force
        else
          false
      )
      console.log "#{text} -- Story slug #{@.get 'slug'}"
      console.log "Attributes", @.attributes
      console.log "Tmp", @.tmp
      console.log "#{text} -----"

  death: (why,structure=null)->
    console.log 'reason ----------'
    console.log why
    console.log 'failure info----------'
    if structure
      console.log structure
    console.log 'object attributes ----------'
    console.log @attributes
    console.log 'object temporaries ----------'
    console.log @tmp
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
    theStory.tmp.sourceFileName = fileName
    @.push theStory
    allStories.push theStory

  publish: (template)->
    @.each (story)->
      content = template.formatStory story
      if !content
        story.death "no content from formatStory"
      if ! story.get 'siteHandle'
        story.death "No siteHandle"
      dir = "#{publicPath}/#{story.get 'siteHandle'}/#{story.get 'category'}"
      fileName = "#{publicPath}/#{story.get 'siteHandle'}/#{story.href()}"
      try
        mkdirp.sync dir
        fs.writeFileSync(fileName,content )
      catch nasty
        story.death "Nasty Write to public #{fileName}:",nasty
    return

  expand: (template)->
    @.each (story)->
      try
        expansion = template.expand story
      catch badPuppy
        story.death "template #{templateName} failed to expand on #{story.get 'title'}", badPuppy
    return

  analyze:(template)->
    retry = false
    @.each (story)->
      try
        retry |= template.analyze story
      catch badPuppy
        story.death "template #{templateName} failed to analyze on #{story.get 'title'}", badPuppy
    return retry


  summarize: ()=>
    theSummary = @.map (story)=>
        t=story.clone()
        t.unset 'content'
        t.unset 'sourcePath'
        return t.toJSON()
    return theSummary

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

AllStories = class extends SubSiteStories
allStories = new AllStories

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

console.log "analyzing stories"
if allStories.analyze(template)
   allStories.analyze(template)

console.log "Expanding stories"
allStories.expand(template)

console.log "Publishing stories"
allStories.publish(template)

theSummary = allStories.summarize()
fs.writeFileSync "#{appPath}/generated/all-posts.js", "module.exports = #{JSON.stringify theSummary};"
fs.writeFileSync "#{appPath}/generated/sites.js", "module.exports = #{JSON.stringify Sites};"
console.log "Publication complete."
