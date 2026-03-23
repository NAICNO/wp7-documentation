#!/bin/bash
WORKINGDIR=$1
GITLAB_TOKEN="$2"
PROJECT_ID="$3" #$CI_PROJECT_ID
ROBOT_BRANCH=""
DOCUMENTID="$4"
ISSUECREATEID="$5"
PROJECTNAME="$6"
PROJECTURL="$7"
#TODO This path is invalid
LOG_FILE="${WORKINGDIR}/build/html/script.log"
#./scripts/hedgdoc-sync.bash: line 33: ./build/html/script.log: No such file or director
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
MERGE_ID="${12}"

CI_PROJECT_ID=${PROJECT_ID}
V_ID="ID"
V_ID_URL="ID_URL"
V_dependent="DEPENDEDNT"
V_CI_Title="CI-Title"
CANNOTMERGE=""

PLUGIN_SNIPPET="PLUGIN_SNIPPET"

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
     logme $(echo "$LINENO $CURL_URL")
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

function getpredefinedlables {
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

function synchedgedoc {
   if [ ! -z "$HEDGEDOCSYNCFILE" ] #if1
   then
     FOLDER_TO_CHECK="documents/meeting-minutes"	   
     logme $(echo "$LINENO find $FOLDER_TO_CHECK -type f -name \"*.md.tmp\" -not -ipath \"*/templates/*\" -exec grep -l $HEDGEDOCSYNCFILE {} \;")	   
     FILELIST=$(find "${FOLDER_TO_CHECK}" -type f -name "*.md.tmp" -not -ipath "*/templates/*" -exec grep -l "$HEDGEDOCSYNCFILE" {} \;)
     if [ ! -z "$FILELIST" ] #if2
     then
        for cfile in $FILELIST #for1
        do
          logme $(echo "$LINENO Syncing hedgedoc $cfile")
	  local hedgedoc_id=$(grep $HEDGEDOCSYNCFILE $cfile | awk -F "/" '{print $NF}')
	  local hedgedoc_url=$(grep $HEDGEDOCSYNCFILE $cfile |  cut -d '=' -f 2)
	  local issue_id=$(grep $UPDATEISSUE $cfile |  cut -d '=' -f 2)
	  local HEDGE_result=$(eval HEDGEDOC_SERVER="https://md.sigma2.no/" bash $HEDGEDOCDBIN export --md  $hedgedoc_id $cfile)
	  echo $HEDGE_result
	  new_cfile=$(echo "${cfile}" | sed "s/\(.*\).tmp/\1/")
	  # assign id
          git add "${cfile}"
          git commit -m "Imported from $hedgedoc_url"
	  
          logme $(echo "$LINENO moving ${cfile} to ${new_cfile}")
	  if [[ ! -f "${new_cfile}" ]]; 
	  then
	     git mv "${cfile}" "${new_cfile}"
          else
            dupfixer="-dup-"$(date +%s)".md"		  
	    new_cfile=$(echo  "${new_cfile}" | sed s/.md/${dupfixer}/)  		  
	    git mv "${cfile}" "${new_cfile}"
	  fi
          git commit -m "Renaming tmp file ${cfile} Closes #${issue_id}"
          #local HEDGE_clean=$(eval HEDGEDOC_SERVER="https://md.sigma2.no/" bash $HEDGEDOCDBIN delete  $hedgedoc_id)
	  #local HEDGE_clean=$(eval curl -X POST -H  "Content-Type: application/json" -d '{"content": "Document archived"}' https://md.sigma2.no/api/v1/documents/$hedgedoc_id)
	  #local HEDGE_clean=$(eval curl --silent https://md.sigma2.no/me)
          #logme $(echo "$LINENO cleaning hedgdoc $hedgedoc_id result is $HEDGE_clean")
	  #createindex_files "documents/meeting-minutes"
  	  echo  "--request POST" "issues" "/${issue_id}/notes?body=Step%205%20of%205%20HedgeDoc%20synchronized%20Started%id%assign" 
  	  RESULT=$(createfromapi "--request POST" "issues" "/${issue_id}/notes?body=Step%205%20of%205%20HedgeDoc%20synchronized%2E%20Started%20id%20assignment%20started" "$LINENO")
          logme $(echo "$LINENO issue update result  $RESULT ID assigning started for ${new_cfile}")
  	  RESULT=$(createfromapi "--request POST" "issues" "/${issue_id}/notes?body=Archiving%20complete%2E%20When%20merge%20request%20accepted%20document%20will%20be%20deployed" "$LINENO")
	  id_assigner "${new_cfile}" ${DOCUMENTID} ${DOCUMENTID_URL}
	  run_plugins "${new_cfile}" "${PLUGIN_SNIPPET}"
	  #RESULT=$(createfromapi "--request POST" "issues" "/${issue_id}?state_event=close" "$LINENO")
        done #for 1 end	
       createindex_files "${FOLDER_TO_CHECK}"
     fi #if2 end    
   fi #if1 end	   
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


function run_plugins(){
  logme $(echo "$LINENO calling id_assigner with ${1} and ${2} ")
  if [ "$#" -ge 2 ] # if in
  then
     cfile=$(readlink -f ${1})
     PLUGIN_SNIPPET_URLS=${2}
     local plugin_result=$(grep ${PLUGIN_SNIPPET_URLS} $cfile)
     for PLUGIN in $(echo "${plugin_result}")
     do
         ORIG_DIR=$(pwd)
	 FILE_LOC=$(dirname "$cfile")
         cd "${FILE_LOC}"
	 tmp_file="plugin_exec.tmp"
	 IFS='##' read -r -a arguments <<< "${PLUGIN}"
	 if [[ "${#arguments[@]}" -ge 5  ]]
         then
            local plugin_snippet_id="${arguments[4]}"
	    logme $(echo "$LINENO curl --header \"PRIVATE-TOKEN: ${GITLAB_TOKEN}\" \"${CI_API_V4_URL}/snippets/${plugin_snippet_id}/raw\"")
            curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" "${CI_API_V4_URL}/snippets/${plugin_snippet_id}/raw" -o "${tmp_file}"
	    TEMP_PLUGIN_RESULTS="plugin_out.tmp"
	    TEMP_PLUGIN_INPUT="plugin_in.tmp"
	    TEMP_PLUGIN_ERROR="plugin_err.tmp"
	    RESULT="ERROR"
            if [[ "${#arguments[@]}" -ge 7 ]]
            then
	      echo "${tmp_file}" "${TEMP_PLUGIN_RESULTS}" "${TEMP_PLUGIN_INPUT}" "${GITLAB_TOKEN}" "${arguments[6]}"        
	      RESULT=$(bash "${tmp_file}" "${TEMP_PLUGIN_RESULTS}" "${TEMP_PLUGIN_INPUT}" "${GITLAB_TOKEN}" "${arguments[6]}" 2>${TEMP_PLUGIN_ERROR} )
            else
	      RESULT=$(bash "${tmp_file}" "${TEMP_PLUGIN_RESULTS}" "${TEMP_PLUGIN_INPUT}" "${GITLAB_TOKEN}" 2>${TEMP_PLUGIN_ERROR} )
            fi		    
	    echo "¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤"
	    if [[ -s "${TEMP_PLUGIN_ERROR}" ]]
            then
               cat ${TEMP_PLUGIN_ERROR}
            fi		    
	    echo "¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤"
            sed -i "/${PLUGIN}/r ${TEMP_PLUGIN_RESULTS}" $cfile;	 
	    sed -i "/${PLUGIN}/d" $cfile
	    cd "${ORIG_DIR}"
            git add $cfile
	    git commit -m "Plugin executed and result included"
         fi		 
     done
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
                  git commit -m "Created inddex file $cdir_path/index.rst"
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

logme $(echo "$LINENO Starting for $HEDGEDOCSYNCFILE")	
cd $WORKINGDIR
if [ ! -z "$HEDGEDOCSYNCFILE" ] #if1
then
     synchedgedoc
fi
mergeit

