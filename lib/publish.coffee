yamljs = require 'yamljs'
html2markdown = require 'html2markdown'
_ = require 'underscore'
Backbone = require 'backbone'
minimist = require 'minimist'
path = require 'path'
mkdirp = require 'mkdirp'
moment = require 'moment'
CommandLineOptions = require('commander')

console.log("Publishing #{CommandLineOptions.args.join(", ")} with:")
if (CommandLineOptions.yml)
  console.log('  - YML summaries of all sites')
if (CommandLineOptions.generateJson)
  console.log('  - Generated JSON in app/generated')
if (CommandLineOptions.publish)
  console.log("  - all stories compiled into public- sites")
siteArray = CommandLineOptions.args
Sites = {}
localPort = null
try
  localService = CommandLineOptions.localService
  if localService
    localIncrement = parseInt localService[1]
    localPort = parseInt localService[0]
catch badPort
  console.log "Local Port configuration error - badPort"
  process.exit(1)

for subSite in siteArray
  Sites[subSite] = (require "#{subSite}")[subSite]
  if localPort
    console.log "Site #{subSite} served on 0.0.0.0:#{localPort}"
    Sites[subSite].lurl = "0.0.0.0:#{localPort}"
    localPort += localIncrement


caseMunger = require 'slug'
caseMunger.defaults.mode = 'rfc3986'
caseMunger.remove = /[.]/g

fs = require 'fs'
{  copyTreeSync
  walkTreeSync
  walkSync} = require 'walk_tree'

appPath = path.resolve "./app"

{SubSiteStory,SubSiteStories,allStories} = require './sub-site'

for subSite, contents of Sites
  contents.template = require "#{subSite}/brunch-payload-/#{subSite}"
  contents.template = new contents.template

  contents.Story = class extends SubSiteStory
    siteHandle: subSite
    template: contents.template
    parser: (stuff)->
      #set a stiff embargo on everybody
      stuff.embargo= moment().endOf('year').format() unless stuff.embargo
      return


allStories.setSites Sites
for subSite, contents of Sites
  walkTreeSync "./node_modules/#{subSite}/contents", allStories.testFile, allStories.getFile
console.log "allStories has #{allStories.length} elements"

console.log "allStories - pub yml"
allStories.sort()

if (CommandLineOptions.yml)
  yml = allStories.toJSON()
  yml = yamljs.stringify yml
  console.log "creating allStories-pub.yml"
  fs.writeFileSync "allStories-pub.yml", yml

# Start the publication phases
# create the publication root
# analyze the stories en-mass
# format the stories
# write the stories

console.log "analyzing stories"
if allStories.analyze()
   allStories.analyze()

console.log "Expanding stories"
allStories.each (story) -> story.expand()

if CommandLineOptions.publish
  console.log "Publishing stories"
  allStories.publish()
if CommandLineOptions.newSite
  allStories.writeNew('newSite')

if CommandLineOptions.generateJson
  theSummary = allStories.summarize()
  fs.writeFileSync "#{appPath}/generated/all-posts.js", "module.exports = #{JSON.stringify theSummary};"
  fs.writeFileSync "#{appPath}/generated/sites.js", "module.exports = #{JSON.stringify Sites};"
console.log "Publication complete."
