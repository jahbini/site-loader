T = require 'teacup'
B = require 'backbone'

Template = require "payload-/#{siteHandle}"
template = new Template

module.exports = class StoryBarView extends Chaplin.View
  #template: './templates/sidebarStory'
  #initialize: @render()
  autoRender: true
  autoAttach: true
  constructor: (@collection,@filter= ->true ) ->
    super

  el: "#sidebar"

  getTemplateData: ()=>
    intermediate = @collection.filter @filter,@
    stuff = _(intermediate).sortBy( (s)-> s.get 'category').groupBy (s) -> s.get 'category'
    return stuff
  getTemplateFunction: ()=>
    T.renderable (data)->
      template.widgetWrap  title: "Contents", ->
        data.each (allCrap,category,stuff)->
          return if category =='/'
          stories = stuff[category]
          catPostfix = category.match /\/?[^\/]+$/
          catPrefix = category.replace /[^\/]/g,''
          catPrefix = catPrefix.replace /\//g, ' -'
          catPostfix = catPostfix.toString().replace /\//g, '- '
          headliner = _(stories).find (story)->
            #find index for this category
            return 'category' == story.get 'className'
          if headliner
            T.h3 ".category",->
              T.text "#{category}: "
              T.em ".h4", _.sample headliner.get 'headlines'
          else
            T.h3 ".category","#{catPrefix} #{catPostfix}"
          T.ul ".category.pr1", =>
            _(stuff[category]).each (story) ->
              return if 'category' == story.get 'className'
              T.li ".category.b1", ->
                T.a ".goto.h3.category",
                  href: if siteHandle == story.get 'siteHandle'
                      story.href()
                    else
                      story.href story.get 'siteHandle'
                  "#{story.get 'title'}"

          T.hr()
      return
