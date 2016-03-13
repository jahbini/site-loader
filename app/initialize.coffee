Application = require 'app'
routes = require 'routes'

# Initialize the application on DOM ready event.
$ ->
  app = new Application {
    title: 'Brunch example application',
    controllerSuffixNot: '-controller',
    routes
  }
