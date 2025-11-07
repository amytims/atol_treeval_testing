#!/bin/bash

# this is a tweaked version of the bed_to_contacts.sh script that kept giving me an OOM error
# will pull request it at some point, but for now I'll just keep a copy for testing purposes

version='1.0.0'
if [ $1 == '-v' ];
then
    echo "$version"
else
    paste -d '\t' - - < $1 | awk 'BEGIN {FS="\t"; OFS="\t"} {if ($1 > $7) {print substr($4,1,length($4)-2),$12,$7,$8,"16",$6,$1,$2,"8",$11,$5} else {print substr($4,1,length($4)-2),$6,$1,$2,"8",$12,$7,$8,"16",$5,$11} }' | tr '\-+' '01'  | sort -k3,3d -k7,7d --parallel=12 -S50G -T . | awk 'NF==11'
fi
