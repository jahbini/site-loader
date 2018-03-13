#
# global srp
#
#  CoffeeScript.run fs.readFileSync('Cakefile').toString(), filename: 'Cakefile'

_ = require 'underscore'
fs = require 'fs'
CoffeeScript = require 'coffee-script'

blend= (l)->
  CoffeeScript.run (l.join '\n')
  return
  
srp.expand = (story)->
  destPre = './public-'
  theSite = srp.sites.get story.get 'site'
  siteName = theSite.get 'name'
  category = story.get 'category'
  category = category.replace /\ /g,'_'
  slug = story.get 'slug'
  
  siteTemplateFile ="./domains/#{siteName}/templates/#{siteName}template.coffee"
  storySrcDir = "./domains/#{siteName}/templates/#{category}/#{slug}"
  storySourcePath = "./#{storySrcDir}.coffee"
  htmlDest = "#{destPre}#{siteName}/#{category}/#{slug}.html"
  
  #fs.writeFileSync storySourcePath, storySource
  
  blend [
    """
#preamble
    """
    fs.readFileSync siteTemplateFile,'utf-8'
    srp.source = fs.readFileSync storySourcePath,'utf-8'
    """
#postamble
srp.rendered = rendered
srp.db= db[id]
    """
    ]
