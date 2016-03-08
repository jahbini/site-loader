###
styling: "skeleton"
_options:
  partials:
    headlogo: "site/layouts/header-logo-nav"

###
{doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,
 tag,footer} = require "teacup"

module.exports = renderable (story) ->
  options = story.get 'options'
  doctype 5
  html ->
    head ->
      title options.title
      meta "http-equiv": "content-type", content: "text/html; charset=utf-8"
      meta name: "description", content: "A great #{options.category}"
      meta name: "viewport", content: "width=device-width"
      base href: "/"
      meta name: "keywords", content: "North Portland,St. John's, st johns"
      link rel: "stylesheet", href: "stylesheets/app.css"
      script src: 'javascripts/vendor.js'
      script src: 'javascripts/app.js'
      script "require('initialize');"
    body "#body.enclosing", ->
      header "data-id":"header", ->
        raw "{{headlogo}}"

      section ".app-container", "data-id":"app"
      comment "The Main template"
      div "#main.wrapper.style4", ->
        div ".container", ->
          div ".row", ->
            comment "Content"
            div "#content.eight.columns", ->
              raw options.content
            comment "Sidebar"
            div "#sidebar.four.columns", ->
              a href:'showit', "this is contents of sidebar"
      tag 'footer', "data-id":"footer"
