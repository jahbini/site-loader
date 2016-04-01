
Backbone = require 'backbone'
_ = require 'underscore'
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
ymljsFrontMatter = require 'yamljs-front-matter'
sitePath = path.resolve "./site"
publicPath = path.resolve "./public"
appPath = path.resolve "./app"

allStories = {} # value assigned below
template = {} # value assigned below


templateName =  'default'
Template = require "./layouts/#{templateName}"  # body...

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

  copyAsset: (name,newPath = "#{publicPath}-")=>
    assetDest ="#{newPath}#{@.get 'siteHandle'}/#{@pathToMe ''}"
    sourceDir = (@.get 'sourcePath').replace /\.[\w]*$/,''
    try
      asset =fs.readFileSync "#{sitePath}/#{sourceDir}/#{name}"
      mkdirp.sync assetDest
      fs.writeFileSync "#{assetDest}/#{name}",asset
    catch badDog
      console.log "copyAsset #{@.get 'slug'}Bad Doggy = #{badDog}"
      process.exit()
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
    console.log 'failure info----------'
    if structure
      console.log structure
    console.log 'object attributes ----------'
    console.log @attributes
    console.log 'object temporaries ----------'
    console.log @tmp
    console.log 'reason ----------'
    console.log why
    console.log 'Death----------'
    if @attributes.sourcePath
      child_process = require "child_process"
      child_process.execSync "open #{sitePath}/#{@attributes.sourcePath} -a atom.app"
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

  initialize: ()=>

  setSites:(@Sites)->
    allKeys = []
    for keys of @Sites
      allKeys.push keys
    @matcher = ///(#{allKeys.join '|'}).*\.(md|coffee)$///



  getPublishedFileDir: (story)->
    categories = story.get 'category'
    if !categories
      story.snap "Bad category",true
    return "#{publicPath}-#{@siteHandle}/#{categories}"

  getPublishedFileName: (story)->
    return "#{getPublishedFileDir story}/#{story.get 'slug'}.html"

  testFile: (f)=>
    result = f.match @matcher
    return result

  getFile: (fileName)=>
    kinds = fileName.match @matcher
    if kinds[2] == 'coffee'
      console.log "Skipping Coffee Files"
      return
    SiteStory = @Sites[kinds[1]].Story
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
    stuff.siteHandle = stuff.sourcePath.split('/')[0]
    theStory = new SiteStory stuff, parse: true
    theStory.tmp.sourceFileName = fileName
    @.push theStory
    allStories.push theStory

  writeNew: (newSite)->
    @.each (story)->
      if story.get 'debug'
        debugger
      content = story.get 'content'

      head = story.clone().attributes
      delete head.content
      headMatter = ymljsFrontMatter.encode head, content
      fileName = "#{newSite}/#{head.siteHandle}/#{head.category}/#{head.slug}.md"
      try
        mkdirp.sync "#{newSite}/#{head.siteHandle}/#{head.category}"
      catch
      try
        fs.writeFileSync(fileName,headMatter )
      catch badDog
        console.log badDog
        process.exit()
      images = story.get 'images'
      _.each images, (image)->
        console.log "copy #{image} to #{newSite}"
        story.copyAsset image,"#{newSite}/"

      return
  publish: ()->
    @.each (story)->
      content = story.template.formatStory story
      if !content
        story.death "no content from formatStory"
      if ! story.get 'siteHandle'
        story.death "No siteHandle"
      dir = "#{publicPath}-#{story.get 'siteHandle'}/#{story.get 'category'}"
      fileName = "#{publicPath}-#{story.get 'siteHandle'}/#{story.href()}"
      try
        mkdirp.sync dir
        fs.writeFileSync(fileName,content )
      catch nasty
        story.death "Nasty Write to public #{fileName}:",nasty
    return

  expand: ()->
    @.each (story)->
      try
        expansion = story.template.expand story
      catch badPuppy
        story.death "template #{story.siteHandle} failed to expand on #{story.get 'title'}", badPuppy
    return

  analyze:()->
    retry = false
    @.each (story)->
      try
        retry |= story.template.analyze story
      catch badPuppy
        story.death "template #{story.siteHandle} failed to analyze on #{story.get 'title'}", badPuppy
    return retry


  summarize: ()=>
    theSummary = @.map (story)=>
        t=story.clone()
        t.unset 'content'
        t.unset 'sourcePath'
        return t.toJSON()
    return theSummary

allStories = new SubSiteStories

module.exports =  SubSiteStory: SubSiteStory, SubSiteStories: SubSiteStories, allStories: allStories
