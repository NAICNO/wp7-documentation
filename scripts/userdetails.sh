#!/bin/bash
# Usage
# bash userdetails.sh <TOKEN> > ../documents/_static/userdetails.json


token=$1

result=$(eval 'curl --request GET --header "PRIVATE-TOKEN: $token" "https://gitlab.sigma2.no/api/v4/users?active=true&without_project_bots=true&order_by=name&sort=asc&per_page=500"' )

userlist=$(echo $result |   jq -r '.[] | ["\"", .username,"\":" ,"\"",.name,"\","] | join("")')

out=""
IFS=","
for u in $userlist
do
  if [[ -z $out ]]
  then
     out="{"$'\n'
  else
     out=$out,$'\n'
  fi	 
  cuser=$(echo $u | tr '\n' ' '| tr '\t' ' ') 
  out=${out}${cuser}
done
out=$out$'\n'"}"
echo "$out"
unset IFS
