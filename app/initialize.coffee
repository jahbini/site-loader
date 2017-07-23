#Application = require 'app'
#routes = require 'routes'
window.require.alias  'payload-/bamboosnow.coffee', 'bamboosnow'
FontFaceObserver = require 'font-face-observer'
React = require 'react'
ReactDOM = require 'react-dom'
sidebarView = require './components/sidebar-view'
routes = require './routes'
Rebass = require 'rebass'
StoryCollection = require 'models/stories'
# data = require '../package.json'
data = {
  default: "hello"
}

# Initialize the application on DOM ready event.
$ ->
  data.components = Object.keys(Rebass).length
  
  data = {
    collection: new StoryCollection
    filter: (story)->
      return siteHandle == story.get 'siteHandle'
  }
    
  div = document.getElementById('sidebar')
  ReactDOM.render React.createElement(sidebarView, data) , div
