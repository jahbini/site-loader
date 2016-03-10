###
styling: "skeleton"
_options:

###
{doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,
 tag,footer} = require "teacup"
module.exports = renderable (story) ->
  options = story.attributes
  debugger
  h2 "goodstuff from header-logo-nav"
