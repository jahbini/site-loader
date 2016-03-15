View = require 'views/base/view'
{Teacup} = require 'teacup'
T=new Teacup

module.exports = class SidebarStoryView extends View
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
    console.log('sidebar-story-view#render')
    T.renderable =>
        T.ul =>
          @collection.each (story) ->
            T.li ".b1", ->
              T.a ".goto.h5",
                href: story.get 'href'
                story.get 'title'
        T.text "wow from Teacup"
