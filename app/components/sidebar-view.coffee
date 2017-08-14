R = require 'rebass'
R=R.default
T = require 'teact'
B = require 'backbone'
RD= require 'react-dom'
React = require 'react'
{ Card, Box, BackgroundImage, Subhead, Small, Panel, PanelHeader,
  Subhead,PanelFooter,Link } = require 'rebass'
Subhead = T.bless Subhead
Panel = T.bless R.Panel
Link = T.bless Link
PanelHeader = T.bless PanelHeader


Template = require "payload-/#{siteHandle}.coffee"
template = new Template T

module.exports =   class Sidebar extends React.Component
  displayName: 'Sidebar'
  
  render: ()=>
    collection = this.props.collection
    filter = this.props.filter || ()->true
    intermediate = collection.filter filter,@
    data = _(intermediate).sortBy( (s)->
      s.get 'category').groupBy (s) -> s.get 'category'
  
    teacupContent = template.widgetWrap  title: "Contents", ->
      result= data.each (allCrap,category,stuff)->
        return if category =='-'
        stories = stuff[category]
        catPostfix = category.match /\/?[^\/]+$/
        catPrefix = category.replace /[^\/]/g,''
        catPrefix = catPrefix.replace /\//g, ' -'
        catPostfix = catPostfix.toString().replace /\//g, '- '
        headliner = _(stories).find (story)->
        #find index for this category
          Panel ->
            if headliner
              PanelHeader ->
                T.text "#{category}: "
                T.em ".h4", _.sample headliner.get 'headlines'
            else
              PanelHeader ".category","#{catPrefix} #{catPostfix}"
            T.ul ".pr1", =>
              _(stuff[category]).each (story) ->
                return if 'category' == story.get 'className'
                T.li ".b1.mb1", ->
                  Link ".Link",
                    'color': 'white'
                    #bg: 'gray.8'
                    href: if siteHandle == story.get 'siteHandle'
                      story.href()
                    else
                      story.href story.get 'siteHandle'
                    "#{story.get 'title'}"
  
          T.hr()
      return T.text "No Stories" unless result
    return teacupContent
