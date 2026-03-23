ROOT=/home/Git/NAIC
FROM=WP7
TO=ERROR 

PROCC=("WP333")

for TO in ${PROCC[@]}
do
   echo $proc
   cd "${ROOT}/${TO}"
   pwd
   git checkout -b "transfer-from-${FROM}" master
   if [[  $? -eq 0 ]]
   then
      mkdir -p "${ROOT}/${TO}/scripts"
      mkdir -p "${ROOT}/${TO}/documents/templates"
      mkdir -p "${ROOT}/${TO}/documents/_static"
      mkdir -p "${ROOT}/${TO}/documents/meeting-minutes"
      mkdir -p "${ROOT}/${TO}/documents/images/"
      mkdir -p "${ROOT}/${TO}/documents/tutorials"
      touch "${ROOT}/${TO}/documents/images/.gitkeep"
      cp -r ${ROOT}/${FROM}/.gitlab-ci.yml ${ROOT}/${TO}/.gitlab-ci.yml
      cp -r ${ROOT}/${FROM}/scripts/* ${ROOT}/${TO}/scripts/
      cp -r ${ROOT}/${FROM}/documents/tutorials/* ${ROOT}/${TO}/documents/tutorials/
      cp -r ${ROOT}/${FROM}/documents/images/* ${ROOT}/${TO}/documents/images/
      rm "${ROOT}/${TO}/scripts/transfer.sh"
      rm "${ROOT}/${TO}/scripts/test*"
      cp -r ${ROOT}/${FROM}/documents/templates/* ${ROOT}/${TO}/documents/templates/
      cp  ${ROOT}/${FROM}/documents/_static/* ${ROOT}/${TO}/documents/_static/
      cp -r ${ROOT}/${FROM}/requirements.txt ${ROOT}/${TO}/requirements.txt
      sed -i "s/^const mprocess=.*/const mprocess=\"${TO}\"\;/" ${ROOT}/${TO}/documents/_static/getprojectid.js
      
      if [[ "${TO}" == "CONFM" ]]
      then
         echo "Target repo was ${TO} so keeping the CMDB creator" 	 
      else
        echo "Target repo was ${TO}" 	 
        rm ${ROOT}/${TO}/scripts/cmdb*
        rm ${ROOT}/${TO}/documents/templates/cmdb*
      fi
      configfile="${ROOT}/${TO}/documents/conf.py"    
      if [[ ! -f ${configfile} ]]
      then
        cp "${ROOT}/${FROM}/documents/conf.py" "${ROOT}/${TO}/documents/"
        sed -i "s/^project.*/project = \'${TO}\'/" ${configfile}

      fi	   
      make_file_1="${ROOT}/${TO}/make.bat"    
      if [[ ! -f ${make_file_1} ]]
      then
         cp "${ROOT}/${FROM}/make.bat" ${make_file_1}
      fi	   
      
      make_file_2="${ROOT}/${TO}/Makefile"    
      if [[ ! -f ${make_file_2} ]]
      then
         cp "${ROOT}/${FROM}/Makefile" ${make_file_2}
      fi	   
      
      index_file="${ROOT}/${TO}/documents/index.rst"    
      if [[ ! -f ${index_file} ]]
      then
         titlelen=$(echo ${TO}|wc -c)
         underline=$(echo $(head -c ${titlelen} /dev/zero | tr '\0' '='))
         echo "${TO}" > ${index_file}
         echo "${underline}" >> ${index_file}
         
         echo ".. toctree::"  >> ${index_file}
         echo "   :maxdepth: 2" >> ${index_file}
         echo "   :caption: Contents:" >> ${index_file}
         echo "   :hidden:" >> ${index_file}
         echo "   :glob:" >> ${index_file}
         echo " "  >> ${index_file}
         echo "   *" >> ${index_file}
         echo "   ./*/*" >> ${index_file}

      fi
      git status
      git commit -a -m "Sync with ${FROM}" 
      else
	 echo "Branch creation failed for $proc"     
      fi

   
done
 

