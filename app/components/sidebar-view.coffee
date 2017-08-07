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

Template = require "payload-/#{siteHandle}.coffee"
template = new Template T

module.exports =   class Sidebar extends React.Component
  displayName: 'SideBar'
  
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
          Panel backgroundColor: "#22222222", ->
            if headliner
              Subhead ".category",->
                T.text "#{category}: "
                T.em ".h4", _.sample headliner.get 'headlines'
            else
              Subhead ".category","#{catPrefix} #{catPostfix}"
            T.ul ".category.pr1", =>
              _(stuff[category]).each (story) ->
                return if 'category' == story.get 'className'
                T.li ".category.b1.mb1", ->
                  T.a ".goto.h3.category",
                    href: if siteHandle == story.get 'siteHandle'
                      story.href()
                    else
                      story.href story.get 'siteHandle'
                    "#{story.get 'title'}"
  
          T.hr()
      return T.text "No Stories" unless result
    return teacupContent
