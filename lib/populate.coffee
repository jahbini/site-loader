yamljs = require 'yamljs'
html2markdown = require 'html2markdown'
_ = require 'underscore'
Backbone = require 'backbone'
minimist = require 'minimist'
ymljsFrontMatter = require 'yamljs-front-matter'
caseMunger = require 'slug'
path = require 'path'
fs = require 'fs'
mkdirp = require 'mkdirp'
sites = require './sites/_lib/sites'
console.log "Sites!!",sites

caseMunger.defaults.mode = 'rfc3986'
caseMunger.remove = /[.]/g

kinds = {}
transforms =
  ID: "numericId"
  ClassName: "className"
  Created: "created"
  LastEdited: "lastEdited"
  Subject: "title"
  Sent: "published"
  Kind: "category"
  Taglist: "tagList"
  Message: "content"
  NextID: "nextID"
  PreviousID: "previousID"

try
  fs.mkdirpSync "site"
catch

###
#V1 of upgradeStory == All stories of st john's jim have been upgraded
# and no longer need this specific processing.  It remains here as
# a record of what needed to be done, and a tempate of how to do stuff.
###
upgradeStoryOld = (story)->
  if story.get 'debug'
    debugger
  oldStyle = false
  head = story.clone()
  for key, value of head.attributes
    xform = transforms[key]
    continue unless xform
    oldValue = story.get key
    story.unset key
    if oldValue != null
      oldStyle = true
      story.set xform, value

  if oldStyle
    #create the slug
    story.set 'slug', caseMunger (story.get 'title'),
        remove: /[.]/g
    # upgrade the options header for the layout engines
    story.set "_options",
      layout: "default"
      partials: ""
    # remove grandfather's styling
    content = story.get "content"
    content = content.replace /style="[^"]*"/g ,''
    content = content.replace /<p\s*>[&nbsp;|\s]*<\/p>/g, ''
    story.set content: content
    content = story.get "content"
    noBrakets = content.replace /\[/g,'{{{'
    noBrakets = noBrakets.replace /\]/g,'}}}'
    story.set "content", html2markdown noBrakets


###
# second style change.  Minimal changes to header - remove old '_options'
# Create inclusion sets for graph-walks, menu-lists, and such
###
upgradeStory = (story)->
  story = new Story story
  story.death "call to Obsolete function upgradeStory"
  if story.get 'debug'
    debugger
  v = story.get 'hVersion'
  if v >= 0.2
    return story
  story.set siteHandle: "stjohnsjim"
  story.set domain: "stjohnsjim.com"
  if v >= 0.1
    story.set hVersion: 0.2
    return story
  story.set hVersion: 0.1
  oldStyle = story.get "_options",
  if oldStyle
    # upgrade the options header for the layout engines
    story.unset "_options"
  story.set 'memberOf' ,[]
  content = story.get "content"
  memberOf = story.get 'memberOf'
  if content.match /daough|pathy|winnie/i
    memberOf.push 'TAO'
  if content.match /tommy|gunas|southwick|roger/i
    memberOf.push 'GUNAS'
  if content.match /tarot|aramis|king|pentacles|cups|swords|wands/i
    memberOf.push 'TAROT'
  if content.match /slim's|hope for health|james john|st john|saint john/i
    memberOf.push 'PDX'
  return story

keyWords = {}
massageStory = (story,rawStory)->
  # we want to canvass all the stories to get the quiklinks
  newStory = upgradeStory rawStory
  content = story.get "content"
  matched = content.match /{{{[^{}]*}}}/g
  snippets = story.get 'snippets'
  snippets = {} unless snippets
  if matched
    console.log matched if story.get 'debug'
    for msg in matched
      mpArray = msg.split ':'
      console.log mpArray , mpArray.length if story.get 'debug'
      if mpArray.length >1
        mpArray.pop()
      while mpArray.length >1 && (mpArray[1].length >15 || mpArray[2]?.length>15)
        console.log 'Trimming',mpArray if story.get 'debug'
        mpArray.pop()
      mpString = mpArray.join ","
        .toLowerCase()
      mpString = mpString.replace /[{}]/g,''
      console.log "Finally - #{mpString}" if story.get 'debug'
      snippets[mpString] = mpString
      if keyWords[mpString]
        keyWords[mpString] += 1
      else
        keyWords[mpString] = 1
  story.set 'snippets', snippets
  return story

writeStory = (story)->
  if story.get 'debug'
    debugger
  content = story.get 'content'

  head = story.clone().attributes
  delete head.content
  headMatter = ymljsFrontMatter.encode head, content
  fileName = "site/#{head.siteHandle}/#{head.category}/#{head.slug}.md"
  try
    mkdirp.sync "site/#{head.siteHandle}/#{head.category}"
  catch
  try
    fs.writeFileSync(fileName,headMatter )
  catch badDog
    console.log badDog
    process.exit()

  return


parseFiles = (site,options)->
  stories = yamljs.parseFile "./#{site}.yml"
  console.log "opening #{site}.yml"
  for story in stories
    storyNew = new Story story
    try
      story = massageStory storyNew, story
      allStories.push story
      console.log "massage OK: #{story.get "title"}"
    catch e
      console.log "story had problems - #{storyNew.get "title"}"
      console.log e
###
#main program starts here
###
Story = Backbone.Model.extend idAttribute: 'title'
AllStories = Backbone.Collection.extend model: Story , comparator: 'title'
allStories = new AllStories
for site, params of sites
  parseFiles site, params
allStories.sort()
allStories.each writeStory
debugger
newYml = allStories.sort().toJSON()
newYml = yamljs.stringify newYml
fs.writeFileSync 'story_new.yml', newYml
for matched, many of keyWords
  console.log "key #{matched} occurred #{many} times"
return