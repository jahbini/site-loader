# put outbound links into story

T = Pylon.Teact
B = require 'backbone'

#Badge = T.bless R.Badge
#Subhead = T.bless R.Subhead
#Text = T.bless R.Text
#Link = T.bless R.Link

siteBase = topDomain.split '.'
z=siteBase.shift()

module.exports = class Storybar 
  displayName: 'Storybar'
  constructor: (@vnode)->
    console.log @vnode
    @
  
  view: ()=>
    collection = @vnode.attrs.collection
    filter = @vnode.attrs.filter || ()->true
    intermediate = collection.filter filter,@
    story = null
    until story
      story = collection.pop()
      return null unless story
      badClass = 'category' == story.get 'className'
      badHeadline = !(story.get 'headlines')
      story = null if badClass || badHeadline
    try
      storyFrom = story.get('site').name
    catch error
      console.log "Ailing Story",story
      return null
    siteBase = topDomain.split '.'
    siteBase.shift()
    siteBase.unshift storyFrom
  
    V=T.crel 'Link', ".goto.border.p2.inline-block",{
      href: story.href 'http://'+siteBase.join '.'
      }, =>
        T.crel 'Badge', bg: 'gray.7', =>
          T.crel 'Subhead','.h5', "From around the Web:"
          T.crel 'Text', ".Text.h4","#{story.get 'title'}: #{_.sample story.get 'headlines'}"
