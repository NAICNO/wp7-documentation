#!/bin/bash

   INDEX_FILE=$(echo "Some text \n new line")
   API_RESULT="Some text \n new line"
   DIR_PREFIX="documents/meeting-minutes"
   DIRECTORYIST=$(find ${DIR_PREFIX} -type d -not -name "_*" -not -name "* *")
   if [ ! -z "$DIRECTORYIST" ] #if1
   then
      for cdir_path in $DIRECTORYIST #for1
      do 
	  echo " 1 ${cdir_path}"
          CHECKINDES=$(ls ${cdir_path}/index.rst 2>/dev/null)
          if [ -z "$CHECKINDES" ] #if2   
          then
             echo find  ${cdir_path} -maxdepth 1 -type f  -name *.md -o -name *.rst	  
             CHECKIFEMTY=$(find  ${cdir_path} -maxdepth 1 -type f  -name "*.md" -o -name "*.rst") 
             if [ -z "$CHECKIFEMTY" ] #if 3    
             then
               echo "should create in ${cdir_path}  CHECKIFEMTY is  $CHECKIFEMTY"
	       #echo "# ${cdir_path}" > ${cdir_path}/list.md
             fi #end if3		  
  
             cdir=$(echo $cdir_path  | awk -F "/" '{print $NF}')  
	     titlelen=$(echo $cdir_path | wc -c)
	     let titlelen=(titlelen-1)
	     title=$(head -c ${titlelen} /dev/zero | tr '\0' '=')             
	     
             echo  $cdir_path > $cdir_path/index.rst        
             echo  $title >> $cdir_path/index.rst
             echo  "" >> $cdir_path/index.rst
             echo  ".. toctree::" >> $cdir_path/index.rst           
             echo  "   :titlesonly:" >> $cdir_path/index.rst           
             echo  "   :glob:" >> $cdir_path/index.rst           
             echo  "   :caption: Contents:" >> $cdir_path/index.rst           
             echo  "" >> $cdir_path/index.rst           
             echo  "   *" >> $cdir_path/index.rst          
	     if (! $(grep -q "$cdir/index.rst" $cdir_path/../index.rst) )
	     then
	         echo  "   $cdir/index.rst" >> $cdir_path/../index.rst
	     fi	     
          fi #edn if2              
      done #end for 1
   fi  # end if1 

