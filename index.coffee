#!/usr/bin/env coffee
#

###
 execute Publish with command-line options
 * Module dependencies.
###
Cli = require('commander');
Coffee = require('coffee-script')
register = require('coffee-script/register')

CommandLineOptions = Cli
  .allowUnknownOption(false)
  .version('0.0.1')
  .option('-y, --yml', 'Create Yml from Sites')
  .option('-P, --no-publish', 'do NOT populate public-"site"')
  .option '-l, --local-service <port,increment>',
    'Port for local service.'
    (val)->
      val.split ','
  .option('-n, --new-site', 'Create ./newSite with reorganized contents')
  .option('-G, --no-generate-json', 'do NOT create app/generated JSON')
  .option('-u, --upload', 'rsync to server')
  .parse(process.argv);

#console.log result
Sites = require('./lib/publish');

Rsync = require('rsync');

if CommandLineOptions.upload
  for subSite, O of Sites
    # Build the command
    rsync = new Rsync()
      .shell 'ssh'
      .flags 'vraz'
      .delete()
      .exclude '.git'
      .exclude '.DS_Store'
      .source "./public-#{subSite}/"
      .destination O.rsyncDestination

    #Execute the command
    rsync.execute (error, code, cmd)->
      #we're done
      console.log "rsync on #{subSite}:" ,error, code, cmd
