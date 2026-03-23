#!/bin/bash
WORKINGDIR=$1
GITLAB_TOKEN="$2"
PROJECT_ID="$3" #$CI_PROJECT_ID
ROBOT_BRANCH="fitsmrobot-"$(date  "+%d%m%H%M%S")
DOCUMENTID="$4"
ISSUECREATEID="$5"
PROJECTNAME="$6"
PROJECTURL="$7"
LABELMAPURL="$8"
LOG_FILE="./build/html/script.log"
PREDEF_LABELS="Policy Roles Scope"
declare -A  LABEL_MAP=( ["Policy"]="Policy"
                      ["Roles"]="Roles"
                      ["Scope"]="Scope"
                      ["Rec"]="Record"
                      ["SRM"]="SRM"
                      ["SPM"]="SPM"
		      ["NOTFOUND"]="Document"
                      )
PREDEF_LABELS="${!LABEL_MAP[@]}"
LABEL_SNIPET_ID="2"
LABEL_MAP_TEXT=""

function logme {
   echo "$@" >> $LOG_FILE
}

# Local git configurations for Robot
function gitconfig {
   git config --local user.email "FitSM_robot@NRIS"
   git config --local user.name "FitSM Robot"
   if [[ ! -z $(git remote show | grep ci-endpoint) ]]
   then 
	   git remote remove ci-endpoint
   fi
   echo "Todo make this secure" #git remote add ci-endpoint https://gitlab-ci-token:${CI_JOB_TOKEN}@gitlab.sigma2.no/
   PROJECTURL_PREF=$(echo ${PROJECTURL} | awk -F "//" '{print $2}')
   logme $(echo "$LINENO   https://${PROJECTNAME}:${GITLAB_TOKEN}@${PROJECTURL_PREF}.git")

   git remote add ci-endpoint  "https://${PROJECTNAME}:${GITLAB_TOKEN}@${PROJECTURL_PREF}.git"
   git fetch ci-endpoint master;   
   
   if [[ -z $(git branch --list $ROBOT_BRANCH) ]]
   then 
	   git checkout -b $ROBOT_BRANCH ci-endpoint/master
   else 
	   git checkout $ROBOT_BRANCH
   fi
}


