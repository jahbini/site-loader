{Teacup} = require 'teacup'
T=new Teacup

module.exports = class SidebarStoryView extends Chaplin.View
  #template: './templates/sidebarStory'
  #initialize: @render()
  autoRender: true
  autoAttach: true
  constructor: (@collection) ->
    super

  el: "#sidebar"

  getTemplateData: ()=>
    @collection
  getTemplateFunction: (info)->
    T.renderable =>
        T.ul =>
          @collection.each (story) ->
            T.li ".b1", ->
              T.a ".goto.h5",
                href: if siteHandle == story.get 'siteHandle'
                    story.href()
                  else
                    story.href story.get 'siteHandle'
                story.get 'title'
        T.text "wow from Teacup"
