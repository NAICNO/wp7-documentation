#!/bin/bash
# Avoid  storing the token in log files or any 
# out put files

declare -A vaktlist
vaktlist['1']='A,B,C,D'
vaktlist['2']='E,F,G,D'
vaktlist['3']='K,L,M,D'
vaktlist['4']='A,F,G,D'
vaktlist['5']='NA,NA'
vaktlist['6']='NA,NA'
vaktlist['7']='NA,NA'
vaktlist['8']='NA,NA'
vaktlist['9']='NA,NA'
vaktlist['10']='NA,NA'
vaktlist['11']='NA,NA'
vaktlist['12']='NA,NA'
vaktlist['13']='W13-m,W13-1,W13-2,W13-3'
vaktlist['14']='W14-m,W14-1,W14-2,W14-3'
vaktlist['15']='NA,NA'
vaktlist['16']='NA,NA'
vaktlist['17']='NA,NA'
vaktlist['18']='NA,NA'
vaktlist['19']='NA,NA'
vaktlist['20']='NA,NA'
vaktlist['21']='NA,NA'
vaktlist['22']='NA,NA'
vaktlist['23']='NA,NA'
vaktlist['24']='NA,NA'
vaktlist['25']='NA,NA'
vaktlist['26']='NA,NA'
vaktlist['27']='NA,NA'
vaktlist['28']='NA,NA'
vaktlist['29']='NA,NA'
vaktlist['30']='NA,NA'
vaktlist['31']='NA,NA'
vaktlist['32']='NA,NA'
vaktlist['33']='NA,NA'
vaktlist['34']='NA,NA'
vaktlist['35']='NA,NA'
vaktlist['36']='NA,NA'
vaktlist['37']='NA,NA'
vaktlist['38']='NA,NA'
vaktlist['39']='NA,NA'
vaktlist['40']='NA,NA'
vaktlist['41']='NA,NA'
vaktlist['42']='NA,NA'
vaktlist['43']='NA,NA'
vaktlist['44']='NA,NA'
vaktlist['45']='NA,NA'
vaktlist['46']='NA,NA'
vaktlist['47']='NA,NA'
vaktlist['48']='NA,NA'
vaktlist['49']='NA,NA'
vaktlist['50']='NA,NA'
vaktlist['51']='NA,NA'
vaktlist['52']='NA,NA'

current_week=$(date +"%U")
next_week=$(date -d "+1 week" +"%U")

#can not get a vlaue using bariable
current_vakt=${vaktlist[$current_week]}
next_vakt=${vaktlist[$next_week]}

#echo "$current_week"
#echo "$current_vakt"
##echo "${vaktlist[$current_week]}"
#echo "$next_week"
#echo "$next_vakt"

current_main_vakt=$(echo $current_vakt | cut -d "," -f 1)
next_main_vakt=$(echo $next_vakt | cut -d "," -f 1)
next_team=$(echo $next_vakt | cut -d "," -f 2-)

echo "Ukevakt handover from $current_main_vakt -> $next_main_vakt. Next weeks team $next_team" 
