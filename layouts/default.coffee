###
styling: "skeleton"
_options:
    headlogo: "site/layouts/header-logo-nav"

###
{render,doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,blockquote,img,
 tag,footer} = require "teacup"
path = require 'path'
headerLogoNav = require(path.resolve './layouts/header-logo-nav')
Backbone = require 'backbone'
fs = require 'fs'
_=require 'underscore'


marked = require 'marked'
renderer = new marked.Renderer()
marked.setOptions({
  renderer: renderer
  gfm: true,
  tables: true,
  breaks: false,
  pedantic: false,
  sanitize: false,
  smartLists: true,
  smartypants: true
});

module.exports = class ClassLookAndFeel
  oldRenderer = {}
  constructor: (@StoryModel,@CollectionModel,@public,@app) ->
    @jSONarchive = new @CollectionModel
    @snippetArchive = new @CollectionModel
    @handleArchive = new @CollectionModel
    @oldRenderer = {}

  setRenderer: (tag,newRenderer) ->
    bind = (fn, me)->
      return ()->
        return fn.apply(me, arguments)
    @oldRenderer[tag] = renderer[tag] unless @oldRenderer[tag]
    oldR = @oldRenderer[tag]
    nr = bind newRenderer, @
    renderer[tag] = (a,b,c,d,args...) ->
      r=bind oldR,this
      try
        return  nr a,b,c,d,args
      catch badPuppy
        if badPuppy == 'useOld'
          console.log "using oldRenderer"
          try
            temp = r a,b,c,d,args
            console.log "Rendered Contents by marked -- #{temp}"
            return temp
          catch nasty
            console.log "mama mia!"
            console.log nasty
            process.exit()

      throw badPuppy

  expandSnippets: (story)=>
    if !story
      console.log "no story in expandSnippets"
      process.exit()
    story.snap "in expandSnippets #{story.get 'slug'}", 'content'
    snippets = story.get 'snippets'
    snippetHandled = true
    workingCopy = story.tmp.workingCopy
    for snippet of snippets
      continue unless snippet
      snippetHandled = false
      handledBy = @handleArchive.find (model)->
        return snippet.toUpperCase() == (model.get 'handle').toUpperCase()
      if handledBy
        workingCopy = workingCopy.replace ///{{{#{snippet}:(.*)}}}///ig , (match)->
          match =match.replace '{{{',''
          match =match.replace '}}}',''
          match = match.split /:|,/
          render ->
            a ".goto", href: handledBy.href(@siteHandle), match[1]
        snippetHandled = true
        continue

      key = snippet.split /,|:/
      op = key.shift().toLowerCase()
      who = key.shift()
      switch op
        when "author"
          console.log "Author appears in #{story.get 'slug'}"
          workingCopy = workingCopy.replace /{{{author[,:\s]+([^}]*)}}}/ig, (match,more) ->
            console.log "match contents {#{more}}"
            return render ->
              blockquote ".right.key-author.right-align.h6.p2.bg-white.border.rounded", ->
                raw more
          snippetHandled = true
        when "first name"
          #first name is a simple replacement with client-side heads-up
          workingCopy = workingCopy.replace /{{{first.name}}}/ig , render ->
            span ".FBname", 'Friend'
          snippetHandled = true
        when "sms"
          workingCopy = workingCopy.replace ///{{{#{op}[,:]#{who}[,:\s+]([^}]*)}}}///ig, (match,more)->
            return render ->
              blockquote ".right.key-#{op}.#{who}.right-align.h6.p2.bg-white.border.rounded", ->
                raw "#{who} says: #{more}"
          snippetHandled = true
          continue

        when "comment"
          workingCopy = workingCopy.replace ///{{{#{op}[,:]#{who}[,:\s]+([^}]*)}}}///ig, (match,more)->
            return render ->
              blockquote ".right.key-#{op}.#{who}.right-align.h6.p2.bg-white.border.rounded", ->
                raw "#{who} says: #{more}"
          snippetHandled = true
          continue

    story.tmp.workingCopy = workingCopy
    return false if snippetHandled
    @snippetArchive.push snippet: snippet, title: snippet, href: story.href()
    return true

  analyze: (story)=>
    story.tmp.workingCopy = story.get 'content'
    if (story.get 'debug').toString().match 'snippet'
      debugger
    if story.get 'snippets'
      if @expandSnippets story
        #unresolved Handle type snippet.  need second pass.
        console.log "expandSnippets #{story.get 'slug'} Unresolved!"

    handle = story.get 'handle'
    if handle
      console.log "Handle #{handle} defined in story #{story.get 'slug'}"
      @handleArchive.push story
    return

  expand: (story)=>
    dieLater = story.tmp.workingCopy.match /{%/

    @setRenderer 'image', (href,title,text)=>
      console.log href,title,text,story.get 'slug'
      throw 'useOld' unless href.match '@'
      val = _(href.split '@').map (snip)->
        return '' unless snip
        ourUrl = snip.replace /^([\w]*)(\W.*)$/,(match,ourword,theirword)->
          result = "nogo!"
          try
            result =story[ourword]()+theirword
          catch badPuppy
            console.log "Bad Dog! in template expand #{story.get 'slug'} #{badPuppy}"
            console.log "#{ourword}, and #{theirword}"
            dieLater = true
          return result
      fullName =val.join ''
      smallName = fullName.match /[^\/]*$/

      story.copyAsset smallName
      story.copyAsset smallName.toString().replace /\./,'-t.'

      #handle text portion
      altTextSplit = text.match /^([^@.#]*)?(@|#|\.)(.*)$/
      if !altTextSplit
        altText = text
        classText = ''
      else
        altText = altTextSplit[1]
        classText = if altTextSplit[3].match /^\.|#/
            altTextSplit[3]
          else
            '.'+altTextSplit[3]
        classText = '.'+classText unless classText.match /^\.|#/
        classText = classText.split " "
        classText = classText.join "."
      thumbnailImage = val.join ""
      thumbnailImage = thumbnailImage.replace /\.[^.]/,(match)-> "-t#{match}"
      if classText.match "fancybox"
        return render ->
          div ".figure #{classText}", style: "width:;", ->
            comment "href=#{href} title=#{title} text=#{text}"
            a ".fancybox", href: (val.join ""), title: title, ->
              img ".fig-img", src: thumbnailImage, alt: altText
            span ".caption", title

      return render ->
        img classText,
          title: title
          alt: altText
          src: val.join ""
        comment "href=#{href} title=#{title} text=#{text}"


    # actions on second pass of analysis
    if (story.get 'debug').toString().match 'snippet'
      debugger
    if story.get 'snippets'
      if @expandSnippets story
        #unresolved Handle type snippet.  need second pass.
        console.log "expandSnippets #{story.get 'slug'} Unresolved!"
    try
      story.tmp.cooked = marked.parser marked.lexer story.tmp.workingCopy
    catch badPuppy
      story.death "Hate, hate, hate", badPuppy
    if dieLater
      console.log "Cooked:", story.tmp.cooked
      story.death "fixme!!"
    tmp = story.clone()
    @jSONarchive.push tmp
    return false

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
                raw story.tmp.cooked
              div "#story.col.col-4.p2.border-left", ->
                raw story.tmp.cooked
              comment "\nSidebar"
              div "#sidebar.col.col-4.p2.border-left", ->
                a href:'showit', "this is contents of sidebar"
        tag 'footer', "data-id":"footer"
