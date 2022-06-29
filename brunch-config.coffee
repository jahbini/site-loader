# Brunch-config.coffee meta file
#
Sites = require './sitedef.json'
S={}
for aSite in Sites.results
  aSite.fields.siteId = aSite.id
  S[aSite.name] = aSite.fields
Sites = S

# ???    path = require 'path'
siteName = process.env.SITE
if !siteName
  console.log "Must specify env on cmd line: SITE='' brunch ..."
  process.exit()
else
  console.log "Processing #{siteName} with brunch"
theSite =  Sites[siteName]
if !theSite
  console.log "invalid site #{siteName} -- Not in sites.coffee"
  process.exit()
theResult =
  # See http://brunch.io/#documentation for docs.
  paths:
    public: "domains/#{siteName}/public"
    watched:[
      "domains/#{siteName}/payload-"
      "domains/#{siteName}/templates"
      'vendor'
      'app'
      ]
  conventions:
    ignored: (path) -> /\.c9|\.git/.test path
    assets: (path)->
      console.log  "JAH PATH", path
      if path.match 'templates'
        console.log  "JAH", path
        return true
      return true if path.match 'css/'
      return true if path.match 'fonts/'
      return true if path.match 'assets/'
      return false

  modules:
    autoRequire:
      js: [ "halvalla/lib/halvalla-mithril.js" ]
      css: [
        siteName
        "#{siteName}/payload-/run-time.css"
      ],
      "css/vendor.css": [
        "normalize"
        "blaze"
        "ace-css"
        "basscss-grid"
        "bootstrap"
      ]

    nameCleaner: (path) =>
      c=path.replace /^app\//, ''
      c=c.replace ///^assets/#{siteName}///, ''
      c=c.replace ///^domains\////, ''
      c=c.replace ///#{siteName}[\/]payload-///,'payload-'
      c=c.replace ///#{siteName}[\/]templates///,''
      console.log "path Cleaner: #{path} - #{c}" if path.match "nothing to see here"
      return c
  files:
    javascripts:
      joinTo:
        'assets/js/app.js': [/^app/,///domains/#{siteName}\/payload-/// ]
        'assets/js/vendor.js': (f)->
          pattern= ///vendor|bower_components|node_modules///
          #console.log pattern
          result = f.match pattern
          #console.log "matching #{f}: #{result}"
          return result


      order:
        after:  /helpers\//

    stylesheets:
      order:   # must use full names not anyMatch syntax
        before: "node_modules/blaze/scss/dist/blaze.min.css"
        after: [ "node_modules/ace-css/css/ace.css", "node_modules/basscss-grid/css/grid.css", "node_modules/bootstrap/dist/css/bootstrap.min.css"]
      joinTo:
        'assets/css/app.css': [/^app/,///domains\/#{siteName}\/payload-///]
        'assets/css/vendor.css': ///^vendor|^bower_components|^node_modules///

    templates:
      joinTo:
        'assets/js/app.js': /^app/
  conventions:
    vendor:
      ///(^bower_components|node_modules|vendor)[\/]///
  npm:
    enabled: true
    globals:
      loglevel: "loglevel"
      #mui: "mui"
      #_: "underscore"
      jQuery: "jquery"
      fontFaceObserver: 'font-face-observer'

    styles: {
      "blaze": ["scss/dist/blaze.min.css"]
      "bootstrap": ["dist/css/bootstrap.min.css"]
      "ace-css": [ "css/ace.css" ]
      "basscss-grid": [ "css/grid.css" ]
    }

  plugins:
    'halvalla':
      destination: "domains/#{siteName}/public/"
      allStories: "./app/assets/assets/allstories.json"
                    
    order: [ 'coffeescript','halvalla', 'babel' ]
    uglify:
      ignored: /app.js/
    gzip:
      optimize: "optimize"
      paths:
        javascript: 'assets/js'
        stylesheet: 'assets/css'
      removeOriginalFiles: false
      renameGzipFilesToOriginalFiles: false
      
    babel:
      presets: [ 'latest', 'react']
      plugins:  [
#        ["babel-plugin-root-import",  rootPathPrefix: "" ]
#        ["minify-dead-code-elimination"]
      ] 
    scss:
      mode: 'ruby' # set to 'native' to force libsass
  server:
    noPushState: true
    stripSlashes: true

#console.log theResult
exports.config = theResult
