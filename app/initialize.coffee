#
#routes = require 'routes'
window.$= jQuery
window._ = require 'lodash'
Backbone = require 'backbone'

PylonTemplate = Backbone.Model.extend
#  state: (require './models/state.coffee').state
    #React: require 'react'
    React: require 'react/dist/react.min.js'
    ReactDOM: require 'react-dom'
    #ReactDOM: require 'react-dom/dist/react-dom.min.js'
    Rebass: require 'rebass'
    Teact: require 'teact'
    Palx: require 'palx'
    
window.Pylon = Pylon = new PylonTemplate
Pylon.on 'all', (event,rest...)->
  mim = event.match /((.*):.*):/
  return null if !mim || mim[2] != 'systemEvent'
  applogger "event #{event}"
  Pylon.trigger mim[1],event,rest
  Pylon.trigger mim[2],event,rest
  return null


FontFaceObserver = require 'font-face-observer'
React = Pylon.React
T = Pylon.Teact
ReactDOM = Pylon.ReactDOM
Sidebar = T.bless require './components/sidebar-view'
Storybar = T.bless require './components/storybar-view'
routes = require './routes'
Rebass = Pylon.Rebass
Palx = Pylon.Palx

Provider = T.bless Rebass.Provider

newColors = Palx document.styling.palx
newColors.black= document.styling.black
newColors.white= document.styling.white

# gather the global JSONs into Backbone collections 
{myStories,allStories} = require 'models/stories'

styled= require   'styled-components'
{ injectGlobal, keyframes } = styled
styled = styled.default

injectGlobal""" 
  body {
    * {box-sizing: border-box; }
    body { margin: 0; }
    font-family: sans-serif;
  }
"""


# Initialize the application on DOM ready event.
$ ->
  
  mine =
    collection: myStories
    filter: (story)->true
    
  theirs =
    collection: allStories
    filter: (story)->true
    
  try
    realNode = document.getElementById('sidebar')
    sidebarContents = T.Provider  theme: colors: newColors, Sidebar mine
    ReactDOM.render sidebarContents, realNode
  catch badDog
    console.log badDog
  
  divs= $('.siteInvitation')
  divs.each (key,div)->
    ReactDOM.render (Provider theme: colors: newColors, Storybar theirs) , div
  