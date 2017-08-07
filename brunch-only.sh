#! /bin/bash
#
for i in stjohnsjim bamboosnow celarien;
 do 
   SITE=$i brunch b
   (cd /site-master/public-$i ;
     for j in css js ;
       do cat assets/$j/vendor.$j | gzip > assets/$j/vendor.$j.gz;
          cat assets/$j/app.$j | gzip > assets/$j/app.$j.gz; 
          cat assets/$j/vendor.$j.map | gzip > assets/$j/vendor.$j.map.gz; 
          cat assets/$j/app.$j.map | gzip > assets/$j/app.$j.map.gz; 
          
       done );
 done
