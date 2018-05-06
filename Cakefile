#cakefile
Backbone = require 'backbone'
CoffeeScript = require 'coffee-script'
PylonTemplate = Backbone.Model.extend
#  state: (require './models/state.coffee').state
    #Mithril: require 'mithril'
    #Mui: require 'mui'
    #Mss: require 'mss-js'
    #Halvalla: require 'halvalla/lib/halvalla-teacup'
    #Palx: require 'palx'
    fileOps: require './lib/file-ops.coffee'
    Underscore: _ = require 'underscore'
    fs: fs = require 'fs'
    #Button: require './components/button'
(window? || global).Pylon = Pylon = new PylonTemplate

Cson = require 'cson'

{spawn,exec,execSync} = require 'child_process'

SitesJSON = require './sitedef.json'
{Site,Sites,buildSites} = require './lib/site-sites.coffee'
sites = buildSites SitesJSON

#process.exit 0
StoriesJSON = require './story-db.json'
{Story,Stories,buildStories,makeStory} = require './lib/story-stories.coffee'
stories = buildStories StoriesJSON

dbChanged = false

# analyze all the stories gathering all the keys up so we have the 'universal' set of object keys
# spit out a log entry when a new key is introduced
#  why is this necessary? everytime a sory has been movdd from one db to another, some
# keys are introdced, some made redundant, n/a or obsolete 
## fortunately, it only needs to be done after each DB re-jigger
analyzeRawStories = ()->
  allFields = ''
  stories.each (story)->
    keys = []
    keys.push key for key of story.attributes
    fieldsOf =_(keys).sortBy().join ' '
    console.log fieldsOf if fieldsOf != allFields
    allFields = fieldsOf

taskHelper = (cli,next,work=null)->
  if !work
    work=next
    next = null
  [myname,drafts...] = cli.arguments
  if drafts.length == 1 and drafts[0]=='all'
    for story in stories.models
      work story
  else for id in drafts
    work stories.get id
  process.exit 0 unless next
  console.log "finalizing"
  next()
  #execSync "cat domains/#{siteName}/templates/#{siteName}template.coffee #{storySrcPath} | coffee --stdio >#{destPre}#{siteName}/#{category}/#{slug}.html"
  
global.srp = {sites:sites}
task 'srp','split, run and publish', (cli)->
  destPre = "./public-"
  dbChanged = false
  # dbHelper writes out the story db for each site
  dbHelper = ()->
    console.log "FINAL",dbChanged
    # if one of the stories has modified the DB, write it back out
    if dbChanged
      fs.writeFileSync './story-db.json', JSON.stringify stories.toWriteable()
    # write out the new json db files
    activeStories = stories.filter (story)->
      return story?.canPublish() && 'error' != story.get 'category'
    sites.forEach (site)->
      siteName = site.get 'name'
      sID = site.id
      myStories = stories.filter (story)->
        return story?.canPublish() && (sID == story.get 'site') && 'error' != story.get 'category'
        
      fs.writeFileSync "#{destPre}#{siteName}/allstories.json","allStories="+JSON.stringify activeStories
      fs.writeFileSync "#{destPre}#{siteName}/mystories.json","myStories="+JSON.stringify myStories
    return
    
  doStory =(story)->
    srp.expand story # populates srp. source, rendered and db from the story
    storyId = story.get 'id'
    theSite = sites.get story.get 'site'
    slug = story.get 'slug'
    category = story.get 'category'
    category = category.replace /\ /g,'_'
    siteName = theSite.get 'name'
    storySrcDir = "./domains/#{siteName}/templates/#{category}/#{slug}"
    storySourcePath = "./#{storySrcDir}.coffee"
    story.on "change",->
      dbChanged = true
      front = srp.source.split "db[id=\"#{storyId}\"]"
      front = front[0]
      fs.writeFileSync storySourcePath,"""#{front}
db[id="#{storyId}"] =
  #{story.fieldsOf 0}
#
      """
    storyId = "#{siteName}/#{category}/#{slug}"
    story.set srp.db #update all attributes from srp.db object
    story.set 'id',storyId
    # some past mods that never need be done again
    #story.unset 'sourcePath'
    #story.set 'author', 'Copyright 2010-2018 ' + theSite.get 'author'
    console.log "processed #{slug}"
    # now publish the story
    # remove bogus category of '-' for index files
    category = '.' if category == '-'
    
    Pylon.fileOps.copyStoryAssets story
    if story.canPublish()
      console.log "publishing to #{destPre}#{siteName}/#{category}/#{slug}.html"
      fs.writeFileSync "./public-#{siteName}/#{category}/#{slug}.html",srp.rendered
    else
      execSync "rm -f #{destPre}#{siteName}/#{category}/#{slug}.html"
      fs.writeFileSync "./public-#{siteName}/draft/#{category}/#{slug}.html",srp.rendered
    
  CoffeeScript.run fs.readFileSync('./lib/split-run-publish.coffee').toString()
  taskHelper cli, dbHelper, doStory
  process.exit 0
  
task 'new','create new site,category, slug',(cli)->
  [myName,siteName,category,slug] = cli.arguments
  site = sites.findWhere name: siteName
  throw new error "bad Site -- #{siteName}" unless site
  newStory = makeStory site, category,slug
  siteTemplateFile ="./domains/#{siteName}/templates/#{siteName}template.coffee"
  storySrcDir = "./domains/#{siteName}/templates/#{category}/#{slug}"
  storySourcePath = "./#{storySrcDir}.coffee"
  newFile = [
    fs.readFileSync "./domains/#{siteName}/templates/starter-template.coffee",'utf-8'
    """
#
db[id="#{newStory.get 'id'}"] =
  #{newStory.fieldsOf 0}
#
      """
    "#end of story"
    ]
  execSync "mkdir -p #{storySrcDir}"
  fs.writeFileSync storySourcePath, newFile.join '\n'
  # update DB
  stories.add newStory
  fs.writeFileSync "story-db.json", JSON.stringify stories.toWriteable()
  process.exit 0


task 'dumpSites','sites to JSON',()->
  console.log JSON.stringify sites.toWriteable()
  
task 'dumpStories','stories to JSON',()->
  console.log JSON.stringify stories.toWriteable()
  
option '-i', '--id storyid', 'story ID to bump'

Processes = {}
task 'go','brunch build on all siteMaster sites', ()->
  console.log "start"
  s = ['./lib']
  for theSite, thePort of Sites
    console.log "brunchify - #{theSite} - http://localhost:#{thePort}/"
    Processes[theSite] = brunchify theSite,thePort
    s.push "domains/#{theSite}"
  console.log "built"
