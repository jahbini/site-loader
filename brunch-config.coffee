Sites = require './site/_lib/sites'
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
exports.config =
  # See http://brunch.io/#documentation for docs.
  paths:
    public: "public-#{siteName}"
    watched:[
      "site/#{siteName}"
      'vendor'
      'app'
      "site/layouts"
      ]
  conventions:
    assets: /(css.fonts|assets)[\\/]/
  modules:
    autoRequire: ["baranquillo","backgrounds","normalize"]
    nameCleaner: (path) =>
      c=path.replace /^app\//, ''
      c=c.replace ///^assets\/#{siteName}\////, ''
      return c
  files:
    javascripts:
      joinTo:
        '/js/app.js': [/^app/,///#{siteName}\/payload/// ]
        '/js/vendor.js': /^vendor|^bower_components|^node_modules/
      order:
        after:  /helpers\//

    stylesheets:
      order:
        before: 'normalize'
      joinTo:
        '/css/app.css': [/^app/,///#{siteName}\/payload///]
        '/css/vendor.css': /^vendor|^bower_components|^node_modules/

    templates:
      joinTo:
        '/js/app.js': /^app/

  npm:
    enabled: true
    globals:
      loglevel: "loglevel"
      teacup: "teacup"
    styles:
      "basscss-background-colors":[ "css/background-colors.css"]
      "basscss":["css/basscss.min.css"]

  plugins:
    scss:
      mode: 'ruby' # set to 'native' to force libsass
  server:
    port: theSite.port
    hostname: theSite.lurl
    noPushState: true
    stripSlashes: true
