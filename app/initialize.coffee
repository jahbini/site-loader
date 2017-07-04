#Application = require 'app'
#routes = require 'routes'
window.require.alias  'payload-/bamboosnow.coffee', 'bamboosnow'
FontFaceObserver = require 'font-face-observer'
React = require 'react'
ReactDOM = require 'react-dom'
App = require './components/App'
Rebass = require 'rebass'
# data = require '../package.json'
data = {
  default: "hello"
}

# Initialize the application on DOM ready event.
$ ->
  data.components = Object.keys(Rebass).length
  div = document.getElementById('sidebar')
  ReactDOM.render React.createElement(App, data) , div
