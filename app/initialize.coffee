Application = require 'app'
routes = require 'routes'
FontFaceObserver = require 'font-face-observer'

# Initialize the application on DOM ready event.
$ ->
  app = new Application {
    title: 'Brunch example application',
    controllerSuffixNot: '-controller',
    routes
  }
