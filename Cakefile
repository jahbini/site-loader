#cakefile
chokidar=require 'chokidar'
Backbone = require 'backbone'
_=require 'underscore'
fs = require 'fs'
moment = require 'moment'
CoffeeScript = require 'coffee-script'
Cson = require 'cson'

{spawn,exec,execSync} = require 'child_process'

SitesJSON = require './sitedef.json'
{Site,Sites,buildSites} = require './lib/site-sites.coffee'
sites = buildSites SitesJSON

#process.exit 0
StoriesJSON = require './stories244.json'
{Story,Stories,buildStories} = require './lib/story-stories.coffee'
stories = buildStories StoriesJSON

sitesStories = {}
activeStories = new Stories

analyzeRawStories = ()->
  allFields = ''
  stories.each (story)->
    keys = []
    keys.push key for key of story.attributes
    fieldsOf =_(keys).sortBy().join ' '
    console.log fieldsOf if fieldsOf != allFields
    allFields = fieldsOf

massageOne = (story)->
  destPre = './public-'
  theSite = sites.get story.get 'site'
  siteName = theSite.get 'name'
  category = story.get 'category'
  category = category.replace /\ /g,'_'
  slug = story.get 'slug'
  
  siteTemplateFile ="./domains/#{siteName}/templates/#{siteName}template.coffee"
  storySrcDir = "./domains/#{siteName}/templates/#{category}/#{slug}"
  storySourcePath = "./#{storySrcDir}.coffee"
  htmlDest = "#{destPre}#{siteName}/#{category}/#{slug}.html"
  storySource = fs.readFileSync storySourcePath, "utf-8"
  
  storyParts = storySource.split '\nclass '
  glue ="""
#-------- class start
class  
"""
  storySource = storyParts.join glue
  storyParts = storySource.split 'console.log'
  storySource = storyParts.join 'rendered = '
  storyParts = storySource.split 'page = new'
  storySource = storyParts.join """
  #-------- class end
  page = new
  """
  fs.writeFileSync storySourcePath, storySource + """
# ------- db start
db = {} unless db
db[id="#{story.get 'id'}"] =
  #{story.fieldsOf 0}
#
  """
  return null
  
taskHelper = (cli,next,work=null)->
  if !work
    work=next
    next = null
  [myname,drafts...] = cli.arguments
  if drafts.length == 1 and drafts[0]=='all'
    console.log "WOW"
    for story in stories.models
      work story
  else for id in drafts
    work stories.get id
  process.exit 0 unless next
  next()
  #execSync "cat domains/#{siteName}/templates/#{siteName}template.coffee #{storySrcPath} | coffee --stdio >#{destPre}#{siteName}/#{category}/#{slug}.html"
  
global.srp = {sites:sites}
task 'srp','split, run and publish', (cli)->
  console.log "srP"
  dbChanged = false
  # if one of the stories has modified the DB, write it back out
  dbHelper = ()->
    if dbChanged
      fs.writeFileSync './nowstories.json', JSON.stringify stories.toWriteable()
      
  doStory =(story)->
    console.log "srP",story.get 'name'
    srp.expand story
    theSite = sites.get story.get 'site'
    slug = story.get 'slug'
    category = story.get 'category'
    category = category.replace /\ /g,'_'
    siteName = theSite.get 'name'
    storySrcDir = "./domains/#{siteName}/templates/#{category}/#{slug}"
    storySourcePath = "./#{storySrcDir}.coffee"
    story.on "change",->
      dbChanged = true
      fs.appendFileSync storySourcePath,"""
#
db[id="#{story.get 'id'}"] =
  #{story.fieldsOf 0}
#
      """
    story.set srp.db
    
    # now publish the story
    console.log "processed #{slug}"
    
    # remove bogus category of '-' for index files
    category = '.' if category == '-'
    destPre = "./public-"
    if story.canPublish()
      if !sitesStories[siteName]
        sitesStories[siteName] = new Sites
      sitesStories[siteName].add story
      activeStories.add story
      console.log "publishing to #{destPre}#{siteName}/#{category}/#{slug}.html"
      execSync "mkdir -p #{destPre}#{siteName}/#{category}"
      execSync "cp -rf #{storySrcDir} #{destPre}#{siteName}/#{category} || true"
      fs.writeFileSync "./public-#{siteName}/#{category}/#{slug}.html",srp.rendered
    else
      execSync "rm -f #{destPre}#{siteName}/#{category}/#{slug}.html"
      execSync "mkdir -p #{destPre}#{siteName}/draft/#{category}"
      execSync "cp -rf #{storySrcDir} #{destPre}#{siteName}/draft/#{category} || true"
      fs.writeFileSync "./public-#{siteName}/draft/#{category}/#{slug}.html",srp.rendered
  #allFields is a sorted list of the keys of the story
  for siteName,collection of sitesStories
    fs.writeFileSync "#{destPre}#{siteName}/allstories.json","allStories="+JSON.stringify activeStories.toJSON()
    fs.writeFileSync "#{destPre}#{siteName}/mystories.json","myStories="+JSON.stringify collection.toJSON()
  fs.writeFileSync './nowstories.json', JSON.stringify stories.toWriteable()
  
    
  CoffeeScript.run fs.readFileSync('./lib/split-run-publish.coffee').toString()
  taskHelper cli, dbHelper, doStory
  
task 'split','split a story',(cli)->
  #taskHelper cli,massageOne
  stories.each (story)->  massageOne story
  
