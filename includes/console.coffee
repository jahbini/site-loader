bind = (func, inst) ->
  args = toArray(arguments).slice(2)
  ->
    func.apply inst or this, args.concat(toArray(arguments))
    return
#include console
do ->
  consoles = {}

#include console
  History = ->
    index = -1
    history = []
    extend this,
      clear: ->
        history = []
        return
      reset: ->
        index = history.length
        return
      previous: ->
        history[index = Math.max(--index, 0)]
      next: ->
        history[index = Math.min(++index, history.length)]
      push: (data) ->
        if history[history.length - 1] != data
          history.push data
          @reset()
        return

  Console = (el, scope) ->
    jsonize = (msg) ->
      stringify = (obj, replacer, spaces, cycleReplacer) ->
        JSON.stringify obj, serializer(replacer, cycleReplacer), spaces
      serializer = (replacer, cycleReplacer) ->
        stack = []
        keys = []
        if cycleReplacer == null
          cycleReplacer = (key, value) ->
            if stack[0] == value
              return '[Circular ~]'
            '[Circular ~.' + keys.slice(0, stack.indexOf(value)).join('.') + ']'
            
        (key, value) ->
          if stack.length > 0
            thisPos = stack.indexOf(this)
            if ~thisPos then stack.splice(thisPos + 1) else stack.push(this)
            if ~thisPos then keys.splice(thisPos, Infinity, key) else keys.push(key)
            if ~stack.indexOf(value)
              value = cycleReplacer.call(this, key, value)
          else
            stack.push value
          if replacer == null then value else replacer.call(this, key, value)
      return

    log = (level) ->
      msg = if arguments.length == 2 then arguments[1] else toArray(arguments).slice(1)
      result = create('div', { 'class': 'result' }, output(msg))
      elT = addClass(create('p', null, result), typeOf(msg), level)
      firstElement = container.firstChild
      container.insertBefore elT, container.firstChild
      children = container.childNodes
      max = container.parentNode.dataset.limit || 20
      while children.length > max
        container.removeChild children[children.length-2]
      elT

    exec = (command) ->
      if !command
        return
      cmd = text(create('div', 'class': 'command'), command)
      level = 'info'
      msg = undefined
      try
        msg = (
          (scope) ->
            eval command
        ).call(scope)
      catch err
        msg = err
        level = 'error'
      elT = log(level, msg)
      elT.insertBefore cmd, elT.childNodes[0]
      elT.scrollTop = elT.scrollHeight
      container.scrollTop = container.scrollHeight
      history.push command
      return

    if typeof el == 'string'
      el = document.getElementById(el)
    console = consoles[el]
    if console
      console.cd scope
      return console
    else if !(this instanceof Console)
      if !console
        console = new Console(el, scope)
      return console
    consoles[el] = this
    scope or (scope = window)
    limbo = create('div')
    while node = el.childNodes[0]
      limbo.appendChild node
    container = create('div', 'class': 'console-container')
    inputContainer = create('p', 'class': 'console-input')
    input = create('textarea', row: 1)
    original = 
      className: el.className
      tabIndex: el.tabIndex
    inputContainer.appendChild input
    container.appendChild inputContainer
    addClass(el, 'console').appendChild container
    if el.tabIndex < 0
      el.tabIndex = 0
    listen el, 'focus', ->
      input.focus()
      return
    history = new History
    listen input, 'keydown', (event) ->
      switch event.keyCode
        when 13
          # enter
          event.preventDefault()
          exec @value
          @value = ''
          return false
        when 38
          # up
          if cmd = history.previous()
            input.value = cmd
          event.preventDefault()
          return false
        when 40
          # down
          if cmd = history.next()
            input.value = cmd
          else
            input.value = ''
          event.preventDefault()
          return false
      return
    listen input, 'blur', ->
      history.reset()
      return
    extend this,
      cd: (s) ->
        scope = s
        return
      setDepth: (d)=>
        @depth = d
      log: ->
        @info.apply this, arguments
        return
      info: bind(log, this, 'info')
      warn: bind(log, this, 'warn')
      error: bind(log, this, 'error')
      clear: ->
        `var el`
        prev = inputContainer.previousSibling
        while prev
          elT = prev
          prev = elT.previousSibling
          elT.parentNode.removeChild elT
        return
      destroy: ->
        for k of original
          el[k] = original[k]
        while node = el.childNodes[0]
          el.removeChild node
        while node = limbo.childNodes[0]
          el.appendChild node
        # delete limbo;
        # delete output;
        # delete input;
        # delete original;
        return

  create = (tagName, attrs) ->
    el = document.createElement(tagName)
    if attrs
      for k of attrs
        el.setAttribute k, attrs[k]
    i = 2
    while i < arguments.length
      el.appendChild arguments[i]
      ++i
    el

  text = (el, text) ->
    if typeof el == 'string' or typeof el == 'number'
      return document.createTextNode(el)
    el.appendChild document.createTextNode(text)
    el

  addClass = (el) ->
    `var i`
    classes = []
    i = 1
    while i < arguments.length
      classes = classes.concat(arguments[i].split(/\s+/))
      ++i
    if el.classList
      for i of classes
        el.classList.add classes[i]
    else
      classes = el.className.split(/\s+/).concat(classes)
      el.className = classes.join(' ')
    el

  listen = (el, event, callback) ->
    onevent = 'on' + event
    if el.addEventListener
      return el.addEventListener(event, callback, false)
    else if el.attachEvent
      return el.attachEvent(onevent, callback)
    else if onevent of el
      return el[onevent] = callback
    return

  extend = (src) ->
    i = 1
    while i < arguments.length
      obj = arguments[i]
      for k of obj
        src[k] = obj[k]
      ++i
    src

  toArray = (arr) ->
    Array::slice.call arr

  bind = (func, inst) ->
    args = toArray(arguments).slice(2)
    ->
      func.apply inst or this, args.concat(toArray(arguments))
      return

  typeOf = (obj) ->
    if Object::toString.call(obj) == '[object Array]'
      'array'
    else if Object::toString.call(obj) == '[object Error]'
      'error'
    else if obj == null
      'null'
    else if obj and obj.nodeType == 1
      'element'
    else
      typeof obj
      
  output = (result, deep=@depth) ->
    `var val`
    `var i`
    type = typeOf(result)
    switch type
      when 'null', 'undefined'
        return create('span', { 'class': type }, text(type))
      when 'array'
        arr = create('ol', 'class': type)
        for i of result
          val = result[i]
          arr.appendChild create('li', null, output(val,deep-1))
        return arr
      when 'object'
        obj = create('dl', 'class': type)
        for k of result
          if !(k of result.__proto__)
            val = if deep == 0 then text(k) else output(result[k], deep-1)
            obj.appendChild create('dt', null, text(k))
            obj.appendChild create('dd', null, val)
        return obj
      when 'element'
        nodeName = result.nodeName.toLowerCase()
        attrs = create('dl')
        open = create('div', { 'class': 'open' }, text(nodeName), attrs)
        close = create('div', { 'class': 'close' }, text(nodeName))
        html = create('div', { 'class': 'content' }, text(result.innerHTML))
        i = 0
        while i < result.attributes.length
          attr = result.attributes[i]
          attrs.appendChild create('dt', null, text(attr.name))
          attrs.appendChild create('dd', null, text(attr.value))
          ++i
        return create('div', { 'class': type }, open, html, close)
      when 'number'
        return create('span', { 'class': type }, text(result.toFixed(2)))
      else
        return create('span', { 'class': type }, text(result.toString()))
    return

  Console.log = ->
    return

  window.Console = Console
  return
    #