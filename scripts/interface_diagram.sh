#!/bin/bash
# Generate interface diagram from snipet

if [[ "$#" -ge 4 ]]
then
   TOKEN="${1}"	
   API_URL="${2}"	
   TARGET="${3}"
   PROCESS="${4}"
   PROCESS="${PROCESS^^}"
   PROCESS_JSON=$(curl --header "PRIVATE-TOKEN: ${TOKEN}" "${API_URL}/snippets/37/raw" | jq '.PROCESS') 
   if [[ ! -z "${PROCESS_JSON}" ]]
   then
	   PROSSES_SNIPPRT=$(echo $PROCESS_JSON | jq  --arg NAME "${PROCESS}" '.[] | select(.NAME==($NAME)).DIAGRAM')
	   if [[ ! -z "${PROSSES_SNIPPRT}" ]]
           then
              PROSSES_SNIPPRT=$(echo "${PROSSES_SNIPPRT}" | sed 's/"//g')
	      echo ${PROSSES_SNIPPRT}
              echo curl --header "\"PRIVATE-TOKEN: ${TOKEN}\"" "${PROSSES_SNIPPRT}" --output "${TARGET}"
              curl --header "PRIVATE-TOKEN: ${TOKEN}" "${PROSSES_SNIPPRT}" --output "${TARGET}"
	   else	        
              OUT="graph LR;"$'\n'
	      OUT=$OUT$'\n'
	      OUT=$OUT"${PROCESS} not found in snippeto"$'\n'
	      echo "$OUT" > "${TARGET}"
	   fi		   
   else
     echo "Error tetriving JSON"	   
   fi
else
   echo "Missing arguments"	
fi	
