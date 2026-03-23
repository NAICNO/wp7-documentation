#!/bin/bash
# Usage
# bash userdetails.sh <TOKEN> > ../documents/templates/user-list.rst 

token=$1

result=$(eval 'curl --request GET --header "PRIVATE-TOKEN: $token" "https://gitlab.sigma2.no/api/v4/users?active=true&without_project_bots=true&order_by=name&sort=asc&per_page=500"' )

#userlist=$(echo $result |   jq -r '.[] | ["\"", .name,"\":" ,"\"",.username,"\","] | join("")')
userlist=$(echo $result |   jq -r '.[] | [",",.name,"=",.username] | join("")')

out=""

IFS=","
for u in $userlist
do
  if [[ ! -z $out ]]
  then
     out=$out$'\n'
  fi	 

  if [[ ! -z $u ]]
  then
    user="   * - "
    user=$user$(echo $u | sed  's/=/\n     - /g')
    out=${out}${user}
  fi	 
  #out=" "${out}"  "${u}$'\n'
 # if [[ -z $out ]]
 # then
 #    out=$'\n'
 # else
 # out=$out,$'\n'
 # fi	 
 # cuser=$(echo $u | tr '\n' ' '| tr '\t' ' ') 
 # out=" "${out}"  "${cuser}$'\n'
done
out=$out$'\n'


headings="GitLab.sigm2.no user list"
headings=$headings$'\n'"========================="
headings=$headings$'\n'
headings=$headings$'\n'
headings=$headings$'\n'".. list-table:: User names"
headings=$headings$'\n'"   :widths: 40 20"
headings=$headings$'\n'"   :header-rows: 1"
headings=$headings$'\n'
headings=$headings$'\n'"   * - Name"
headings=$headings$'\n'"     - GitLab username"
headings=$headings$'\n'

headings=$headings$out

echo "$headings"
unset IFS
