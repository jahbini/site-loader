T = Pylon.Halvalla
B = require 'backbone'
#Panel = T.bless Panel
#Link = T.bless Link
#PanelHeader = T.bless PanelHeader
template = require "payload-/run-time-template.coffee"

sideStuff = class Sidebar extends B.Model
  constructor:()->
    super()
    return
  displayName: 'Sidebar'
  clickHandler:(e)=>
    targ = e.currentTarget.parentNode.childNodes[1]
    if "true" == targ.getAttribute "aria-expanded"
      targ.setAttribute 'aria-expanded', false
      targ.setAttribute 'hidden',"hidden"
    else
      targ.setAttribute 'aria-expanded', 'true'
      targ.removeAttribute 'hidden'
    return
    
  view: (vnode)=>
    collection = vnode.collection
    filter = vnode.filter || ()->true
    intermediate = collection.filter filter,@
    data = _.sortBy( intermediate, (s)-> s.get 'category')
    data = _.groupBy( data, (s)-> s.get 'category')
  
    teacupContent = template.widgetWrap  title: "Contents", =>
      result= _.each data, (allCrap,category,stuff)=>
        return if category =='-'
        stories = stuff[category]
        catPostfix = category.match /\/?[^\/]+$/
        catPrefix = category.replace /[^\/]/g,''
        catPrefix = catPrefix.replace /\//g, ' -'
        catPostfix = catPostfix.toString().replace /\//g, '- '
        headliner = _(stories).find (story)=> #find index for this category
          autoExpand = Object.keys(stuff).length <4  #start with open if number of elements in this category is small
          attrX =
            'aria-expanded':autoExpand
            onclick:
              @clickHandler
            role:
              'heading'
          T.div '.btn-group.btn-group-vertical', =>
            if headliner
              T.button ".btn.btn-group.btn-outline-light.btn-block", attrX, =>T.h5 '', =>
                T.text "#{category}: "
                T.em ".h6", _.sample headliner.get 'headlines'
            else
              T.button ".btn.btn-group.btn-outline-light.btn-block", attrX, => T.h6 '', "#{catPrefix} #{catPostfix}"
            attrY =
              'aria-expanded':autoExpand
            attrY.hidden='hidden' unless autoExpand

            T.section ".pr1.btn-group.btn-outline-light", attrY,=>
              T.ul ".my-2",=>
                _(stuff[category]).each (story) =>
                  return if 'category' == story.get 'className'
                  T.li "", =>
                    T.a "",
                      'color': 'white'
                      #bg: 'gray.8'
                      href: if siteHandle == story.get 'siteHandle'
                        story.href()
                      else
                        story.href story.get 'siteHandle'
                      "#{story.get 'title'}"
  
      return T.text "No Stories" unless result
    return teacupContent
ss=new sideStuff()
module.exports =  T.bless sideStuff
module.exports= ss.view

