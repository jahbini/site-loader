exports.config =
  # See http://brunch.io/#documentation for docs.
  files:
    javascripts:
      joinTo:
        'stjohnsjim/app.js': /^app/
        'stjohnsjim/vendor.js': /^(?!app)/
        'bamboosnow/app.js': /^app/
        'bamboosnow/vendor.js': /^(?!app)/
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(?!app)/

    stylesheets:
      joinTo: 'stylesheets/app.css'

    templates:
      joinTo: 'javascripts/app.js'
