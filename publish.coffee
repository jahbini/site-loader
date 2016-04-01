yamljs = require 'yamljs'
html2markdown = require 'html2markdown'
_ = require 'underscore'
Backbone = require 'backbone'
minimist = require 'minimist'
path = require 'path'
mkdirp = require 'mkdirp'

caseMunger = require 'slug'
caseMunger.defaults.mode = 'rfc3986'
caseMunger.remove = /[.]/g

fs = require 'fs'
{  copyTreeSync
  walkTreeSync
  walkSync} = require 'walk_tree'

sitePath = path.resolve "./site"
publicPath = path.resolve "./public"
appPath = path.resolve "./app"

{SubSiteStory,SubSiteStories,allStories} = require './lib/sub-site'
Sites = require './site/_lib/sites'

template = require "./site/_lib/layouts/stjohnsjim"
stjohnsjimTemplate = new template SubSiteStories,SubSiteStories,publicPath,appPath
template = require "./site/_lib/layouts/bamboosnow"
bamboosnowTemplate = new template SubSiteStories,SubSiteStories,publicPath,appPath
Sites['stjohnsjim'].Story = StJohnsJimStory = class extends SubSiteStory
  siteHandle: 'stjohnsjim'
  template: stjohnsjimTemplate
Sites['bamboosnow'].Story = BambooSnowStory = class extends SubSiteStory
  siteHandle: 'bamboosnow'
  template: bamboosnowTemplate
  parser: (stuff)->
    if stuff.id
      stuff.numericId = stuff.id
      delete stuff.id
    if stuff.Handle
      stuff.handle = stuff.Handle
      delete stuff.Handle
    return

allStories.setSites Sites

walkTreeSync sitePath, allStories.testFile, allStories.getFile
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
allStories.expand()

console.log "Publishing stories"
allStories.publish()
allStories.writeNew('newSite')

theSummary = allStories.summarize()
fs.writeFileSync "#{appPath}/generated/all-posts.js", "module.exports = #{JSON.stringify theSummary};"
fs.writeFileSync "#{appPath}/generated/sites.js", "module.exports = #{JSON.stringify Sites};"
console.log "Publication complete."