publishAll = () ->
  activeStories = new Stories
  destPre = './public-'
  execSync 'rm -f ./domains/*/unpublished/*'
  stories.each (story)->
    theSite = sites.get story.get 'site'
    siteName = theSite.get 'name'
    category = story.get 'category'
    category = category.replace /\ /g,'_'
    slug = story.get 'slug'
    
    execSync "mkdir -p #{destPre}#{siteName}/#{category}"
    execSync "mkdir -p ./domains/#{siteName}/unpublished"
    console.log 'embargo', story.get 'embargo'
    console.log 'decision',  moment(story.get 'embargo') < moment()
    storySrcDir = "./domains/#{siteName}/templates/#{category}/#{slug}"
    storySrcPath = storySrcDir + ".coffee"
    # remove bogus category of '-' for index files
    category = '.' if category == '-'
    if story.canPublish()
      if !sitesStories[siteName]
        sitesStories[siteName] = new Sites
      sitesStories[siteName].add story
      activeStories.add story
      console.log "publishing to #{destPre}#{siteName}/#{category}/#{slug}.html"
      execSync "cp -rf #{storySrcDir} #{destPre}#{siteName}/#{category} || true"
      execSync "echo console.log rendered | cat domains/#{siteName}/templates/#{siteName}template.coffee #{storySrcPath} - | coffee --stdio >#{destPre}#{siteName}/#{category}/#{slug}.html"
    else
      story.set 'accepted',false
      story.set 'embargo',moment year: 2030
      console.log "removing #{destPre}#{siteName}/#{category}/#{slug}.html"
      execSync "rm -f #{destPre}#{siteName}/#{category}/#{slug}.html"
      fs.linkSync storySrcPath,"./domains/#{siteName}/unpublished/#{story.get 'id'}"
  #allFields is a sorted list of the keys of the story
  for siteName,collection of sitesStories
    fs.writeFileSync "#{destPre}#{siteName}/allstories.json","allStories="+JSON.stringify activeStories.toJSON()
    fs.writeFileSync "#{destPre}#{siteName}/mystories.json","myStories="+JSON.stringify collection.toJSON()
  fs.writeFileSync './nowstories.json', JSON.stringify stories.toWriteable()

task 'publish','start up the siteMaster build on sites', ()->
  publishAll()
    
task 'show','list fields of story',(cliArgs)->
  [myname,ids...] = cliArgs.arguments
  breakVal = false
  for id in ids
    s = stories.get id
    continue if !s
    console.log '-----------' if breakVal
    breakVal = true
    for k,v of s.attributes
      console.log k, ':', v
      
  process.exit 0


  
brunchify = (theSite,thePort,options) ->
    try
      console.log "Creating App for #{theSite}"
      opts=process.env
      opts["SITE"] = theSite
      brunch = spawn "brunch", ['watch', '-s', "-P", thePort],{
        env:opts
      }
    catch badHoodoo
      console.log badHoodoo
      process.exit()

    brunch.on 'error',(badHoodoo)->
      console.log badHoodoo
      console.log "Death from #{theSite}"
      process.exit()

    brunch.stdout.on 'data', (data) ->
        console.log "#{theSite}::#{data}"

    brunch.stderr.on 'data', (data) ->
        console.log "#{theSite}::#{data}

    brunch.on 'exit', (code) ->
        console.log "#{theSite}:: exit with code: #{code}"

    return brunch


task 'upload',"Rsync all Sites to the Cloud.", ()->
  Rsync = require('rsync');
  for domain in fs.readdirSync 'domains'
    subSite = (require domain)[domain]
    console.log "Starting Rsync on site #{domain} -- #{subSite.title}"
    # Build the command
    rsync = new Rsync()
      .shell 'ssh'
      .flags 'vraz'
      .delete()
      .exclude '.git'
      .exclude '.DS_Store'
      .source "./public-#{domain}/"
      .destination subSite.rsyncDestination

    #Execute the command
    rsync.execute (error, code, cmd)->
      #we're done
      console.log "Error (#{error}) on rsync for #{subSite}" if error
      console.log "rsync exit code #{code}"
      console.log "rsync on #{subSite}:", cmd

task 'dumpSites','sites to JSON',()->
  console.log JSON.stringify sites.toWriteable()
  
task 'dumpStories','stories to JSON',()->
  console.log JSON.stringify stories.toWriteable()
  
task 'upgradeDraft','set acceptance and embargo to published', (id)->
  [myname,drafts...] = id.arguments
  for id in drafts
    s = stories.get id
    continue unless s
    s.set 'accepted',true
    s.set 'embargo', moment()
    s.set 'published', moment()
  invoke 'dumpStories'  
  process.exit 0

task 'downgradeDraft','unset acceptance and embargo to published', (id)->
  [myname,drafts...] = id.arguments
  for id in drafts
    s = stories.get id
    continue if !s
    s.set 'accepted',false
  invoke 'dumpStories'  
  process.exit 0

task 'toYml','dump DB entry as coffee-script',(cli)->
  [myname,drafts...] = cli.arguments
  for id in drafts
    s=stories.get id
    console.log s.fieldsOf ' '
    
    
option '-i', '--id storyid', 'story ID to bump'

Processes = {}
task 'go','start up the siteMaster build on sites', ()->
  console.log "start"
  s = ['./lib']
  for theSite, thePort of Sites
    console.log "brunchify - #{theSite} - http://localhost:#{thePort}/"
    Processes[theSite] = brunchify theSite,thePort
    s.push "domains/#{theSite}"
  console.log "starting Publisher on sites ",s
  publishAll s
  console.log "started"
