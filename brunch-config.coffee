exports.config =
  # See http://brunch.io/#documentation for docs.
  files:
    javascripts:
      joinTo:
        'stjohnsjim/js/app.js': /^app/
        'stjohnsjim/js/vendor.js': /^(?!app)/
        'bamboosnow/js/app.js': /^app/
        'bamboosnow/js/vendor.js': /^(?!app)/

    stylesheets:
      joinTo:
        'stjohnsjim/css/app.css': /^app/
        'bamboosnow/css/app.css': /^app/

    templates:
      joinTo:
        'stjohnsjim/js/app.js': /^app/
        'bamboosnow/js/app.js': /^app/
