 #
#routes = require 'routes'
window.$= jQuery
window._ = require 'lodash'
FontFaceObserver = require 'font-face-observer'
React = require 'react'
T = require 'teact'
ReactDOM = require 'react-dom'
Sidebar = T.bless require './components/sidebar-view'
Storybar = T.bless require './components/storybar-view'
routes = require './routes'
Rebass = require 'rebass'
Palx = require 'palx'

Provider = T.bless Rebass.Provider

newColors = Palx '#03c'
newColors.black= '#000'
newColors.white= '#fff'

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
  