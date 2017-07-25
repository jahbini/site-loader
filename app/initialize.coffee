#Application = require 'app'
#routes = require 'routes'
window.require.alias  'payload-/bamboosnow.coffee', 'bamboosnow'
FontFaceObserver = require 'font-face-observer'
React = require 'react'
ReactDOM = require 'react-dom'
sidebarView = require './components/sidebar-view'
storybarView = require './components/storybar-view'
routes = require './routes'
Rebass = require 'rebass'
{myStories,allStories} = require 'models/stories'

config = require 'config'
configurations = 
  basic: require 'configurations/basic.js'
  biblio: require 'configurations/biblio.js'
  # data = require '../package.json'
data = {
  default: "basic"
}

# Initialize the application on DOM ready event.
$ ->
  #data.components = Object.keys(Rebass).length
  
  mine =
    collection: myStories
    filter: (story)->true
  theirs =
    collection: allStories
    filter: (story)->true
    
  div = document.getElementById('sidebar')
  ReactDOM.render React.createElement(sidebarView, mine) , div

  divs= $('.siteInvitation')
  divs.each (key,div)->
    ReactDOM.render React.createElement(storybarView, theirs) , div
