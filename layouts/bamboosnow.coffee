###
styling: "Lookand Feel"

###
{render,doctype,html,title,meta,base,link,script,body,header,raw,section,
 comment,div,a,span,h1,h2,h3,h4,h5,h6,head,renderable,blockquote,
 tag,footer} = require "teacup"
path = require 'path'
headerLogoNav = require(path.resolve './layouts/header-logo-nav')
Backbone = require 'backbone'
fs = require 'fs'
ClassLookAndFeel = require './layouts/default'

module.exports = class BamboosnowLook extends ClassLookAndFeel
