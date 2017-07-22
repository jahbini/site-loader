{doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,
 tag,footer} = require "teacup"
Backbone = require 'backbone'
_ = require 'underscore'
T=require 'teacup'
fs = require 'fs'
path = require 'path'
mkdirp = require 'mkdirp'
ymljsFrontMatter = require 'yamljs-front-matter'
moment = require 'moment'
sitePath = path.resolve "./domains"
publicPath = path.resolve "./public"
appPath = path.resolve "./app"
Sites = require "../sites"
CoffeeScript = require 'coffee-script'
http = require 'http'

marked = require 'marked'
allStories = {} # value assigned below

SubSiteStory = class Story extends Backbone.Model
  # tmp is a holder for transient and generated attrubutes

  markedRenderer = new marked.Renderer()
  initialize: ()->
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

    @oldMarkedRenderer = {}
    @tmp = []

  idAttribute: 'slug'
  defaults:
    debug:""
    
  toKeystone: (path= "http://bamboosnow.tell140.com/Story")->
    body =  @.toJSON()
    body.site = body.siteHandle
    delete body['siteHandle']
    options = 
      host: "#{body.site}.tell140.com"
      port: 80
      path: "/Story"
      headers:
        'content-type': "application/json"
      method: "POST"
      
    request = http.request options, (res)->
      response=''
      res.on "data", (d)->
        response += d
        return
      res.on "end", (x)->
        if x
          console.log x
        console.log response
        return
    request.write  JSON.stringify body
    request.end()
    return


  expandSnippets: ()=>
    @.snap "in expandSnippets #{@.get 'slug'}", 'content'
    snippets = @.get 'snippets'
    snippetHandled = true
    workingCopy = @.tmp.workingCopy
    for snippet of snippets
      continue unless snippet
      snippetHandled = false
      handledBy = handleArchive.find (model)->
        return snippet.toUpperCase() == (model.get 'handle').toUpperCase()
      if handledBy
        workingCopy = workingCopy.replace ///{{{#{snippet}:(.*)}}}///ig , (match)->
          match =match.replace '{{{',''
          match =match.replace '}}}',''
          match = match.split /:|,/
          T.render ->
            T.a ".goto", href: handledBy.href(@siteHandle), match[1]
        snippetHandled = true
        continue

      key = snippet.split /,|:/
      op = key.shift().toLowerCase()
      who = key.shift()
      switch op
        when "author"
          console.log "Author appears in #{@.get 'slug'}"
          workingCopy = workingCopy.replace /{{{author[,:\s]+([^}]*)}}}/ig, (match,more) ->
            return T.render ->
                T.blockquote ".right.key-author.right-align.h6.p2.bg-white.bg-darken-1.border.rounded", ->
                  T.raw more
          snippetHandled = true
        when "first name"
          #first name is a simple replacement with client-side heads-up
          workingCopy = workingCopy.replace /{{{first.name}}}/ig , T.render ->
            T.span ".FBname", 'Friend'
          snippetHandled = true
        when "sms"
          workingCopy = workingCopy.replace ///{{{#{op}[,:]#{who}[,:\s+]([^}]*)}}}///ig, (match,more)->
            return T.render ->
              T.blockquote ".right.key-#{op}.#{who}.right-align.h6.p2.bg-white.border.rounded", ->
                T.raw "#{who} says: #{more}"
          snippetHandled = true
          continue

        when "comment"
          workingCopy = workingCopy.replace ///{{{#{op}[,:]#{who}[,:\s]+([^}]*)}}}///ig, (match,more)->
            return T.render ->
              T.blockquote ".right.key-#{op}.#{who}.right-align.h6.p2.bg-white.border.rounded", ->
                T.raw "#{who} says: #{more}"
          snippetHandled = true
          continue

    @.tmp.workingCopy = workingCopy
    return false if snippetHandled
    return true

  analyze: ()=>
    @.tmp.workingCopy = @.get 'content'
    if (@.get 'debug').toString().match 'snippet'
      debugger
    if @get 'snippets'
      if @expandSnippets @
        #unresolved Handle type snippet.  need second pass.
        console.log "expandSnippets #{@.get 'slug'} Unresolved!"

    handle = @.get 'handle'
    if handle
      console.log "Handle #{handle} defined in story #{@.get 'slug'}"
      handleArchive.push @
    return

  setMarkedRenderer: (tag,newMarkedRenderer) =>
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
          try
            temp = r a,b,c,d,args
            return temp
          catch nasty
            console.log "Unable to render #{tag} via marked or internal",nasty
            @death "Unable to render #{tag} via marked or internal",nasty
      console.log "Unable to render #{tag} via internal",badPuppy
      @death "Unable to render #{tag} via internal",badPuppy

  #path to the url relative story asset directory
  pathToMe: (against = false)=>
    ref = "#{@get 'category'}/#{@get 'slug'}"
    return ref unless against
    return  "#{against}/#{ref}" if against.match '/'
    siteUrl = Sites[against].lurl
    sitePort = Sites[against].port
    return "http://#{siteUrl}:#{sitePort}/#{ref}"

  #path to the url relative story
  href: (against = false)=>
    ref = "#{@get 'category'}/#{@get 'slug'}.html"
    return ref unless against
    return  "#{against}/#{ref}" if against.match '/'
    siteUrl = Sites[against].lurl
    sitePort = Sites[against].port
    return "http://#{siteUrl}:#{sitePort}/#{ref}"

  copyAsset: (name,newPath = "#{publicPath}-")=>
    assetDest ="#{newPath}#{@.get 'siteHandle'}/#{@pathToMe ''}"
    sourceDir = (@.get 'sourcePath').replace /\.[\w]*$/,''
    try
      asset =fs.readFileSync "#{sitePath}/#{sourceDir}/#{name}"
      mkdirp.sync assetDest
      fs.writeFileSync "#{assetDest}/#{name}",asset
    catch badDog
      console.log "copyAsset #{@.get 'slug'}Bad Doggy = #{badDog}"
      process.exit()
    return

  snap: (text,force=false)->
    if force ==true || (
        if typeof force == 'string'
          (@.get 'debug').toString().match force
        else
          false
      )
      console.log "#{text} -- Story slug #{@.get 'slug'}"
      console.log "Attributes", @.attributes
      console.log "Tmp", @.tmp
      console.log "#{text} -----"

  death: (why,structure=null)->
    console.log 'failure info----------'
    console.log 'reason ---------- ', why
    if structure
      console.log structure
    console.log 'object attributes ----------'
    console.log @attributes
    console.log 'object temporaries ----------'
    console.log @tmp
    console.log 'Death----------'
    if @attributes.sourcePath
      child_process = require "child_process"
      child_process.execSync "open #{sitePath}/#{@attributes.sourcePath} -a atom.app"
    process.exit()

  parser: (obj)-> # override me
    return obj

  parse: (obj)=>
    # Sanitize all stories
    delete obj.numericId
    delete obj.nextID
    delete obj.previousID
    delete obj._options
    delete obj.sitePath
    delete obj.href
    delete obj.path
    #our yml engine moves 'content' to '__content' -- go figure
    if obj.debug == 'content'
      console.log "CONTENT debug"
      console.log obj
    if obj.__content && !obj.content
      obj.content = obj.__content
    delete obj.__content
    @parser obj
    if !obj.category || !obj.slug
      console.log obj
      console.log "no category? slug?"
      child_process = require "child_process"
      child_process.execSync "open #{sitePath}/#{obj.sourcePath} -a atom.app"
      process.exit()
    return obj

  unescapeAll= (html)->
    return html
      .replace /&lt;/g, '<'
      .replace /&gt;/g, '>'
      .replace /&quot;/g, '"'
      .replace /&amp;/g, '&'
      .replace /&([#\w]+);/g, (_, n)->
        n = n.toLowerCase()
        return ':' if n == 'colon'
        return '' unless (n.charAt(0) == '#')
        return String.fromCharCode(+n.substring(1)) unless n.charAt(1) == 'x'
        return String.fromCharCode(parseInt(n.substring(2), 16))


  expand: ()=>
    dieLater = @.tmp.workingCopy.match /{%/
    storyObject = @
    @setMarkedRenderer 'codespan', (codeBody) ->
      console.log arguments
      console.log codeBody
      console.log unescapeAll codeBody

      coffeeCode = "T=require 'teacup'\n#{ unescapeAll codeBody}"
      coffeeCode = "(binder)->{T=require 'teacup'\n #{ unescapeAll codeBody}}"
      try
        result = CoffeeScript.compile coffeeCode, bare: true
        debugger
        fnx= eval result
        rval = fnx @
        return rval
      catch badDog
        console.log "Coffescript Article Conversion Error - #{badDog}"
        console.log coffeeCode
        dieLater = true

    @setMarkedRenderer 'code', (codeBody) ->
      console.log arguments
      console.log codeBody
      console.log unescapeAll codeBody

      coffeeCode = "(binder)->\n  T=require 'teacup'\n#{ unescapeAll codeBody}"
      try
        result = CoffeeScript.compile coffeeCode, bare:true
        debugger
        fnx= eval result
        rval = fnx @
        return rval
      catch badDog
        console.log "Coffescript Article Conversion Error - #{badDog}"
        console.log coffeeCode
        dieLater = true
# image tag -- render as html with option for fancybox attributes
    @setMarkedRenderer 'image', (href,title,text)->
      throw 'useOld' unless href.match '@'
      val = _(href.split '@').map (snip)=>
        return '' unless snip
        ourUrl = snip.replace /^([\w]*)(\W.*)$/,(match,ourword,theirword)=>
          result = "nogo!"
          try
            result =@[ourword]()+theirword
          catch badPuppy
            console.log "Bad Dog! in template expand #{@.get 'slug'} #{badPuppy}"
            console.log "#{ourword}, and #{theirword}"
            console.log href,title,text,@.get 'slug'
            dieLater = true
          return result
      fullName =val.join ''
      smallName = fullName.match /[^\/]*$/
      images = @.get 'images'
      if !images
        images = []
      thumbName = smallName.toString().replace /\./,'-t.'
      images.push smallName.toString()
      images.push thumbName
      @.set 'images',images
      @.copyAsset smallName
      @.copyAsset thumbName

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
        return T.render ->
          T.div ".clearfix.mb2.border-bottom.fit #{classText}", ->
            T.comment "href=#{href} title=#{title} text=#{text}"
            T.a ".block.mx-auto", href: (val.join ""), title: title, ->
              T.img ".fig-img", src: thumbnailImage, alt: altText
            T.p ".caption", title

      return T.render ->
        T.img classText,
          title: title
          alt: altText
          src: val.join ""
        T.comment "href=#{href} title=#{title} text=#{text}"


    # actions on second pass of analysis
    if (@.get 'debug').toString().match 'snippet'
      debugger
    if @.get 'snippets'
      if @expandSnippets @
        #unresolved Handle type snippet.  need second pass.
        console.log "expandSnippets #{@.get 'slug'} Unresolved!"
        story.death badDog
    try
      @.tmp.cooked = marked.parser marked.lexer @.tmp.workingCopy
    catch badPuppy
      @.death "Augmented Markdown Failure", badPuppy
    if dieLater
      console.log "Cooked:", @.tmp.cooked
      @.death "fixme!!"
    tmp = @.clone()
    jSONarchive.push tmp
    return false

SubSiteStories = class extends Backbone.Collection
  comparator: 'slug'

  initialize: ()=>

  setSites:(@Sites)->
    allKeys = []
    for keys of @Sites
      allKeys.push keys
    @matcher = ///(#{allKeys.join '|'}).*\.(t?md)$///

  getPublishedFileDir: (story)->
    categories = story.get 'category'
    if !categories
      story.snap "Bad category",true
    return "#{publicPath}-#{@siteHandle}/#{categories}"

  getPublishedFileName: (story)->
    return "#{getPublishedFileDir story}/#{story.get 'slug'}.html"

  testFile: (f)=>
    return false if f.match /-\//  #disallow 'template-.files'
    result = f.match @matcher
    return result

  getFile: (fileName)=>
    console.log fileName
    filename = path.resolve '/',fileName
    kinds = fileName.match @matcher
    SiteStory = @Sites[kinds[1]].Story
    try
      fileContents = fs.readFileSync fileName, encoding: "utf-8"
    catch badPuppy
      console.log "Trouble reading #{fileName}"
      console.log badPuppy
      return null
    #assure proper headMatter
    unless fileContents.match /^(---|###)/
      fileContents = fileContents.replace /([^]*?)(---|###)/, (match,head,dash)->
        return "#{dash}\n#{head}\n#{dash}"
    stuff = ymljsFrontMatter.parse fileContents

    stuff.sourcePath = path.relative sitePath, fileName
    theStory = new SiteStory stuff, parse: true
    theStory.tmp.sourceFileName = fileName
    @.push theStory
    allStories.push theStory

  writeNew: (newSite)->
    @.each (story)->
      if story.get 'debug'
        debugger
      content = story.get 'content'

      head = story.clone().attributes
      delete head.content
      headMatter = ymljsFrontMatter.encode head, content
      fileName = "#{newSite}/#{head.siteHandle}/#{head.category}/#{head.slug}.md"
      try
        mkdirp.sync "#{newSite}/#{head.siteHandle}/#{head.category}"
      catch
      try
        fs.writeFileSync(fileName,headMatter )
      catch badDog
        console.log badDog
        process.exit()
      images = story.get 'images'
      _.each images, (image)->
        console.log "copy #{image} to #{newSite}"
        story.copyAsset image,"#{newSite}/"
      return

  doingOG = false
  doingTwitter = false
  doingFaceBook = false
  doingXML = false

  headMatter: renderable (story) ->
    options = story.attributes
    siteHandle = options.siteHandle
    thisSite = Sites[siteHandle]
    meta "http-equiv":"Content-Type", content:"text/html", charset:"UTF-8"
    meta name:"viewport", content:"width=device-width, initial-scale=1"
    meta name:"generator", content: options.slug
    title options.title
    meta name:"author", content: thisSite.author #JAH use site based params
    meta name: "description", content: thisSite.description
    meta name:"keywords", content:thisSite.keywords
    if doingXML
      link rel:"alternate", type:"application/atom+xml", title:"RSS", href:"/atom.xml"
    if doingOG
      meta property:"og:type", content:"news"
      meta property:"og:title", content:"Bamboo Snow"
      meta property:"og:url", content:"http://bamboosnow.com/index.html"
      meta property:"og:site_name", content:"Bamboo Snow"
      meta property:"og:description", content:"Information regarding the economic impact of bamboo snow"
    if doingTwitter
      meta name:"twitter:card", content:"summary"
      meta name:"twitter:title", content:"Bamboo Snow"
      meta name:"twitter:description", content:"Information regarding the economic impact of bamboo snow"
      meta name:"twitter:creator", content:"@BabaBambooJim"
    if doingFaceBook
      meta property:"fb:app_id", content:"271501872999476"
    base href: "/"
    link rel: "stylesheet", href: "assets/css/app.css"
    link rel: "stylesheet", href: "assets/css/vendor.css"
    script src: 'assets/js/vendor.js'
    script src: 'assets/js/app.js'
    script "siteHandle = '#{options.siteHandle}'; require('initialize');"

  formAll: renderable (story,content)->
    doctype html
    html =>
      head =>
        raw @headMatter story
      raw content

  publish: ()->
    bind = (fn, me)->
      return ()->
        return fn.apply(me, arguments)
    formAll = bind @.formAll,@
    @.each (story)->
      return unless moment() > moment(story.get 'embargo')
      try
        template = bind story.template.formatStory,story.template
        content = template story
      catch badDog
        story.death "Error in template ", badDog
      if !content
        story.death "no content from formatStory"
      if ! story.get 'siteHandle'
        story.death "No siteHandle"
      if ! story.get 'headlines'
        story.death "No Headlines!!"

      dir = "#{publicPath}-#{story.get 'siteHandle'}/#{story.get 'category'}"
      fileName = "#{publicPath}-#{story.get 'siteHandle'}/#{story.href()}"
      content = formAll story,content
      try
        mkdirp.sync dir
        fs.writeFileSync(fileName,content )
        console.log "published: #{fileName}"
      catch nasty
        story.death "Nasty Write to public #{fileName}:",nasty
    return
  expand: ()->
    @.each (story)->
      try
        expansion = story.template.expand story
      catch badPuppy
        story.death "template #{story.siteHandle} failed to expand on #{story.get 'title'}", badPuppy
    return

  analyze:()->
    retry = false
    @.each (story)->
      try
        retry |= story.analyze story
      catch badPuppy
        story.death "template #{story.siteHandle} failed to analyze on #{story.get 'title'}", badPuppy
    return retry

  summarize: ()=>
    theSummary = @.filter (story)=>
        return moment() > moment(story.get 'embargo')
    theSummary = theSummary.map (story)=>
        t=story.clone()
        t.unset 'content'
        t.unset 'sourcePath'
        return t.toJSON()
    return theSummary

jSONarchive = new SubSiteStories
handleArchive = new SubSiteStories

allStories = new SubSiteStories

module.exports =  SubSiteStory: SubSiteStory, SubSiteStories: SubSiteStories, allStories: allStories
