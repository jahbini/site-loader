#Application = require './components/App'
#routes = require 'routes'
window.require.alias  'payload-/bamboosnow.coffee', 'bamboosnow'
window.$= jQuery
window._ = require 'lodash'
FontFaceObserver = require 'font-face-observer'
React = require 'react'
T = require 'teact'
ReactDOM = require 'react-dom'
Sidebar = React.createFactory require './components/sidebar-view'
storybarView = require './components/storybar-view'
routes = require './routes'
Rebass = require 'rebass'
{myStories,allStories} = require 'models/stories'

styled= require   'styled-components'
{ injectGlobal, keyframes } = styled
styled = styled.default

injectGlobal """ 
  body {
    font-family: serif;
  }
"""

# Create a <Title> react component that renders an <h1> which is
# centered, palevioletred and sized at 1.5em
Title = styled.h3 """
  font-size: 1.5em;
  text-align: center;
  color: palevioletred;
  animation: #{keyframes 'from { opacity: 0; }'} 1s both;
  """

# Create a <Wrapper> react component that renders a <section> with
# some padding and a papayawhip background
Wrapper = styled.section """
  padding: 4em;
  background: papayawhip;
  """
Wrapper = T.bless Wrapper
  
config = require 'config'
configurations = 
  basic: require 'configurations/basic.js'
#  biblio: require 'configurations/biblio.js'
  # data = require '../package.json'
data = {
  default: "basic"
}

# Initialize the application on DOM ready event.
$ ->
  #data.components = Object.keys(Rebass).length
  {div, h1} = React.DOM

  mine =
    collection: myStories
    filter: (story)->true
  theirs =
    collection: allStories
    filter: (story)->true
    
  GreetBox = React.createFactory React.createClass
    displayName: 'GreetBox'
  
    render: ->
      div null,
        h1 key: 'header', "Contents"
        @props.children
  debugger
  try
    realNode = document.getElementById('sidebar')
    ReactDOM.render(GreetBox(name: "World", Sidebar mine), realNode) # Error!
    #element = React.createElement(GreetBox, name: "World", "Lorem ipsum")
    #ReactDOM.render(element, realNode)
  catch badDog
    console.log badDog

  divs= $('.siteInvitation')
  divs.each (key,div)->
    ReactDOM.render React.createElement(storybarView, theirs) , div
  