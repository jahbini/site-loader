yamljs = require 'yamljs'
html2markdown = require 'html2markdown'
_ = require 'underscore'
Backbone = require 'backbone'
minimist = require 'minimist'
ymljsFrontMatter = require 'yamljs-front-matter'
caseMunger = require 'slug'
path = require 'path'
fs = require 'fs'

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
  fs.mkdirSync "site"
catch

upgradeStory = (story)->
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

keyWords = {}
massageStory = (story)->
  # we want to canvass all the stories to get the quiklinks
  upgradeStory story
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
  return

writeStory = (story)->
  if story.get 'debug'
    debugger
  content = story.get 'content'

  head = story.clone().attributes
  delete head.content
  headMatter = ymljsFrontMatter.encode head, content
  try
    fs.mkdirSync "site/"+head.category
  catch

  fileName = "site/"+head.category+"/"+head.slug+".md"
  fs.writeFileSync(fileName,headMatter )
  return

Story = Backbone.Model.extend idAttribute: 'title'
AllStories = Backbone.Collection.extend model: Story , comparator: 'title'
allStories = new AllStories

stories = yamljs.parseFile 'story.yml'
for story in stories
  story = new Story story
  try
    massageStory story
    console.log "massage OK: #{story.get "title"}"
  catch e
    console.log "story had problems - #{story.get "title"}"
    console.log e
  allStories.push story
allStories.sort()
allStories.each writeStory
debugger
newYml = allStories.sort().toJSON()
newYml = yamljs.stringify newYml
fs.writeFileSync 'story_new.yml', newYml
for matched, many of keyWords
  console.log "key #{matched} occurred #{many} times"
return
