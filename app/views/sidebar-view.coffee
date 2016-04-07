{Teacup} = require 'teacup'
T=new Teacup

module.exports = class StoryBarView extends Chaplin.View
  #template: './templates/sidebarStory'
  #initialize: @render()
  autoRender: true
  autoAttach: true
  constructor: (@collection,@filter= ->true ) ->
    super

  el: "#sidebar2"

  getTemplateData: ()=>
    intermediate = @collection.filter @filter,@
    stuff = _(intermediate).sortBy( (s)-> s.get 'category').groupBy (s) -> s.get 'category'
    return stuff
  getTemplateFunction: =>
    T.renderable (data)=>
      T.h4 "In Depth information: #{siteHandle}"
      data.each (allCrap,category,stuff)->
        return if category =='/'
        stories = stuff[category]
        catPostfix = category.match /\/?[^\/]+$/
        catPrefix = category.replace /[^\/]/g,''
        catPrefix = catPrefix.replace /\//g, ' -'
        catPostfix = catPostfix.toString().replace /\//g, '- '
        headliner = _(stories).find (story)->
          return 'category' == story.get 'className'
        if headliner
          T.h4 ->
            T.text "#{category}: "
            T.em ".h4", _.sample headliner.get 'headlines'
        else
          T.h5 "#{catPrefix} #{catPostfix}"
        T.ul =>
          _(stuff[category]).each (story) ->
            return if 'category' == story.get 'className'
            T.li ".b1", ->
              T.a ".goto.h5",
                href: if siteHandle == story.get 'siteHandle'
                    story.href()
                  else
                    story.href story.get 'siteHandle'
                "#{story.get 'title'}"

        T.hr()
