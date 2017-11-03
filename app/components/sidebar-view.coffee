T = Pylon.Halvalla
B = require 'backbone'
#{  Panel, PanelHeader, Link } = Pylon.Rebass
  
#Panel = T.bless Panel
#Link = T.bless Link
#PanelHeader = T.bless PanelHeader


Template = require "payload-/#{siteHandle}.coffee"
template = new Template T

module.exports =  T.bless class Sidebar extends B.Model
  displayName: 'Sidebar'
  
  view: (vnode)=>
    collection = vnode.attrs.collection
    filter = vnode.attrs.filter || ()->true
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
          T.div '.Panel', ->
            if headliner
              T.div '.PanelHeader', ->
                T.text "#{category}: "
                T.em ".h4", _.sample headliner.get 'headlines'
            else
              T.div '.PanelHeader.category',"#{catPrefix} #{catPostfix}"
            T.ul ".pr1", =>
              _(stuff[category]).each (story) ->
                return if 'category' == story.get 'className'
                T.li ".b1.mb1", ->
                  T.a ".Link",
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
