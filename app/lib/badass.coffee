T = Pylon.Teact
B = require 'backbone'
{  Panel, PanelHeader, Link } = Pylon.Rebass
  
Panel = T.bless Panel
Link = T.bless Link
PanelHeader = T.bless PanelHeader


Template = require "payload-/#{siteHandle}.coffee"
template = new Template T

module.exports.Panel =   class Panel extends B.Model
  displayName: 'Panel'
  constructor: (@vnode)->
      @props={}
    console.log @vnode
    @
  style: (props)=>
      overflow: 'hidden'
      borderRadius: px @props.theme.radius
      borderWidth: px 1
      borderStyle: 'solid'
  view: ()->
      T.div style: @style @vode.style
module.exports.PanelHeader =   class PanelHeader extends B.Model
  displayName: 'PanelHeader'
  constructor: (@vnode)->
    @props= f:2, p:2
    console.log "PanelHeader constructor",@vnode
    @
    
  style: (props)=>
    fontWeight: bold(props),
    borderBottomWidth: px(1),
    borderBottomStyle: 'solid',
  view: ()->
      T.crel 'Header', style: @style @vode.style
      
