#!/bin/bash
WORKINGDIR=$1
GITLAB_TOKEN="$2"
PROJECT_ID="$3" #$CI_PROJECT_ID
ROBOT_BRANCH=""
DOCUMENTID="$4"
ISSUECREATEID="$5"
PROJECTNAME="$6"
PROJECTURL="$7"
LOG_FILE="./build/html/script.log"
LABEL_SNIPET_ID="$8"
TEMPLATEID="$9"
LABEL_MAP_TEXT=""
HEDGEDOCSYNCFILE="${10}"
HEDGEDOCDBIN="./scripts/bin/hedgedoc" #This is hardcoded to executable HEDGEDOCDBIN
UPDATEISSUE="ISSUEID"
INDEX_FILE_SNIPPET="23"
CIID="##CIID##"
CIID_URL="##CIID_URL##"
DOCUMENTID_URL="##DOCUMENTID_URL##"
AUTHOR="${11}"

CI_PROJECT_ID=${PROJECT_ID}
V_ID="ID"
V_ID_URL="ID_URL"
V_dependent="DEPENDEDNT"
V_CI_Title="CI-Title"
CANNOTMERGE=""


function logme {
   echo "$@" >> $LOG_FILE
}

function decode() {
        : "${*//+/ }";
        echo -e "${_//%/\\x}";
}

# Local git configurations for Robot
function gitconfig {
   if [ -z ${ROBOT_BRANCH} ]
   then
     ROBOT_BRANCH="${CI_COMMIT_REF_NAME}" #"FitSM-Robot"
     logme $(echo "$LINENO   ROBOT_BRANCH is $ROBOT_BRANCH")
     git config --local user.email "FitSM_robot@NRIS"
     git config --local user.name "FitSM Robot"
     git config --local pull.ff only
     git merge --abort &>/dev/null
     rm -fr ".git/rebase-merge" &>/dev/null
     if [[ ! -z $(git remote show | grep ci-endpoint) ]]
     then
          git remote remove ci-endpoint
     fi
     PROJECTURL_PREF=$(echo ${PROJECTURL} | awk -F "//" '{print $2}')
     logme $(echo "$LINENO   https://${PROJECTNAME}:${GITLAB_TOKEN}@${PROJECTURL_PREF}.git")

     git remote add ci-endpoint "https://${PROJECTNAME}:${GITLAB_TOKEN}@${PROJECTURL_PREF}.git"
     logme $(echo "$LINENO current branch ${CI_COMMIT_REF_NAME}")
     logme $(echo "$LINENO git ls-remote --heads ci-endpoint | grep \"refs/heads/${ROBOT_BRANCH}\" ")
     if [[ -z $( git ls-remote --heads ci-endpoint | grep "refs/heads/${ROBOT_BRANCH}" ) ]]
     then
         logme $(echo "$LINENO remote branch $ROBOT_BRANCH  not found")
         git fetch ci-endpoint master --depth=50
         git checkout -b $ROBOT_BRANCH ci-endpoint/master
     else
         logme $(echo "$LINENO found remote branch $ROBOT_BRANCH ")
         logme $(echo "$LINENO curent status" $(git status))
         git branch | grep "${ROBOT_BRANCH}"
         if [[ ! -z $( git branch | grep "${ROBOT_BRANCH}") ]]
         then
             git branch -D $ROBOT_BRANCH
         else
           logme $(echo "$LINENO branch not found $ROBOT_BRANCH ")
         fi
         git fetch ci-endpoint $ROBOT_BRANCH
         git checkout -b $ROBOT_BRANCH ci-endpoint/$ROBOT_BRANCH
         git fetch ci-endpoint master
         git merge ci-endpoint/master --allow-unrelated-histories -m "Syncing with remote" || CANNOTMERGE="TRUE"
     fi

   fi
}


function createfromapi {
  local API_RESULT=""
  if [ "$#" -ge 3 ]
  then
     local CURLARG=$1	  
     local TYPE=$2
     local ARGUMENTS=$3
     CURL_URL="curl ${CURLARG} --header \"PRIVATE-TOKEN: ${GITLAB_TOKEN}\" \"${CI_API_V4_URL}/projects/${PROJECT_ID}/${TYPE}${ARGUMENTS}\""
     API_RESULT=$(eval $CURL_URL)
     if [[ "${TYPE}" == *"merge_requests"* ]] && [[ "${CURLARG}" == *"POST"* ]]
     then
        ANS=$(echo ${API_RESULT} | jq  '.message[0]' | awk -F "!" '{print $NF}'  | awk -F "\"" '{print $1}')
	if [[ "$ANS"  =~ ^[0-9]+$ ]]
       	then 
           API_RESULT="{\"iid\":${ANS}}"	   	
	fi
     fi
  fi 
  echo "$API_RESULT"
}

