###
styling: "skeleton"
_options:
    headlogo: "site/layouts/header-logo-nav"

###
{render,doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,blockquote,
 tag,footer} = require "teacup"
path = require 'path'
headerLogoNav = require(path.resolve './layouts/header-logo-nav')
Backbone = require 'backbone'
fs = require 'fs'

module.exports = class ClassLookAndFeel

  constructor: (@StoryModel,@CollectionModel,@public,@app) ->
    @jSONarchive = new @CollectionModel
    @snippetArchive = new @CollectionModel
    @handleArchive = new @CollectionModel

  expandSnippets: (story)=>
    console.log "in expandSnippets #{story.get 'slug'}"
    if !story
      console.log "no story"
      process.exit()
    if 'content' == story.get 'debug'
      story.snap "in expandSnippets #{story.get 'slug'}"
    if ! story.get 'cooked'
      story.death 'no cooked!'
    snippets = story.get 'snippets'
    snippetHandled = true
    for snippet of snippets
      continue unless snippet
      console.log "expandSnippets #{snippet} #{story.get 'slug'}"

      cooked = story.get 'cooked'
      snippetHandled = false
      handledBy = @handleArchive.find (model)->
        return snippet.toUpperCase() == (model.get 'handle').toUpperCase()
      if handledBy
        console.log "handledBy #{handledBy.get 'slug'}"
        cooked = cooked.replace ///{{{#{snippet}:(.*)}}}///ig , (match)->
          match =match.replace '{{{',''
          match =match.replace '}}}',''
          match = match.split /:|,/
          render ->
            a ".goto", href: handledBy.href(@siteHandle), match[1]
        story.set cooked:cooked
        snippetHandled = true
        console.log "handled!"
        continue
      key = snippet.split /,|:/
      op = key.shift().toLowerCase()
      who = key.shift()
      switch op
        when "author"
          console.log "Author appears in #{story.get 'slug'}"
          cooked = cooked.replace /{{{author[,:\s]+([^}]*)}}}/ig, (match,more) ->
            console.log "match contents {#{more}}"
            return render ->
              blockquote ".left.key-author", ->
                raw more
          story.set cooked: cooked
          snippetHandled = true
        when "first name"
          #first name is a simple replacement with client-side heads-up
          cooked = cooked.replace /{{{first.name}}}/ig , render ->
            span ".FBname", 'Friend'
          story.set cooked: cooked
          snippetHandled = true
        when "sms"
          cooked = cooked.replace ///{{{#{op}[,:]#{who}[,:\s+]([^}]*)}}}///ig, (match,more)->
            return render ->
              blockquote ".right.key-#{op}.#{who}", ->
                raw "#{who} says: #{more}"
          story.set cooked:cooked
          snippetHandled = true
          continue

        when "comment"
          cooked = cooked.replace ///{{{#{op}[,:]#{who}[,:\s]+([^}]*)}}}///ig, (match,more)->
            return render ->
              blockquote "right.key-#{op}.#{who}", ->
                raw "#{who} says: #{more}"
          story.set cooked:cooked
          snippetHandled = true
          continue

    return if snippetHandled
    @snippetArchive.push snippet: snippet, title: snippet, href: story.href()
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
        console.log "expandSnippets #{story.get 'slug'} Unresolved!"
        return true
    console.log "expandSnippets #{story.get 'slug'} exit"
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
    return theSummary

  formatStory: renderable (story) =>
    options = story.attributes
    doctype 5
    html ->
      head ->
        title options.title||"no Title"
        meta title:"author", content:"James A. Hinds"
        meta "http-equiv": "content-type", content: "text/html; charset=utf-8"
        meta name: "description", content: "A great #{options.category}"
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        base href: "/"
        meta name: "keywords", content: "North Portland,St. John's, st johns"
        link rel: "stylesheet", href: "css/app.css"
        script src: 'js/vendor.js'
        script src: 'js/app.js'
        script "siteHandle = '#{options.siteHandle}'; require('initialize');"
      comment "\nThe Body\n"
      body "#body.enclosing", ->
        headerLogoNav story
        section ".app-container.py4", "data-id":"app"
        comment "\nThe Main template\n"
        div "#main.wrapper.mxn2.flex.flex-wrap", ->
          div ".container.px2.col-12.border.rounded", ->
            div ".clearfix", ->
              comment "\nContent\n"
              div "#content.col.col-4.p2.justify", ->
                raw options.cooked
              div "#story.col.col-4.p2.border-left", ->
                raw options.cooked
              comment "\nSidebar"
              div "#sidebar.col.col-4.p2.border-left", ->
                a href:'showit', "this is contents of sidebar"
        tag 'footer', "data-id":"footer"
