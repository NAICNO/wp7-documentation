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
     else
         logme $(echo "$LINENO found remote branch $ROBOT_BRANCH ")
         git fetch ci-endpoint $ROBOT_BRANCH
         git checkout $ROBOT_BRANCH 
         git fetch ci-endpoint master
         git merge ci-endpoint/master --allow-unrelated-histories -m "Syncing with remote" || CANNOTMERGE="TRUE" 
     fi

   fi  
}


function createindex_files() {
  if [ "$#" -ge 1 ] # if0
  then
     logme $(echo "$LINENO $1 createindex_files started for ${1}" )
     DIR_PREFIX="${1}" #documents/meeting-minutes"
     DIRECTORYIST=$(find ${DIR_PREFIX} -type d -not -name "_*" -not -name "* *")
     if [ ! -z "$DIRECTORYIST" ] #if1
     then
           for cdir_path in $DIRECTORYIST #for1
           do
               CHECKINDES=$(ls ${cdir_path}/index.rst 2>/dev/null)
               if [ -z "$CHECKINDES" ] #if2   
               then
                  cdir=$(echo $cdir_path  | awk -F "/" '{print $NF}')
                  titlelen=$(echo $cdir | wc -c)
                  let titlelen=(titlelen-1)
                  title=$(head -c ${titlelen} /dev/zero | tr '\0' '=')
                  echo  $cdir > $cdir_path/index.rst
                  echo  $title >> $cdir_path/index.rst
                  echo  "" >> $cdir_path/index.rst
                  echo  ".. toctree::" >> $cdir_path/index.rst
                  echo  "   :titlesonly:" >> $cdir_path/index.rst
                  echo  "   :glob:" >> $cdir_path/index.rst
                  echo  "   :caption: Contents:" >> $cdir_path/index.rst
                  echo  "" >> $cdir_path/index.rst
                  echo  "   *" >> $cdir_path/index.rst
                  git add $cdir_path/index.rst
                  git commit -m "Created index file $cdir_path/index.rst"
                  if (! $(grep -q "$cdir/index.rst" $cdir_path/../index.rst) )
                  then
                      echo  "   $cdir/index.rst" >> $cdir_path/../index.rst
                      git add  $cdir_path/../index.rst
                      git commit -m "Updated the new index file in parent index"
                  fi
               fi #edn if2              
           done #end for 1
     fi  # end if1 
   fi # end if0
} #eateindex_files


function mergeit() {
     if [[ ! -z $(git diff ci-endpoint/master --stat) ]] #if 1
     then
        git pull ci-endpoint $ROBOT_BRANCH
        git push ci-endpoint $ROBOT_BRANCH
        logme $(echo "$LINENO pushed new changes to the branch already merging ")
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

