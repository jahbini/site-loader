MenuController = require 'controllers/menu'
FooterController = require 'controllers/footer'
HomeController = require 'controllers/home'
SideBar = require 'components/sidebar-view.coffee'
StoryBarController = require 'controllers/storybar'
React = require 'react'
jsonp = require 'jsonp'
assign = require 'object-assign'
T= require 'teact'
{ Flex, Box } = require 'reflexbox'
Flex = T.bless Flex
Box = T.bless Box
SideBar = T.bless SideBar


config = require 'config'
configurations = 
  basic: require 'configurations/basic.js'
  biblio: require 'configurations/biblio.js'
  #bold: require 'configurations/bold.js'
  #dark: require 'configurations/dark.js'
  #dense: require 'configurations/dense.js'
  #err: require 'configurations/err.js'
  #hello: require 'configurations/hello.js'
  #index: require 'configurations/index.js'
  #init: require 'configurations/init.js'
  #mono: require 'configurations/mono.js'
  #pink: require 'configurations/pink.js'

'use strict'
###
HomeController = T.bless HomeController
SideBarController  = T.bless SideBarController 
StoryBarController  = T.bless StoryBarController 
MenuController  = T.bless MenuController 
FooterController = T.bless FooterController

module.exports = class Application extends Chaplin.Application

  initialize: ->
    window.APP = @
    @initDispatcher controllerSuffix: '', controllerPath: 'controllers/'
    @initLayout()
    @initComposer()
    @initMediator()
    @initControllers()

    # Register all routes and start routing
    @initRouter routes, {root: '/', pushState: false}

    @start()

    # Freeze the object instance; prevent further changes
    Object.freeze? @

  initMediator: ->
    # Attach with semi-globals here.
    Chaplin.mediator.controllerAction = ""
    Chaplin.mediator.actionParams = {}

  initControllers: ->
    new HomeController
    new SideBarController
    new StoryBarController
    new MenuController
    new FooterController

import {
  config,
  Banner,
  Block,
  Button,
  Close,
  Container,
  Drawer,
  Heading,
  NavItem,
  Panel,
  PanelHeader,
  SectionHeader,
  Footer,
  Space,
  Text,
} from '../../src'

import init from '../configurations/init'
import configurations from '../configurations'

import Navbar from './Navbar'
import Cheader from './Cheader.coffee'
import Header from './Header.js'
import Intro from './Intro'
import Cards from './Cards'
import DataDemo from './DataDemo'
import BlockPanel from './BlockPanel'
import Checkout from './Checkout'
import Forms from './Forms'
import Headings from './Headings'
import Colors from './Colors'
import Comments from './Comments'
import MegaFooter from './MegaFooter'
import ConfigForm from './ConfigForm'
import Modal from './Modal'
###

class App extends React.Component 
  constructor:()->
    super()
    this.state = assign(
      {},
      config,
      configurations.biblio, {
        drawerOpen: false,
        dropdownOpen: false,
        modalOpen: false,
        config: 'Basic',
        repo: {}
      }
    )
    this.toggle = this.toggle.bind(this)
    this.switchConfig = this.switchConfig.bind(this)
    this.updateContext = this.updateContext.bind(this)
    this.handleChange = this.handleChange.bind(this)
    this.resetTheme = this.resetTheme.bind(this)
  

  childContextTypes = rebass: React.PropTypes.object

  getChildContext=  ()->
    return rebass: this.state

  toggle: (key)->
    return (e) =>
      val = !this.state[key]
      this.setState "#{key}": val

  switchConfig: (key)->
    return (e) =>
      theme = assign {}, config, configurations[key]
      console.log theme.name
      this.resetTheme () =>
        x= assigntheme
        x.config = theme.name
        x.dropdownOpen = false
        this.setState x

  resetTheme: (cb)->
    this.setState(init, cb)

  updateContext: (state)-> 
    this.setState(state)

  handleChange: (e) ->
    this.setState "#{e.target.name}": e.target.value

  componentDidMount: ()-> 
    jsonp 'https://api.github.com/repos/jxnblk/rebass?callback=callback', 
      (err, response) =>
        @.setState repo: response.data

  render: ()-> 
    {
      fontFamily,
      fontWeight,
      letterSpacing,
      color,
      backgroundColor,
      drawerOpen,
      overlayOpen
    } = this.state

    mainStyle =  {
          fontFamily,
          fontWeight,
          letterSpacing,
          color,
          backgroundColor
        }
    return T.div mainStyle,()->
      HomeController
      SideBar
        collection: require 'models/stories'
        filter: (s)->
          (s.get 'siteHandle') == siteHandle
      StoryBarController
      MenuController
      FooterController
 
 ### 
      <div style={{
          fontFamily,
          fontWeight,
          letterSpacing,
          color,
          backgroundColor
        }}>
        <Navbar {...this.state}
          configurations={configurations}
          switchConfig={this.switchConfig}
          toggle={this.toggle} />
        <Cheader toggle={this.toggle} />
        <Header toggle={this.toggle} />
        <Container style={{
            transition: 'transform .3s ease-out',
            transform: drawerOpen ? 'translateX(-20%)' : 'translateX(0)'
          }}>
          <Intro />
          <Cards {...this.state} />
          <DataDemo
            {...this.state}
            {...this.props} />
          <BlockPanel toggle={this.toggle} />
          <Checkout />
          <Forms />
          <Headings {...this.state} />
          <Colors {...this.state} />
          <Comments />
        </Container>
        <MegaFooter {...this.state} />
        <ConfigForm
          {...this.state}
          toggle={this.toggle}
          onChange={this.updateContext}
          reset={this.resetTheme} />
        <Modal {...this.state}
          toggle={this.toggle} />
      </div>
    )
  }
}
###

module.exports = App

