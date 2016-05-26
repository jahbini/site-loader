T = require 'teacup'

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
    return @data

  getTemplateFunction:  ()->
    return (data)=>
      return (a,b,c) =>
        story = null
        until story
          story = data.pop()
          return null unless story
          badClass = 'category' == story.get 'className'
          badHeadline = !(story.get 'headlines')
          story = null if badClass || badHeadline

        V=T.render ()->
            T.a ".goto",{
              href: if siteHandle == story.get 'siteHandle'
                story.href()
              else
                story.href story.get 'siteHandle'
              }, =>
                T.div ".b1.bg-silver.bg-darken-3.mb1.ml2.border.rounded.p1", =>
                  T.h4 ".adv-head","From around the Web:"
                  T.h6 ".adv-text","#{story.get 'title'}: #{_.sample story.get 'headlines'}"
