#!/bin/bash
# Usage
# bash userdetails.sh <TOKEN> > ../documents/_static/userdetails.js


token=$1

result=$(eval 'curl --request GET --header "PRIVATE-TOKEN: $token" "https://gitlab.sigma2.no/api/v4/users?active=true&without_project_bots=true&order_by=name&sort=asc&per_page=500"' )

userlist=$(echo $result |   jq -r '.[] | [":user_details_map.set(\"", .username,"\",\"",.name,"\");"] | join("")')

out="const user_details_map = new Map();"
IFS=":"
for u in $userlist
do
  cuser=$(echo $u | tr '\n' ' '| tr '\t' ' ') 
  out=${out}$'\n'${cuser}
done
out=$out$'\n'

out=$out$'\n'"function getfullname(username){"
out=$out$'\n'"  if( !! username){"
out=$out$'\n'"    const name= user_details_map.get(username);"
out=$out$'\n'"    if( !! name){"
out=$out$'\n'"       return name;"
out=$out$'\n'"    }  else{"
out=$out$'\n'"       return  \"\";"
out=$out$'\n'"    }"
out=$out$'\n'"  }else{"
out=$out$'\n'"     return  \"\";"
out=$out$'\n'"  }"
out=$out$'\n'"}"
out=$out$'\n'
echo "$out"
unset IFS
