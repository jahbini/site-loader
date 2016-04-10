{Teacup} = require 'teacup'
T=new Teacup

module.exports = class SidebarStoryView extends Chaplin.View
  #template: './templates/sidebarStory'
  #initialize: @render()
  autoRender: true
  autoAttach: true
  constructor: (@collection,@filter) ->
    @data = @collection.shuffle().filter @filter,@
    super

  el: ".siteInvitation"

  getTemplateData: ()=>
    debugger
    story = null
    until story
      story = @data.pop()
      return null unless story
      badClass = 'category' == story.get 'className'
      badHeadline = !(story.get 'headlines')
      story = null if badClass || badHeadline
    return story

  getTemplateFunction: =>
    T.renderable (story)=>
      T.div ".b1.bg-olive", =>
          T.h3 _.sample story.get 'headlines'
          T.a ".goto.h3",
            href: if siteHandle == story.get 'siteHandle'
              story.href()
            else
              story.href story.get 'siteHandle'
            "#{story.get 'title'}"
