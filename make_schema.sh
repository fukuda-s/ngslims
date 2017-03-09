#!/bin/sh

 mysqldump --no-data ngslims | perl -ne 's/AUTO_INCREMENT=\d+/AUTO_INCREMENT=1/;print' >| schemas/ngslims.sql 
