###
styling: "skeleton"
_options:
    headlogo: "site/layouts/header-logo-nav"

###
{doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,
 tag,footer} = require "teacup"
path = require 'path'
headerLogoNav = require(path.resolve './site/layouts/header-logo-nav')
Backbone = require 'backbone'
fs = require 'fs'

module.exports = class ClassLookAndFeel

  constructor: (@StoryModel,@CollectionModel,@public,@app) ->
    @jSONarchive = new @CollectionModel

  analyze: (story)=>
    tmp = story.clone()
    @jSONarchive.push tmp
    return false  #return true means run all analyzers again

  summarize: (collection)=>
    theSummary = @jSONarchive.map (story)=>
      t=story.clone()
      t.unset 'cooked'
      t.unset 'content'
      t.unset 'cruft'
      return t.toJSON()
    fs.writeFileSync @app+'/all-posts.js', "module.exports = #{JSON.stringify theSummary};"
    return false  # true means run all analyzers again

  formatStory: renderable (story) ->
    options = story.attributes
    doctype 5
    html ->
      head ->
        title options.title||"no Title"
        meta "http-equiv": "content-type", content: "text/html; charset=utf-8"
        meta name: "description", content: "A great #{options.category}"
        meta name: "viewport", content: "width=device-width"
        base href: "/"
        meta name: "keywords", content: "North Portland,St. John's, st johns"
        link rel: "stylesheet", href: "stylesheets/app.css"
        script src: 'javascripts/vendor.js'
        script src: 'javascripts/app.js'
        script "require('initialize');"
      body "#body.enclosing", ->
        headerLogoNav story
        section ".app-container", "data-id":"app"
        comment "The Main template"
        div "#main.wrapper.style4", ->
          div ".container", ->
            div ".row", ->
              comment "Content"
              div "#content.eight.columns", ->
                raw options.cooked
              comment "Sidebar"
              div "#sidebar.four.columns", ->
                a href:'showit', "this is contents of sidebar"
        tag 'footer', "data-id":"footer"
