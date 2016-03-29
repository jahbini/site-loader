###
styling: "skeleton"
_options:

###
{doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,
 tag,footer} = require "teacup"
doingOG = false
doingTwitter = false
doingFaceBook = false
doingXML = false
module.exports = renderable (story) ->
  options = story.attributes
  doctype html
  head ->
    meta "http-equiv":"Content-Type", content:"text/html", charset:"UTF-8"
    meta name:"viewport", content:"width=device-width, initial-scale=1"
    meta name:"generator", content: options.slug
    title options.title
    meta name:"author", content:"James A. Hinds (Bamboo Jim,St John's Jim)" #JAH use site based params
    meta name: "description", content: "A great #{options.category}"
    meta name:"keywords", content:"bamboo snow,bamboo byproduct,bamboo"
    meta name: "keywords", content: "North Portland,St. John's, st johns"
    if doingXML
      link rel:"alternate", type:"application/atom+xml", title:"RSS", href:"/atom.xml"
    if doingOG
      meta property:"og:type", content:"news"
      meta property:"og:title", content:"Bamboo Snow"
      meta property:"og:url", content:"http://bamboosnow.com/index.html"
      meta property:"og:site_name", content:"Bamboo Snow"
      meta property:"og:description", content:"Information regarding the economic impact of bamboo snow"
    if doingTwitter
      meta name:"twitter:card", content:"summary"
      meta name:"twitter:title", content:"Bamboo Snow"
      meta name:"twitter:description", content:"Information regarding the economic impact of bamboo snow"
      meta name:"twitter:creator", content:"@BabaBambooJim"
    if doingFaceBook
      meta property:"fb:app_id", content:"271501872999476"
    base href: "/"
    link rel: "stylesheet", href: "css/app.css"
    link rel: "stylesheet", href: "css/vendor.css"
    script src: 'js/vendor.js'
    script src: 'js/app.js'
    script "siteHandle = '#{options.siteHandle}'; require('initialize');"
