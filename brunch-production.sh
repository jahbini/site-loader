#! /bin/bash
#
for i in lowroller stjohnsjim bamboosnow celarien 411-source;
 do 
   SITE=$i brunch b -p
 done
 
cake srp all

for i in lowroller stjohnsjim bamboosnow celarien 411-source;
 do 
   j=domains/$i/public
   purifycss $j/assets/css/vendor.css $j/assets/css/app.css ./white-list.html $j/*/*.html -o $j/app.css -i -m -w '*-child*' -w '*loaded*' -w 'c-list' 
   #gzip public-$i/app.css
 done
