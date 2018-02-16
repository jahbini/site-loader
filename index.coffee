#
B=require 'backbone'
_=require 'underscore'

FS=require 'fs'
{execSync} = require 'child_process'

rawStories = FS.readFileSync 'stories245.json'
cookedStories = (JSON.parse rawStories).results

rawSites = FS.readFileSync 'sites.json'
cookedSites = (JSON.parse rawSites).results
allSites = {}

#_(cookedStories).map (m)->
#  console.log m.name
#  console.log "different!", m if m.name != m.fields.title

_(cookedSites).map (m)->
  allSites[m.id] = m.fields
#  console.log m.id

#console.log allSites

oldSiteName = ''
_(cookedStories).sortBy('site').map (m)->
  return if !m
  site = m.fields.site
  if !site
    console.log "bad story:",m
    return
  {slug,category} = m.fields
  cleanSlug = slug
  cleanSlug = '_'+ slug if slug.match /^\d/
  category = category.replace /\ /g,'%20'
  siteName = allSites[site].name
  path = "#{siteName}/#{category}/#{slug}"
  console.log path
  #execSync "mkdir -p html/#{siteName}/#{category}"
  #execSync "mkdir -p templates/#{siteName}/#{category}"
  #execSync "curl http://#{siteName}.com/#{category}/#{slug}.html >html/#{path}.html"
  #if oldSiteName != siteName
  #  execSync "html2coffeekup --export=#{siteName}template --prefix='T.' html/#{path}.html >templates/#{siteName}template.coffee"
  #oldSiteName = siteName
  try
  #  execSync "html2coffeekup --export=#{cleanSlug.replace /-/g, "_"} --extends=#{siteName}template --prefix='T.' html/#{path}.html >templates/#{path}.coffee"
    execSync "mkdir -p ../public-#{siteName}/#{category}"
    execSync "cat domains/#{siteName}/templates/#{siteName}template.coffee domains/#{siteName}/templates/#{category}/#{slug}.coffee | coffee --stdio >../public-#{siteName}/#{category}/#{slug}.html"
  catch badDog
    console.error "BARK! BaRK!",badDog
  
  return
