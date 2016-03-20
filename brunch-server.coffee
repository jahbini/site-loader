PushServe = require 'pushserve'
sites = require './sites'
console.log "Sites!!",sites

module.exports = (port,path,callback)->
    servers = []
    for site, params of sites
      console.log "new server on #{params.port} for #{path}/#{site}"
      try
        server= PushServe
          port: params.port
          path: "./#{path}/#{site}/"
          callback
        servers.push server
      catch badGuy
        console.log badGuy
    return close: ()->
      console.log "Closing!"
      for server in servers
        server.close();
      return
        # body...


      # body...
