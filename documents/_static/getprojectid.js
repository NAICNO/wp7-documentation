//Get the Gitlab project id
const mprocess="WP7";

const project_id_map = new Map();
project_id_map.set('SMS','271');
project_id_map.set('SPM','391');
project_id_map.set('SLM','308');
project_id_map.set('SRM','378');
project_id_map.set('CAPM','380');
project_id_map.set('CHM','276');
project_id_map.set('CONFM','523');
project_id_map.set('ISRM','280');
project_id_map.set('PM','319');
project_id_map.set('CSI','318');
project_id_map.set('RDM','317');
project_id_map.set('SUPPM','315');
project_id_map.set('CRM','314');
project_id_map.set('SACM','311');
project_id_map.set('ISM','313');


const project_name_map = new Map();
project_name_map.set('SMS' ,'Service management System');
project_name_map.set('SPM'   ,'Service Portfolio Management');
project_name_map.set('SLM'   ,'Service Level Management');
project_name_map.set('SRM'   ,'Service Reporting');
project_name_map.set('SACM'  ,'Service Availability and Continuity Management(SACM-000)');
project_name_map.set('CAPM'  ,'Capacity Management');
project_name_map.set('IM'    ,'Information Security Management');
project_name_map.set('CRM'   ,'Customer Relationship Management');
project_name_map.set('SUPPM' ,'Supplier Relationship Management');
project_name_map.set('ISRM'  ,'Incident and Service Request Management');
project_name_map.set('PM'    ,'Problem Management');
project_name_map.set('CONFM' ,'Configuration Management');
project_name_map.set('CHM'   ,'Change Management');
project_name_map.set('RDM'   ,'Release and Deployment Management');
project_name_map.set('CSI'   ,'Continual Service Improvement');


const template_snippet_map = new Map();
template_snippet_map.set('SMS','https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('SPM'  ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('SLM'  ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('SRM'  ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('CAPM' ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('CHM'  ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('CONFM','https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('ISRM' ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('PM'   ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('CSI'  ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('RDM'  ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('SUPPM','https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('CRM'  ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('SACM' ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');
template_snippet_map.set('ISM'  ,'https://gitlab.sigma2.no/api/v4/projects/378/snippets/25/raw');


function getprojectid(or_mprocess){
  if( !! or_mprocess){
    const cpid= project_id_map.get(or_mprocess.toUpperCase());
    if( !! cpid){
       return cpid;
    }  else{
       return  project_id_map.get('SRM');
    }
  }else{
     return  project_id_map.get('SRM');
  }
}


function getprojectid(){
    const cpid= project_id_map.get(mprocess.toUpperCase());
    if( !! cpid){
       return cpid;
    }  else{
       return  project_id_map.get('SRM');
    }
}

function getprojectname(){
    return mprocess.toUpperCase();
}


function getDropdownItem(){
    const cpid= project_id_map.get(mprocess.toUpperCase());
    const option = document.createElement("option");

    if( !! cpid){
       option.text=project_name_map.get(mprocess.toUpperCase());
       option.value=mprocess.toUpperCase(); 
    }  else{
       option.text="Process not found";
       option.value="NA";
    }
    return option;
}



function get_temaplate_snippet_list(){
    const snippet_url= template_snippet_map.get(mprocess.toUpperCase());
    if( !! snippet_url){
       return snippet_url;
    }  else{
       return  project_id_map.get('SRM');
    }
}
