# site-master
Serve multiple static sites run from a single Brunch directory

This project will generate one or several static websites (separate domains) from separate text files in an augmented
markdown which allows whole pages to be written in Teacup.

A summary file consisting of JSON describing all pages is created and placed in a location where Brunch can pick it up and
assemble it into the front end javascript.

The SubSites are NPM modules.  These modules contain a site.js file to describe meta data for the html head section.
The module contains a directory named brunch-payload- which has all the styling information for the site.  Finally,
The module contins a directory named templates. This is where all the source files are found.

All the pages are rendered directly from coffee-script into HTML.  The sources used to be in Markdown and hosted by a server running Keystone and Express with the actual stories served by a mongo server.

The experience was less than perfect, Mongo and Keystone sometimes fought for swap space, and the containers would die.  The editor for mmrkdown that Keystone provides was a headache.  The conversion to React made all the pages balloon out of proportion to their content.  And finally, Markdown was a very restrictive vehicle for text expression via the web.

After giving up in late November, everything has been converted to static html in coffee-script using Halvalla.  Each story is actually executed to produce the final html.

Two sites that are generated with this methodology are http://stjohnsjim.com/ (some stories - try one, you might laugh) and
http://bamboosnow.com/  (about an amazing and useful substance I discovered on the tropic island of Saipan)
