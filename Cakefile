#cakefile
chokidar=require 'chokidar'
Backbone = require 'backbone'
_=require 'underscore'
fs = require 'fs'
moment = require 'moment'

{spawn,exec,execSync} = require 'child_process'


SitesJSON = require './sitedef.json'
class Site extends Backbone.Model
  toWriteable:()=>
    raw = @.toJSON()
    delete raw.id
    delete raw.name
    delete raw.fields
    structure = 
      id: @id
      name: @.get 'name'
      fields: raw
    structure

class Sites extends Backbone.Collection
  model: Site
  toWriteable:()=>
    return 
      results:@.map (site)->site.toWriteable()
      count: @.size()

sites = new Sites
for site in SitesJSON.results
  fields=site.fields
  fields.id = site.id
  fields.name = site.name
  sites.add fields
  #console.log "site fields", fields
  
#test = sites.get '59781236d3cfff7cc5f92609'
#console.log "TEST ",test
#process.exit 0
StoriesJSON = require './stories244.json'

class Story extends Backbone.Model
  toWriteable:()=>
    raw = @.toJSON()
    delete raw.id
    delete raw.name
    delete raw.fields
    structure = 
      id: @id
      name: @.get 'name'
      fields: raw
    structure

class Stories extends Backbone.Collection
  model: Story
  toWriteable:()=>
    return 
      results:@.map (site)->site.toWriteable()
      count: @.size()

stories = new Stories
for story in StoriesJSON.results
  fields=story.fields
  fields.id = story.id
  fields.snippets ='{}' unless fields.snippets
  fields.author = '' unless fields.author
  fields.name = story.name
  delete fields.content
  stories.add fields

sitesStories = {}

analyzeRawStories = ()->
  allFields = ''
  stories.each (story)->
    keys = []
    keys.push key for key of story.attributes
    fieldsOf =_(keys).sortBy().join ' '
    console.log fieldsOf if fieldsOf != allFields
    allFields = fieldsOf
  

publishAll = () ->
  activeStories = new Stories
  destPre = './public-'
  execSync 'rm -f ./domains/*/unpublished/*'
  stories.each (story)->
    theSite = sites.get story.get 'site'
    siteName = theSite.get 'name'
    category = story.get 'category'
    category = category.replace /\ /g,'%20'
    slug = story.get 'slug'
    
    
    execSync "mkdir -p #{destPre}#{siteName}/#{category}"
    execSync "mkdir -p ./domains/#{siteName}/unpublished"
    console.log 'embargo', story.get 'embargo'
    console.log 'decision',  moment(story.get 'embargo') < moment()
    storySrcDir = "./domains/#{siteName}/templates/#{category}/#{slug}"
    storySrcPath = storySrcDir + ".coffee"
    # remove bogus category of '-' for index files
    category = '.' if category == '-'
    if story.get('accepted') && moment(story.get 'embargo') < moment()
      if !sitesStories[siteName]
        sitesStories[siteName] = new Sites
      sitesStories[siteName].add story
      activeStories.add story
      console.log "publishing to #{destPre}#{siteName}/#{category}/#{slug}.html"
      execSync "cp -rf #{storySrcDir} #{destPre}#{siteName}/#{category} || true"
      execSync "cat domains/#{siteName}/templates/#{siteName}template.coffee #{storySrcPath} | coffee --stdio >#{destPre}#{siteName}/#{category}/#{slug}.html"
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
