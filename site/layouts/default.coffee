###
styling: "skeleton"
_options:
    headlogo: "site/layouts/header-logo-nav"

###
{render,doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,blockquote,
 tag,footer} = require "teacup"
path = require 'path'
headerLogoNav = require(path.resolve './site/layouts/header-logo-nav')
Backbone = require 'backbone'
fs = require 'fs'

module.exports = class ClassLookAndFeel

  constructor: (@StoryModel,@CollectionModel,@public,@app) ->
    @jSONarchive = new @CollectionModel
    @snippetArchive = new @CollectionModel
    @handleArchive = new @CollectionModel

  expandSnippets: (story)=>
    snippets = story.get 'snippets'
    snippetHandled = true
    for snippet of snippets
      continue unless snippet
      cooked = story.get 'cooked'
      snippetHandled = false
      handledBy = @handleArchive.find (model)->
        return snippet.toUpperCase() == (model.get 'handle').toUpperCase()
      if handledBy
        cooked = cooked.replace ///{{{#{snippet}:(.*)}}}///ig , (match)->
          match =match.replace '{{{',''
          match =match.replace '}}}',''
          match = match.split /:|,/
          render ->
            a ".goto", href: (handledBy.get "href"), match[1]
        story.set cooked:cooked
        snippetHandled = true
        continue
      key = snippet.split /,|:/
      op = key.shift().toLowerCase()
      who = key.shift()
      switch op
        when "author"
          console.log "Author appears in #{story.get 'slug'}"
          debugger
          cooked = cooked.replace /{{{author:.*}}}/ig, (match) ->
            match =match.replace /{{{author:/,''
            match =match.replace '}}}',''
            return render ->
              blockquote ".left.key-author",match
          snippetHandled = true
        when "first name"
          #first name is a simple replacement with client-side heads-up
          cooked = cooked.replace /{{{first.name}}}/ig , render ->
            span ".FBname", 'Friend'
          story.set cooked: cooked
          snippetHandled = true
        when "sms"
          cooked = cooked.replace ///{{{#{op}[,:]#{who}.*}}}///ig, (match)->
            match =match.replace '{{{',''
            match =match.replace '}}}',''
            match = match.split /:|,/
            match.shift()
            match.shift()
            rest = match.join ':'
            return render ->
              blockquote ".right.key-#{op}.#{who}", ->
                raw "#{who} says: #{rest}"
          story.set cooked:cooked
          snippetHandled = true
          continue

        when "comment"
          cooked = cooked.replace ///{{{#{op}[,:]#{who}.*}}}///ig, (match)->
            match =match.replace '{{{',''
            match =match.replace '}}}',''
            match = match.split /:|,/
            match.shift()
            match.shift()
            rest = match.join ':'
            return render ->
              blockquote "right.key-#{op}.#{who}", ->
                raw "#{who} says: #{rest}"
          story.set cooked:cooked
          snippetHandled = true
          continue

    return if snippetHandled
    @snippetArchive.push snippet: snippet, title: snippet, href: story.get 'href'
    console.log "snippet failure on #{snippet}"

  analyze: (story)=>
    if 'snippet'== story.get 'debug'
      debugger
    handle = story.get 'handle'
    if handle
      console.log "Handle #{handle} defined in story #{story.get 'slug'}"
      @handleArchive.push story
    return

  expand: (story)=>
    # actions on second pass of analysis
    if story.get 'snippets'
      if @expandSnippets story
        #unresolved Handle type snippet.  need second pass.
        return true
    tmp = story.clone()
    @jSONarchive.push tmp
    return false

  summarize: (collection)=>
    console.log JSON.stringify @snippetArchive.toJSON()
    theSummary = @jSONarchive.map (story)=>
      t=story.clone()
      t.unset 'cooked'
      t.unset 'content'
      t.unset 'html'
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
