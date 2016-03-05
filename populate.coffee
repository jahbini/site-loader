yamljs = require 'yamljs'
html2md = require 'html2markdown'
_ = require 'underscore'
minimist = require 'minimist'
ymljsFrontMatter = require 'yamljs-front-matter'
caseMunger = require 'slug'
fs = require 'fs'

caseMunger.defaults.mode = 'rfc3986'
caseMunger.remove = /[.]/g

kinds = {}
transforms =
  ID: "id"
  ClassName: "className"
  Created: "created"
  LastEdited: "lastEdited"
  Subject: "title"
  Sent: "published"
  Kind: "category"
  Taglist: "tagList"
  Message: null
  NextID: "nextID"
  PreviousID: "previousID"

try
  fs.mkdirSync "site"
catch

writeFile = (data)->
  head = {}
  for key, value of data
    xform = transforms[key]
    head[xform] = value if xform
  head._options =
    layout: "#{process.cwd()}/site/layouts/default.static.ttml"
    partials: ""

  content = data.Message
  content = content.replace /style="[^"]*"/g ,''
  content = content.replace /<p\s*>[&nbsp;|\s]*<\/p>/g, ''
  matched = content.match /\[[^\]]/g
  console.log matched
  head['slug'] = caseMunger head.title,
      remove: /[.]/g

  headMatter = ymljsFrontMatter.encode head, content
  try
    fs.mkdirSync "site/"+head.category
  catch

  fileName = "site/"+head.category+"/"+head.slug+".static.md"
  fs.writeFileSync(fileName,headMatter )
  return

stories = yamljs.parseFile 'story.yml'

for story in stories
  console.log story.Subject

for story in stories
    # body...
    try
      writeFile story
      console.log "story OK: " + story.Subject
    catch e
      console.log "story had problems - " + story.Title
      console.log e
  console.log "story Fini"

return
