
  Model = require 'models/base/model'

  'use strict'

  module.exports = class Navigation extends Model

    defaults:
      items: [
        {href: '/', title: 'Likes Browser'}
        {href: '/posts', title: 'Wall Posts'}
      ]