function getpredefinedlables() {
   logme $(echo "$LINENO getpredefinedlables $1" )
   M_LABEL=""	
   if [[ ! -z "$1" ]]
   then
     local LABEL_A=("$@")
     IFS=$'\n'
     for M_KEY in "${LABEL_A[@]}"
     do
      M_KEY=${M_KEY^^}
      if [[ -z "$LABEL_MAP_TEXT" ]]
      then	   
         LABEL_MAP_TEXT="NA"
         logme $(echo "$LINENO curl --header \"PRIVATE-TOKEN: ${GITLAB_TOKEN}\" \"${CI_API_V4_URL}/snippets/${LABEL_SNIPET_ID}/raw\"")
         LABEL_MAP_TEXT=$(curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${CI_API_V4_URL}/snippets/${LABEL_SNIPET_ID}/raw")
      fi
      #logme $(echo "$LINENO $M_KEY LABEL_MAP_TEXT= ${LABEL_MAP_TEXT} M_KEY-> $M_KEY")
      if $(echo $LABEL_MAP_TEXT | jq --arg M_KEY "$M_KEY" '.label.mapings | has($M_KEY)')
      then
	      if [[ ! -z "$M_LABEL" ]] #if3
              then
                 M_LABEL+=","
                 M_LABEL+=$(echo $LABEL_MAP_TEXT | jq --arg M_KEY "$M_KEY" ".label.mapings.$M_KEY | .[].value" | sort | uniq | grep -v -e "^$" | tr '\n' ','| tr '\t' ' ' | tr ' ' '_')  
      	         logme $(echo "$LINENO  found $M_LABEL" )
              fi #End IF3

      else 
              logme $(echo "$LINENO  Not :found $M_KEY" )
      fi 
     done
   fi

   if [[ -z "$M_LABEL" ]] #if3
   then
      M_LABEL="Document"
   fi #End IF3
   logme $(echo "$LINENO ---------------  found $M_LABEL  ---------------------" )
   echo $M_LABEL

}

function id_assigner {
  logme $(echo "$LINENO calling id_assigner with ${1} and ${2} ")
  if [ "$#" -ge 2 ] # if in
  then
     cfile=${1}
     SED_ID=${2}
     SED_URL=${3}

     IFS='-' read -r -a FILENAME_A <<< $(echo $(basename $cfile) | sed "s/.md//g")
     M_LABEL="";
     IFS='-' read -r -a FILENAME_A <<< $(echo $(basename $cfile) | sed "s/.md//g")
     M_LABEL="";
     getpredefinedlables "${FILENAME_A[@]}" # Sets M_LABEL
     logme $(echo "$LINENO Lables $(basename $cfile) $M_LABEL ")
     RESULT=$(createfromapi "--request POST" "issues" "?title=Document-control-$(basename $cfile)&labels=${M_LABEL}" "$LINENO")
     logme $(echo "$LINENO $RESULT ")
     if [ ! -z "$RESULT" ] #if3
     then
        ISSUE_ID=$(echo $RESULT | jq  '.iid')
        if [ ! -z "$ISSUE_ID" ] #if1
        then
          ISSUE_URL=${CI_PROJECT_URL}"/-/issues/"${ISSUE_ID}
          ISSUE_URL=$(echo $ISSUE_URL | sed 's#/#\\/#g')
          NEW_DOC_ID="${ISSUE_ID}"
          if [[ ! -z ${ID_PREFIX} ]]
          then
             NEW_DOC_ID="${ID_PREFIX}-${ISSUE_ID}"
          fi
          sed -i "s/$SED_ID/$NEW_DOC_ID/" $cfile;
          if [[ ! -z ${SED_URL} ]]
          then
             sed -i "s/$SED_URL/$ISSUE_URL/" $cfile;
          fi
          git add $cfile
          git commit -m "Assigning ID Closes #$ISSUE_ID"
        else
          logme $(echo "$LINENO issueid null")
        fi #end if1 is issue null             
     else
          logme $(echo "$LINENO issue creation failed")
     fi # end if3 

  else
    logme $(echo "$LINENO ERROR id_assigner called with less arguments")
  fi #end if check function arguments

  logme $(echo "$LINENO Finished ${GREP_LABEL}")
} #function end 



function mergeit() {
     if [[ ! -z $(git diff ci-endpoint/master --stat) ]] #if 1
     then
        logme $(echo "$LINENO pushed new changes to the branch already merging ")
        git pull ci-endpoint $ROBOT_BRANCH
        git push ci-endpoint $ROBOT_BRANCH:$ROBOT_BRANCH
        RESULT=$(createfromapi "--request PUT" "merge_requests" "/${MERGE_ID}/?title=Hedgedoc-sync-completed")
        logme $(echo "$LINENO Title set ")
     else
        logme $(echo "$LINENO no changes to push")
     fi
}

if [ -d "$WORKINGDIR" ]
then
  cd $WORKINGDIR
else
  exit 1
fi

cd $WORKINGDIR
logme $(echo "$LINENO  Current directory $WORKINGDIR, initiate gitconfig")	
gitconfig

# Find all rst and markdown files, exept ones in template folder
logme $(echo "$LINENO Starting for $DOCUMENTID  ")	
if [ ! -z "$DOCUMENTID" ] #if1
then
    FILELIST=$(find documents -type f -name "*.md" -not -ipath "*/templates/*" -exec grep -l -e "${DOCUMENTID}" -e "${DOCUMENTID_URL}" {} \;)
    logme $(echo "$LINENO  number of files to assign id ${#FILELIST[@]}")	
    if [ ! -z "$FILELIST" ] #if filelist
    then
      IFS=$'\n'
      for cfile in $FILELIST #for1
      do	      
          id_assigner "${cfile}" "${DOCUMENTID}" "${DOCUMENTID_URL}"
      done
    fi
else
   logme $(echo "$LINENO  $DOCUMENTID not found *****")	
fi #if 1 end

mergeit

