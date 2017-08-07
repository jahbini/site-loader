
  Model = require 'models/base/model'
  Sites = require '../generated/sites'

  'use strict'

  module.exports = class Story extends Model
    href: (against = false)=>
      ref = "#{@get 'category'}/#{@get 'slug'}.html"
      if !against || against == window.siteHandle
        return ref
      return  "#{against}/#{ref}" if against.match '/'
      siteUrl = Sites[against].lurl
      sitePort = Sites[against].port
      if !sitePort
        return "http://#{siteUrl}/#{ref}"
      return "http://#{siteUrl}:#{sitePort}/#{ref}"
    initialize: () ->
      super()
      console.debug 'Story#initialize'
