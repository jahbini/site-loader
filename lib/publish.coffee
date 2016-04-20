yamljs = require 'yamljs'
html2markdown = require 'html2markdown'
_ = require 'underscore'
Backbone = require 'backbone'
minimist = require 'minimist'
path = require 'path'
mkdirp = require 'mkdirp'
moment = require 'moment'

caseMunger = require 'slug'
caseMunger.defaults.mode = 'rfc3986'
caseMunger.remove = /[.]/g

fs = require 'fs'
{  copyTreeSync
  walkTreeSync
  walkSync} = require 'walk_tree'

appPath = path.resolve "./app"

{SubSiteStory,SubSiteStories,allStories} = require './sub-site'
Sites = require '../sites'
for subSite, contents of Sites
  _(contents).extend  (require "#{subSite}")[subSite]
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
yml = allStories.toJSON()
yml = yamljs.stringify yml
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

console.log "Publishing stories"
allStories.publish()
allStories.writeNew('newSite')

theSummary = allStories.summarize()
fs.writeFileSync "#{appPath}/generated/all-posts.js", "module.exports = #{JSON.stringify theSummary};"
fs.writeFileSync "#{appPath}/generated/sites.js", "module.exports = #{JSON.stringify Sites};"
console.log "Publication complete."
