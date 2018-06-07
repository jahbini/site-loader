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
  clickHandler:(e)=> 
    targ = e.currentTarget
    targ.setAttribute 'aria-expanded', if 'false' == targ.getAttribute('aria-expanded') then 'true' else 'false'
  view: (vnode)=>
    collection = vnode.attrs.collection
    filter = vnode.attrs.filter || ()->true
    intermediate = collection.filter filter,@
    data = _(intermediate).sortBy( (s)->
      s.get 'category').groupBy (s) -> s.get 'category'
  
    teacupContent = template.widgetWrap  title: "Contents", =>
      result= data.each (allCrap,category,stuff)=>
        return if category =='-'
        stories = stuff[category]
        catPostfix = category.match /\/?[^\/]+$/
        catPrefix = category.replace /[^\/]/g,''
        catPrefix = catPrefix.replace /\//g, ' -'
        catPostfix = catPostfix.toString().replace /\//g, '- '
        headliner = _(stories).find (story)=>
        #find index for this category
          attrX =
            'aria-expanded':
              'false'
            onclick:
              @clickHandler
            role:
              'heading'
          T.div '.Panel.c-card.c-card--accordion', =>
            if headliner
              T.button '.c-card__control', attrX, =>
                T.text "#{category}: "
                T.em ".h4", _.sample headliner.get 'headlines'
            else
              T.button '.c-card__control', attrX, "#{catPrefix} #{catPostfix}"
            T.section ".pr1.c-card__item.c-card__item--pane", =>
              T.ul ".c-list c-list--unstyled",=>
                _(stuff[category]).each (story) =>
                  return if 'category' == story.get 'className'
                  T.li ".c-list__item.b1.mb1", =>
                    T.a ".Link",
                      'color': 'white'
                      #bg: 'gray.8'
                      href: if siteHandle == story.get 'siteHandle'
                        story.href()
                      else
                        story.href story.get 'siteHandle'
                      "#{story.get 'title'}"
  
      return T.text "No Stories" unless result
    return teacupContent
