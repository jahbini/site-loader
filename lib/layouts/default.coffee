{render,doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,blockquote,img,hr,
 tag,footer} = require "teacup"
path = require 'path'
Backbone = require 'backbone'
fs = require 'fs'
_=require 'underscore'


marked = require 'marked'
markedRenderer = new marked.Renderer()
marked.setOptions({
  renderer: markedRenderer
  gfm: true,
  tables: true,
  breaks: false,
  pedantic: false,
  sanitize: false,
  smartLists: true,
  smartypants: true
});

module.exports = class ClassLookAndFeel
  oldMarkedRenderer = {}
  constructor: (@StoryModel,@CollectionModel,@public,@app) ->
    @jSONarchive = new @CollectionModel
    @snippetArchive = new @CollectionModel
    @handleArchive = new @CollectionModel
    @oldMarkedRenderer = {}

  setMarkedRenderer: (tag,newMarkedRenderer) ->
    bind = (fn, me)->
      return ()->
        return fn.apply(me, arguments)
    @oldMarkedRenderer[tag] = markedRenderer[tag] unless @oldMarkedRenderer[tag]
    oldR = @oldMarkedRenderer[tag]
    nr = bind newMarkedRenderer, @
    markedRenderer[tag] = (a,b,c,d,args...) ->
      r=bind oldR,this
      try
        return  nr a,b,c,d,args
      catch badPuppy
        if badPuppy == 'useOld'
          console.log "using oldMarkedRenderer"
          try
            temp = r a,b,c,d,args
            console.log "Rendered Contents by marked -- #{temp}"
            return temp
          catch nasty
            story.death "Unable to render #{tag} via marked or internal",nasty
      story.death "Unable to render #{tag} via internal",badPuppy

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
                blockquote ".right.key-author.right-align.h6.p2.bg-white.bg-darken-1.border.rounded", ->
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

    @setMarkedRenderer 'image', (href,title,text)=>
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
            console.log href,title,text,story.get 'slug'
            dieLater = true
          return result
      fullName =val.join ''
      console.log "first"
      smallName = fullName.match /[^\/]*$/
      images = story.get 'images'
      if !images
        images = []
      console.log "half", images
      thumbName = smallName.toString().replace /\./,'-t.'
      images.push smallName.toString()
      images.push thumbName
      console.log "3/4", images
      story.set 'images',images
      console.log "second"
      story.copyAsset smallName
      story.copyAsset thumbName

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
      story.death "Augmented Markdown Failure", badPuppy
    if dieLater
      console.log "Cooked:", story.tmp.cooked
      story.death "fixme!!"
    tmp = story.clone()
    @jSONarchive.push tmp
    return false

  formatStory: renderable (story) =>
    headMatter = require './head'
    headerLogoNav = require './header-logo-nav'
    options = story.attributes
    headMatter story
    comment "\nThe Body\n"
    body "#body.enclosing", ->
      div "#{head}", ->
        headerLogoNav story
      section ".app-container.py4", "data-id":"app"
      comment "\nThe Main template\n"
      div "#main.wrapper.mxn2.flex.flex-wrap", "data-behavior": "1", ->
        section ".postShorten-group.main-content-wrap.container.px2.col-12.border.rounded", ->
          div ".clearfix", ->
            comment "\nContent\n"
            div "#content.col.col-5.p2.justify", ->
              h4 options.title
              hr
              raw story.tmp.cooked
            div "#story.col.col-4.p2.border-left", ->
            comment "\nSidebar2"
            div "#sidebar2.right.col.col-3.p2.border-left", ->
              a href:'showit', "this is contents of sidebar"
      tag 'footer', "data-id":"footer"
      div "#cover", style:"background-image:url('/images/cover.jpg');"
