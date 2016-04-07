{Teacup} = require 'teacup'
T=new Teacup

module.exports = class SidebarStoryView extends Chaplin.View
  #template: './templates/sidebarStory'
  #initialize: @render()
  autoRender: true
  autoAttach: true
  constructor: (@collection,@filter) ->
    super

  el: "#story"

  getTemplateData: ()=>
    @collection.filter @filter,@

  getTemplateFunction: =>
    T.renderable (stuff)=>
        T.h4 "From Around the Web"
        T.ul =>
          _(stuff).each (story) ->
            debugger
            headlines = story.get 'headlines'
            return unless headlines
            return if 'category' == story.get 'className'
            T.li ".b1", ->
              T.text _.sample headlines
              T.br()
              T.a ".goto.h3",
                href: if siteHandle == story.get 'siteHandle'
                    story.href()
                  else
                    story.href story.get 'siteHandle'
                "#{story.get 'title'}"
