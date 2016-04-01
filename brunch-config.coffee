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
exports.config =
  # See http://brunch.io/#documentation for docs.
  paths:
    public: "public-#{siteName}"
    watched:[
      "site/#{siteName}"
      'vendor'
      'app'
      "assets/#{siteName}"
      ]
  modules:
    autoRequire: ["baranquillo","backgrounds","normalize"]
    nameCleaner: (path) =>
      c=path.replace /^app\//, ''
      c=c.replace ///^assets\/#{siteName}\////, ''
      return c
  files:
    javascripts:
      joinTo:
        '/js/app.js': /^app/
        '/js/vendor.js': /^vendor|^bower_components|^node_modules/
      order:
        after:  /helpers\//

    stylesheets:
      order:
        before: 'normalize'
      joinTo:
        '/css/app.css': /^app/
        #'app/css/baranquillo.css': '_css/**/*.scss'
        ##'app/css/baranquillo.css': '_css/**/*.scss'
        '/css/vendor.css': /^vendor|^bower_components|^node_modules/
        #'app/css/all.css': 'node_modules/**/*.css'

    templates:
      joinTo:
        '/js/app.js': /^app/

  npm:
    enabled: true
    globals:
      loglevel: "loglevel"
      teacup: "teacup"
    styles: "basscss-background-colors":[ "css/background-colors.css"]

  plugins:
    scss:
      mode: 'ruby' # set to 'native' to force libsass
  server:
    port: theSite.port
    hostname: theSite.lurl
    noPushState: true
    stripSlashes: true
