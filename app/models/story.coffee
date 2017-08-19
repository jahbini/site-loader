
  Model = require 'models/base/model'

  'use strict'

  module.exports = class Story extends Model
    href: (against = false)=>
      ref = "#{@get 'category'}/#{@get 'slug'}.html"
      if !against || against == window.siteHandle
        return ref
      return  "#{against}/#{ref}" if against.match '/'
      
    initialize: () ->
      super()
      console.debug 'Story#initialize'
