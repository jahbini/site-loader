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
StoriesJSON = require './story-db.json'
{Story,Stories,buildStories,makeStory} = require './lib/story-stories.coffee'
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
  next()
  #execSync "cat domains/#{siteName}/templates/#{siteName}template.coffee #{storySrcPath} | coffee --stdio >#{destPre}#{siteName}/#{category}/#{slug}.html"
  
global.srp = {sites:sites}
task 'srp','split, run and publish', (cli)->
  destPre = "./public-"
  dbChanged = false
  # if one of the stories has modified the DB, write it back out
  dbHelper = ()->
    if dbChanged
      fs.writeFileSync './story-db.json', JSON.stringify stories.toWriteable()
    # write out the new json db files
    for siteName,collection of sitesStories
      fs.writeFileSync "#{destPre}#{siteName}/allstories.json","allStories="+JSON.stringify activeStories.toJSON()
      fs.writeFileSync "#{destPre}#{siteName}/mystories.json","myStories="+JSON.stringify collection.toJSON()
    return
    
  doStory =(story)->
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
    
    console.log "processed #{slug}"
    # now publish the story
    # remove bogus category of '-' for index files
    category = '.' if category == '-'

    if story.canPublish()
      if !sitesStories[siteName]
        sitesStories[siteName] = new Sites
      if 'error' != story.get 'category'
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
  fs.writeFileSync "nowstories.json", JSON.stringify stories.toWriteable()
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
