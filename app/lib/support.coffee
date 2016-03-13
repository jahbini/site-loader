
  utils = require 'lib/utils'
  ' use strict'

  # Application-specific feature detection
  # --------------------------------------

  # Delegate to Chaplin’s support module
  support = utils.beget Chaplin.support

  # Add additional application-specific properties and methods

  # _(support).extend
    # someProperty: 'foo'
    # someMethod: ->

  module.exports = support