function getfromapi {
  RESULT="NA"
  if [ "$#" -ge 3 ]
  then
   local TYPE=$1
   local IID=$2
   local ARGUMENTS=$3
   RESULT=$(curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${CI_API_V4_URL}/${PROJECT_ID}/${TYPE}/${IID}${ARGUMENTS}")
  fi
}

function createfromapi {
  RESULT="NA"
  if [ "$#" -ge 3 ]
  then
   local CURLARG=$1	  
   local TYPE=$2
   local ARGUMENTS=$3
   logme $(echo "$LINENO curl ${CURLARG} --header \"PRIVATE-TOKEN: ${GITLAB_TOKEN}\" \"${CI_API_V4_URL}/projects/${PROJECT_ID}/${TYPE}?${ARGUMENTS}\"")
   RESULT=$(curl ${CURLARG} --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${CI_API_V4_URL}/projects/${PROJECT_ID}/${TYPE}${ARGUMENTS}")
  fi
}

#Fabricate lables from filenames
#function processlabels2() {
#   local LABELS=""
#   local LABEL_A=("$@")
#   if [[ ! -z $1 ]] #if1
#   then
#       for L in "${LABEL_A[@]}"
#       do
#         MATCH_KEY="$(echo $PREDEF_LABELS | grep -w -i -o $L)"
#         if [[  ! -z "$MATCH_KEY"  ]] #If2 
#         then
#           if [[ ! -z "$LABELS" ]] #if3
#           then
#                LABELS+=","
#           fi #End IF3 
#           LABELS+="${LABEL_MAP[$MATCH_KEY]}"
#         fi #End if2
#       done   
#   fi #End if1
#   if [[ -z "$LABELS" ]] #if1
#   then
#      LABELS="${LABEL_MAP[NOTFOUND]}"
#   fi
#   echo "$LABELS"
#}

function getpredefinedlables() {
   local M_LABLE=""	
   if [[ ! -z "$1" ]]
   then
     local LABEL_A=("$@")
     for M_KEY in "${LABEL_A[@]}"
     do
      M_KEY=${M_KEY^^}
      if [[ -z "$LABEL_MAP_TEXT" ]]
      then	   
         LABEL_MAP_TEXT="NA"
         LABEL_MAP_TEXT=$(curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${CI_API_V4_URL}/snippets/${LABEL_SNIPET_ID}/raw")
      fi
      logme $(echo "$LINENO $M_KEY LABEL_MAP_TEXT= ${LABEL_MAP_TEXT} M_KEY-> $M_KEY")
      echo "echo \$LABEL_MAP_TEXT | jq -r --arg M_KEY \"$M_KEY\" '.label.mapings | has($M_KEY)'"
      if $(echo $LABEL_MAP_TEXT | jq -r --arg M_KEY "$M_KEY" '.label.mapings | has($M_KEY)')
      then
	      if [[ ! -z "$M_LABEL" ]] #if3
              then
                 M_LABEL+=","
              fi #End IF3

              M_LABLE+=$(echo $LABEL_MAP_TEXT | jq -r --arg M_KEY "$M_KEY" ".label.mapings.$M_KEY | .[].value" | sort | uniq | tr '\n' ',')  
      	      logme $(echo "$LINENO  found $M_LABLE" )
      else 
              logme $(echo "$LINENO  Not :found" )
      fi 
     done
   fi

   if [[ ! -z "$M_LABEL" ]] #if3
   then
      M_LABEL="Document"
   fi #End IF3
   echo $M_LABLE

}


logme $(echo "$LINENO   WORKINGDIR = $WORKINGDIR")

if [ -d "$WORKINGDIR" ]
then
  cd $WORKINGDIR
else
  exit 1
fi


# Find all rst and markdown files, exept ones in template folder
if [ ! -z "$DOCUMENTID" ] #if1
then	
   FILELIST=$(find . -type f \( -name "*.rst" -o -name "*.md" \) -not -path "./templates/*" -exec grep -l "$DOCUMENTID" {} \;)
   
   logme $(echo "$LINENO Set Document-id for  $FILELIST")
   
   if [ ! -z "$FILELIST" ] #if2
   then
      gitconfig #Call function
      for cfile in $FILELIST #for1
      do
        # Git the file name to be used to fabricate labels	   
        IFS='-' read -r -a FILENAME_A <<< $(echo $(basename $cfile) | sed "s/.md//g")
        
        #Fix document ID
	#local LABELS="Document"
        #Create lables
	LABELS=$(getpredefinedlables "${FILENAME_A[@]}")
        logme $(echo "$LINENO Lables $(basename $cfile)  $LABELS")
        #Create a new issue
        createfromapi "--request POST" "issues" "?title=Document-control-$(basename $cfile)&labels=${LABELS}" 
        ISSUE_ID=$(echo $RESULT | jq  -r '.iid')
        ISSUE_URL=${CI_PROJECT_URL}"/-/issues/"${ISSUE_ID}
	NEW_DOC_ID="[${PROJECTNAME}-${ISSUE_ID}](${ISSUE_URL})"
        NEW_DOC_ID_ENC=$(echo $NEW_DOC_ID | sed 's#/#\\/#g')
        sed -i "s/$DOCUMENTID/$NEW_DOC_ID_ENC/" $cfile;
        git add $cfile
        git commit -m "Assigning ID Closes #$ISSUE_ID"
        COMITHASH=$(git log --oneline --pretty=format:"%h"  -n 1)
        
        #Connect the issue to commit
        createfromapi "--request POST" "issues" "/${ISSUE_ID}/notes?body=${COMITHASH}"
        REMOTE_BRANCH="FITSM-ROBOT-"$ISSUE_ID 
        echo "8 push command used git push ci-endpoint $ROBOT_BRANCH:$REMOTE_BRANCH"
        git push ci-endpoint $ROBOT_BRANCH:$REMOTE_BRANCH 
   
        #Create a merge request
        createfromapi "--request POST" "merge_requests" "?target_branch=master&source_branch=${REMOTE_BRANCH}&title=Document-control-${cfile}"
   
        MERG_ID=$(echo $RESULT | jq  -r '.iid')
        
        #set autoclose issue when merge accepted
        createfromapi "--request POST" "merge_requests" "/${MERG_ID}/notes?body=Closes%20%5C%23${ISSUE_ID}"
      done
   fi #if 2 end   
else
   logme $(echo "$LINENO  $DOCUMENTID not found *****")	
fi #if 1 end

logme $(echo "$LINENO Issue creator starting")

#Fix sourceid requests
function createissue {
     logme $(echo "$LINENO Createissue")
     FOUND=0
     FILELIST=$(find . -type f \( -name "*.rst" -o -name "*.md" \) -not -path "./templates/*" -exec grep -l "$ISSUECREATEID" {} \;)
     logme $(echo "$LINENO file list for $ISSUECREATEID $FILELIST")
    
     if [ ! -z "$FILELIST" ] #if1
     then
       logme $(echo "$LINENO $FILELIST")
       FOUND=1	    
       gitconfig #Call function
       for cfile in $FILELIST #for1
       do
          IFS='-' read -r -a FILENAME_A <<< $(echo $(basename $cfile) | sed "s/.md//g")	    
          #Create a new issue
          LABELS=$(getpredefinedlables "${FILENAME_A[@]}")
          createfromapi "--request POST" "issues" "?title=Document-control-$(basename $cfile)&labels=${LABELS}"
          ISSUE_ID=$(echo $RESULT | jq  -r '.iid')
          logme $(echo "$LINENO Issue id= $ISSUE_ID")
  	  ISSUE_URL=${CI_PROJECT_URL}"/-/issues/"${ISSUE_ID}
          NEW_DOC_ID="[${PROJECTNAME}-${ISSUE_ID}](${ISSUE_URL})"
          NEW_DOC_ID_ENC=$(echo $NEW_DOC_ID | sed 's#/#\\/#g')
          sed -i "0,/$ISSUECREATEID/s//$NEW_DOC_ID_ENC/" $cfile
          git add $cfile 
          git commit -m "Assigning Issue id #$ISSUE_ID" 
          COMITHASH=$(git log --oneline --pretty=format:"%h"  -n 1)
          #Connect the issue to commit
          createfromapi "--request POST" "issues" "/${ISSUE_ID}/notes?body=${COMITHASH}"
          REMOTE_BRANCH="FITSM-ROBOT-"$ISSUE_ID 
          logme $(echo "$LINENO commit hash ${COMITHASH}")
          git push ci-endpoint $ROBOT_BRANCH:$REMOTE_BRANCH
          createfromapi "--request POST" "merge_requests" "?target_branch=master&source_branch=${REMOTE_BRANCH}&title=Issue-ID-association-${cfile}"
 
          #set autoclose issue when merge accepted
          MERG_ID=$(echo $RESULT | jq  -r '.iid')
          createfromapi "--request POST" "merge_requests" "/${MERG_ID}/notes?body=Issue%20%23${ISSUE_ID}%20Assign%20issue%20ID"
       done
     fi #if1 end
} #createissue function ends
 
logme $(echo "$LINENO Issue creator End, issue started")
 
if [ ! -z "$ISSUECREATEID" ] #if1
then
    #Loop, limit max of 10 ids in one assignment 
    COUNT=10
    FOUND=1
    while [ "$COUNT" -gt "0" ] && [ "$FOUND" -eq "1" ]
    do
      logme $(echo "$LINENO $COUNT found=$FOUND")
      createissue  
      let COUNT=$COUNT-1
      sleep 1
    done #End while
fi #End if1
# 

