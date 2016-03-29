{Teacup} = require 'teacup'
T=new Teacup

module.exports = class SidebarStoryView extends Chaplin.View
  #template: './templates/sidebarStory'
  #initialize: @render()
  autoRender: true
  autoAttach: true
  constructor: (@collection,@filter) ->
    super

  el: "#sidebar2"

  getTemplateData: ()=>
    @collection.filter @filter,@
  getTemplateFunction: ->
    T.renderable (stuff)=>
        T.h4 "In Depth information:#{siteHandle}"
        T.ul =>
          _(stuff).each (story) ->
            T.li ".b1", ->
              T.a ".goto.h3",
                href: if siteHandle == story.get 'siteHandle'
                    story.href()
                  else
                    story.href story.get 'siteHandle'
                "#{story.get 'title'}"
