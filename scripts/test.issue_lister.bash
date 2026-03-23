#!/bin/bash

RESULT="${1}" 
# load name to id map first to associated array
ci=0
out="<ul>"
while [[ "${ci}" -lt "$(echo "${RESULT}" | jq 'length')" ]]   
do
	ID=$(echo  ${RESULT}| jq --arg id ${ci} '.[$id|tonumber]|.iid') 
	WEB_URL=$(echo  ${RESULT}| jq --arg id ${ci} '.[$id|tonumber]|.web_url ') 
	TITLE=$(echo  ${RESULT}| jq --arg id ${ci} '.[$id|tonumber]|.title') 
	ASSIGNEE=$(echo  ${RESULT}| jq --arg id ${ci} '.[$id|tonumber]|.assignee') 
	CREATED_DATE=$(echo  ${RESULT}| jq --arg id ${ci} '.[$id|tonumber]|.created_at') 
	LABELS=$(echo  ${RESULT}| jq --arg id ${ci} '.[$id|tonumber]|.labels' | tr '\n' '|')
	#echo "Issue_id=${ID} TITLE=${TITLE} ASSIGNEE=${ASSIGNEE} CREATED_DATE=${CREATED_DATE} LABELS=${LABELS}"
        out=${out}$'\n'"<li>"
        out=${out}"ID=${ID}"
        out=${out}$'\n'"  <ul>"
        out=${out}$'\n'"    <li>"
        out=${out}"    WEB_URL=${WEB_URL}"
        out=${out}"      </li>"
        out=${out}$'\n'"    <li>"
        out=${out}"    TITLE=${TITLE}"
        out=${out}"      </li>"
        out=${out}$'\n'"    <li>"
        out=${out}"    LABELS=${LABELS}"
        out=${out}"      </li>"
        out=${out}$'\n'"  </ul>"
        out=${out}$'\n'"</li>"
	let ci=ci+1
done

out=${out}$'\n'"</ul>"
echo "${out}"
