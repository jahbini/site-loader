R = require 'rebass'
R=R.default
T = require 'teact'
B = require 'backbone'
RD= require 'react-dom'
React = require 'react/dist/react.min'
Box = T.bless R.Box
Badge = T.bless R.Badge
Subhead = T.bless R.Subhead
Text = T.bless R.Text
Link = T.bless R.Link

siteBase = topDomain.split '.'
z=siteBase.shift()

module.exports = class Storybar extends React.Component
  displayName: 'Storybar'
  
  render: ()=>
    collection = @props.collection
    filter = @props.filter || ()->true
    intermediate = collection.filter filter,@
    story = null
    until story
      story = collection.pop()
      return null unless story
      badClass = 'category' == story.get 'className'
      badHeadline = !(story.get 'headlines')
      story = null if badClass || badHeadline
    storyFrom = story.get('site').name
    siteBase = topDomain.split '.'
    siteBase.shift()
    siteBase.unshift storyFrom
  
    V=Link ".goto",{
      href: story.href 'http://'+siteBase.join '.'
      }, =>
        Badge bg: 'gray.7', =>
          Subhead "From around the Web:"
          Text ".Text","#{story.get 'title'}: #{_.sample story.get 'headlines'}"
