###
styling: "skeleton"
_options:

###
{doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,i,img,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,nav,ul,li,
 tag,footer} = require "teacup"
module.exports = renderable (story) ->
  options = story.attributes
  header "#header", "data-behavior":"1", ->
    i "#btn-open-sidebar.fa.fa-lg.fa-bars"
    h1 ".header-title", ->
        a ".header-title-link", href:"/ ", "Bamboo Snow"
    a ".header-right-picture", href:"/#about",->
      img ".header-picture",
       src:"http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=90"
  nav '#sidebar', "data-behavior": '1', ->
    div '.sidebar-profile', ->
      a href: '/#about', ->
        img '.sidebar-profile-picture', src: 'http://www.gravatar.com/avatar/c105eda1978979dfb13059b8878ef95d?s=110'
      span '.sidebar-profile-name', 'James A. Hinds (Bamboo Jim)'
    ul '.sidebar-buttons', ->
      li '.sidebar-button', ->
        a '.sidebar-button-link.', href: '/', ->
          i '.sidebar-button-icon.fa fa-lg fa-home'
          span '.sidebar-button-desc', 'Home'
      li '.sidebar-button', ->
        a '.sidebar-button-link.', href: '/all-categories', ->
          i '.sidebar-button-icon.fa fa-lg fa-bookmark'
          span '.sidebar-button-desc', 'Categories'
      li '.sidebar-button', ->
        a '.sidebar-button-link.', href: '/all-tags', ->
          i '.sidebar-button-icon.fa fa-lg fa-tags'
          span '.sidebar-button-desc', 'Tags'
      li '.sidebar-button', ->
        a '.sidebar-button-link.', href: '/all-archives', ->
          i '.sidebar-button-icon.fa fa-lg fa-archive'
          span '.sidebar-button-desc', 'Archives'
      li '.sidebar-button', ->
        a '.sidebar-button-link.st-search-show-outputs', href: '/#search', ->
          i '.sidebar-button-icon.fa fa-lg fa-search'
          span '.sidebar-button-desc', 'Search'
      li '.sidebar-button', ->
        a '.sidebar-button-link.', href: '/#about', ->
          i '.sidebar-button-icon.fa fa-lg fa-question'
          span '.sidebar-button-desc', 'About'
    ul '.sidebar-buttons', ->
      li '.sidebar-button', ->
        a '.sidebar-button-link.', href: 'https://github.com/jahbini', target: '_blank', ->
          i '.sidebar-button-icon.fa fa-lg fa-github'
          span '.sidebar-button-desc', 'GitHub'
      li '.sidebar-button', ->
        a '.sidebar-button-link.', href: 'https://facebook.com/BambooCanDo', target: '_blank', ->
          i '.sidebar-button-icon.fa fa-lg fa-facebook'
          span '.sidebar-button-desc', 'Facebook'
      li '.sidebar-button', ->
        a '.sidebar-button-link.', href: 'https://www.linkedin.com/in/jimhinds/', target: '_blank', ->
          i '.sidebar-button-icon.fa fa-lg fa-linkedin'
          span '.sidebar-button-desc', 'LinkedIn'
    ul '.sidebar-buttons', ->
      li '.sidebar-button', ->
        a '.sidebar-button-link.', href: '/atom.xml', ->
          i '.sidebar-button-icon.fa fa-lg fa-rss'
          span '.sidebar-button-desc', 'RSS'
