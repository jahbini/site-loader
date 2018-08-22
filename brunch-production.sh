#! /bin/bash
#
for i in stjohnsjim bamboosnow celarien 411-source;
 do 
   SITE=$i brunch b -p
 done
 
cake srp all

for i in stjohnsjim bamboosnow celarien 411-source;
 do 
   purifycss public-$i/assets/css/vendor.css public-$i/assets/css/app.css ./white-list.html public-$i/*/*.html -o public-$i/app.css -i -m -w '*-child*' -w '*loaded*' -w 'c-list' 
   #gzip public-$i/app.css
 done
