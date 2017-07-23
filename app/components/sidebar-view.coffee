R = require 'rebass'
R=R.default
T = require 'teact'
B = require 'backbone'
RD= require 'react-dom'


Template = require "payload-/#{siteHandle}.coffee"
template = new Template T

module.exports = SideBarView = (props) ->
  collection = props.collection
  filter = props.filter || ()->true
  intermediate = collection.filter filter,@
  data = _(intermediate).sortBy( (s)->
    s.get 'category').groupBy (s) -> s.get 'category'
  
  teacupContent = template.widgetWrap  title: "Contents", ->
    result= data.each (allCrap,category,stuff)->
      return if category =='/'
      stories = stuff[category]
      catPostfix = category.match /\/?[^\/]+$/
      catPrefix = category.replace /[^\/]/g,''
      catPrefix = catPrefix.replace /\//g, ' -'
      catPostfix = catPostfix.toString().replace /\//g, '- '
      headliner = _(stories).find (story)->
          #find index for this category
        return 'category' == story.get 'className'
      panel = T.bless R.Panel
      panel backgroundColor: "#22222222", ->
        if headliner
          T.h3 ".category",->
            T.text "#{category}: "
            T.em ".h4", _.sample headliner.get 'headlines'
        else
          T.h3 ".category","#{catPrefix} #{catPostfix}"
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
