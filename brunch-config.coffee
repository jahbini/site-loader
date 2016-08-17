# Brunch-config.coffee meta file
#
Sites = require './sites'

path = require 'path'
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
    public: "public-#{siteName}"
    watched:[
      "domains/#{siteName}/brunch-payload-"
      'vendor'
      'app'
      ]
  conventions:
    assets: /(css.fonts|assets)[\\/]/
  modules:
    autoRequire: [
      "baranquillo"
      siteName
      "#{siteName}/brunch-payload-/#{siteName}"
      "payload-/#{siteName}"
      "basscss"
      "basscss-darken"
      "normalize"
    ]
    nameCleaner: (path) =>
      c=path.replace /^app\//, ''
      c=c.replace ///^assets/#{siteName}///, ''
      c=c.replace ///^domains\////, ''
      c=c.replace ///#{siteName}[\/]brunch-payload-///,'payload-'
      #console.log "path Cleaner: #{path} - #{c}" if path.match "payload"
      return c
  files:
    javascripts:
      joinTo:
        '/js/app.js': [/^app/,///domains/#{siteName}\/brunch-payload-/// ]
        '/js/vendor.js': (f)->
          pattern= ///vendor|bower_components|node_modules///
          #console.log pattern
          result = f.match pattern
          #console.log "matching #{f}: #{result}"
          return result


      order:
        after:  /helpers\//

    stylesheets:
      order:
        before: 'normalize'
      joinTo:
        '/css/app.css': [/^app/,///domains\/#{siteName}\/brunch-payload-///]
        '/css/vendor.css': ///^vendor|^bower_components|^node_modules///

    templates:
      joinTo:
        '/js/app.js': /^app/
  conventions:
    vendor:
      ///(^bower_components|node_modules|vendor)[\/]///
  npm:
    enabled: true
    globals:
      loglevel: "loglevel"
      teacup: "teacup"
      fontFaceObserver: 'font-face-observer'

    static: ["basscss-darken"]
    styles: {
      "basscss-darken": [ "css/darken.css"]
      "basscss-background-colors":[ "css/background-colors.css"]
      "basscss":["css/basscss.min.css"]
      "basscss-background-images": [ "css/background-images.css" ]
      "basscss-btn": [ "css/btn.css" ]
      "basscss-btn-outline": [ "css/btn-outline.css" ]
      "basscss-btn-primary": [ "css/btn-primary.css" ]
      "basscss-btn-sizes": [ "css/btn-sizes.css" ]
      "basscss-colors": [ "css/colors.css" ]
      "basscss-forms": [ "css/forms.css" ]
      "basscss-lighten": [ "css/lighten.css" ]
      "basscss-media-object": [ "css/media-object.css" ]
      "basscss-responsive-margin": [ "css/responsive-margin.css" ]
      "basscss-responsive-padding": [ "css/responsive-padding.css" ]
    }

  plugins:
    scss:
      mode: 'ruby' # set to 'native' to force libsass
###
  server:
    port: theSite.port
    hostname: theSite.lurl
    noPushState: true
    stripSlashes: true
###

#console.log theResult
exports.config = theResult
