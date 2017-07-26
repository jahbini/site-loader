R = require 'rebass'
R=R.default
T = require 'teact'
B = require 'backbone'
RD= require 'react-dom'

siteBase = topDomain.split '.'
z=siteBase.shift()

module.exports = StorybarView = (props)->
  collection = props.collection
  filter = props.filter || ()->true
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
  
  V=T.a ".goto",{
    href: story.href 'http://'+siteBase.join '.'
    }, =>
      T.div ".b1.bg-silver.bg-darken-3.mb1.ml2.border.rounded.p1", =>
        T.h4 ".adv-head","From around the Web:"
        T.h6 ".adv-text","#{story.get 'title'}: #{_.sample story.get 'headlines'}"
