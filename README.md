# site-master
Multiple static sites run from a single Brunch directory

This project will generate one or several static websites (separate domains) from separate text files in an augmented
markdown which allows whole pages to be written in Teacup.

A summary file consisting of JSON describing all pages is created and placed in a location where Brunch can pick it up and
assemble it into the front end javascript.

The SubSites are NPM modules.  These modules contain a site.js file to describe meta data for the html head section.
The module contains a directory named brunch-payload- which has all the styling information for the site.  Finally,
The module contins a directory named contents. This is where all the source text files are found.

Two sites that are generated with this methodology are http://stjohnsjim.com/ (some stories - try one, you might laugh) and
http://bamboosnow.com/  (about an amazing and useful substance I discovered on the tropic island of Saipan)

An example of a page written extended markdown where code fences are used to execute embedded coffeeScript in the source file:  http://stjohnsjim.com/announcement/new-look.html 
