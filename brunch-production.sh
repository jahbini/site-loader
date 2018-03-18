#! /bin/bash
#
for i in stjohnsjim bamboosnow celarien;
 do 
   SITE=$i brunch b -p
 done
 
cake srp all

for i in stjohnsjim bamboosnow celarien;
 do 
   purifycss public-$i/assets/css/vendor.css public-$i/assets/css/app.css public-$i/*/*.html -o public-$i/app.css -i -m -w '*-child*' -w '*loaded*'
   #gzip public-$i/app.css
 done
