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

{Story,Stories,makeStory} = require './lib/story-stories.coffee'
stories = new Stories
sites.forEach (s)->
  StoriesJSON = require "./domains/#{s.get 'name'}/story-db.json"
  stories.addStoriesFromJSON StoriesJSON
#stories = buildStories StoriesJSON

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

storyMeta = []

taskHelper = (cli,next,work=null)->
  if !work
    work=next
    next = null
  [myname,drafts...] = cli.arguments
  if drafts.length == 1 and drafts[0]=='all'
    for story in stories.models
      work story
  else for id in drafts
    s = stories.get id
    unless s
      console.log "no story at #{id}"
      continue
    work stories.get id
  process.exit 0 unless next
  console.log "finalizing"
  next()

global.srp = {sites:sites}
writeSiteStories= (site)->
  siteStories = new Stories()
  siteName = site.get 'name'
  siteStories.add  stories.where site:siteName
  fs.writeFileSync "./domains/#{siteName}/story-db.json", JSON.stringify siteStories.toWriteable(),null,2
  return
task 'srp','split, run and publish', (cli)->
  console.log "SRP",cli
  dbChanged = false
  # dbHelper writes out the story db for each site
  dbHelper = ()->
    console.log "FINAL",dbChanged
    # if one of the stories has modified the DB, write it back out
    if dbChanged || true
      sites.forEach writeSiteStories

    # write out the new json db files
    activeStories = stories.filter (story)->
      return story?.canPublish() && 'error' != story.get 'category'
    sites.forEach (site)->
      siteName = site.get 'name'
      sID = site.id
      myStories = stories.filter (story)->
        return story?.canPublish() && (sID == story.get 'site') && 'error' != story.get 'category'
      blackListFields = [ 'created','lastEdited','captureDate','TimeStamp']
      #console.log "myStories",myStories
      myStories = myStories.map (s)->
        try
          x=s.toJSON?() || s
        catch badDog
          console.log "BAD S",badDog
          process.exit 0
        return _.omit x, blackListFields
      #console.log "myStories",myStories
      activeStories= _.map activeStories,(s)->
        try
          x=s.toJSON?() || s
        catch badDog
          console.log "BAD X",s,badDog
          process.exit 0
        return _.omit x, blackListFields

      fs.writeFileSync "./domains/#{siteName}/svelte/allstories.json",JSON.stringify activeStories,null,2
      fs.writeFileSync "./domains/#{siteName}/svelte/mystories.json",JSON.stringify myStories,null,2
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
    sveltePre = """
<script>
//#{category}/#{slug}
</script>

<template lang="pug">

"""
    sveltePost = """
</template>

<style>
</style>
"""
    execSync "mkdir -p ./domains/#{siteName}/svelte/#{category}/#{slug}/"
    Pylon.fileOps.copyStoryAssets story
    fs.writeFileSync "./domains/#{siteName}/svelte/#{category}/#{slug}/+page.json",JSON.stringify story.toWriteable(),"utf8",2
    console.log "publishing to ./domains/#{siteName}/svelte/#{category}/#{slug}/+page.html"
    fs.writeFileSync "./domains/#{siteName}/svelte/#{category}/#{slug}/+page.html",srp.rendered

    fs.writeFileSync "./domains/#{siteName}/svelte/#{category}/#{slug}/+page.svelte",sveltePre
    execSync "html2pug  -f -c <./domains/#{siteName}/svelte/#{category}/#{slug}/+page.html | sed -e s/{{{/Tag:/  >>./domains/#{siteName}/svelte/#{category}/#{slug}/+page.svelte"
    fs.appendFileSync "./domains/#{siteName}/svelte/#{category}/#{slug}/+page.svelte",sveltePost
    # fs.unlinkSync "./domains/#{siteName}/svelte/#{category}/#{slug}/+page.html"


  CoffeeScript.run fs.readFileSync('./lib/split-run-publish.coffee').toString()
  taskHelper cli, dbHelper, doStory
  process.exit 0

task 'newSite', 'create new site for publishing',(cli)->
  [noname,siteName] = cli.arguments
  site = sites.findWhere name: siteName
  if site
    console.log "Site already exists -- #{siteName}"
    process.exit 1
  siteSpec = null
  try
    siteSpec = require "./domains/#{siteName}/site.coffee"
  catch
  unless siteSpec
    console.log "No file site.coffee in ./domains/#{siteName}/"
    process.exit 1
  console.log siteSpec

  siteSpec.name = siteName
  siteSpec.id = siteName
  sites.add siteSpec
  fs.writeFileSync "sitedef.json", JSON.stringify sites.toWriteable()
  process.exit 0

task 'useStory',"use template file at site/category/slug", (cli)->
  [myName,siteName,category,slug] = cli.arguments
  if siteName.match /.+\/.+\/.+/
    [siteName,category,slug] = siteName.split '/'

  site = sites.findWhere name: siteName
  throw new Error "bad Site -- #{siteName}" unless site
  newStory = makeStory site, category,slug
  stories.add newStory
  writeSiteStories site
  process.exit 0

task 'newStory','create new story from site,category, slug',(cli)->
  [myName,siteName,category,slug] = cli.arguments
  if siteName.match /.+\/.+\/.+/
    [siteName,category,slug] = siteName.split '/'

  site = sites.findWhere name: siteName
  throw new Error "bad Site -- #{siteName}" unless site
  newStory = makeStory site, category,slug
  siteTemplateFile ="./domains/#{siteName}/templates/_site-template.coffee"
  storySrcDir = "./domains/#{siteName}/templates/#{category}/#{slug}"
  storySourcePath = "./#{storySrcDir}.coffee"
  newFile = [
    fs.readFileSync "./domains/#{siteName}/templates/_starter-template.coffee",'utf-8'
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
  # update DB and write to site's story-db.json
  stories.add newStory
  writeSiteStories site
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
  console.log  "built"

task  'publish','rsync to destination servers',(cli = 'all') ->
  [myname,siteNames...] = cli.arguments
  console.log cli
  sites.forEach (site)->
    name = site.get 'name'
    console.log 'name',name
    if ('all' in siteNames) || name in siteNames
      console.log 'synching',name
      suffix = if name.match /\.kh$|\.org$/  then '' else '.com'
      #execSync "scp -r ./domains/#{name}/public/* user-data@#{name+suffix}:/home/user-data/www/#{name+suffix}/"
      console.log "rsync -vrzd --exclude='draft' ./domains/#{name}/public/ user-data@#{name}#{suffix}:~/www/#{name}#{suffix}"
      execSync "rsync -vrzd --exclude='draft' ./domains/#{name}/public/ user-data@#{name}#{suffix}:~/www/#{name}#{suffix}"
  process.exit 0



