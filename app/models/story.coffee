
  Model = require 'models/base/model'

  'use strict'

  module.exports = class Story extends Model

    initialize: () ->
      super
      console.debug 'Story#initialize'
