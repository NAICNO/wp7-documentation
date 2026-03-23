//Validate javascript    

function encode( input ){
      var encorded_out="Nothing to encord"
      if(!input){
         encorded_out= "#Snippet template not availabel"
      }else{
         //new lines 
         encorded_out=input.replace(/[\r\n]/gm, '\\n');
         // quotations
         encorded_out=encorded_out.replace(/\"/gm, '\\"');
      }
      return encorded_out;
    }
  
function decrypt(token, pass, mprocess, email ,message_box, gtoken_field, updateToken, getTempleteSnippets) {
    var decrypted_token; 
    try {
      if(!! token && !! pass){
           var decrypted = CryptoJS.Rabbit.decrypt(token, pass);
           decrypted_token=decrypted.toString(CryptoJS.enc.Utf8);
           updateToken(decrypted_token, email);
           getTempleteSnippets();
           document.getElementById(message_box).innerHTML="Activated token for the process ".concat(mprocess);
      }else{
        document.getElementById(message_box).innerHTML="Token and/or pass data missing";
      }
    }catch(err) {
       var new_pin='<a href="user_account.html" > Set or reset PIN</a> </span>'
       document.getElementById(message_box).innerHTML="Invalid or expired PIN. ".concat(new_pin);
    }
   return decrypted_token;
}

//Function that handles user validation
//The GitLab token is encrypted and hosted at https://gitlab.sigma2.no/fitsm/auth, behind 2F
//Use the credentials user enters to get the encrypted token and decrypt it, to include in the 
//calls. Once decrypted it the token is handled as a password field
//

function validate(gitlabuser,fitsmpass,mprocess,message_box, gtoken_field, updateToken, getTempleteSnippets){
  const url_postfix = "../_static/users/".concat(gitlabuser, ".json");
  try{ 
     const link = new URL(url_postfix, document.baseURI).href;
     var xhr = new XMLHttpRequest();
     xhr.onreadystatechange = function() {
         if (this.readyState == 4) {
           if (xhr.status == 200 ) {
             authenticator(link, gitlabuser,fitsmpass,mprocess,message_box, gtoken_field, updateToken, getTempleteSnippets);
             console.log("Valid URL ",link);
             return link; 
	   }else if(xhr.status == 404){
             console.log("URL invalid",link);
             document.getElementById(message_box).innerHTML="User not found, please regster a PIN <a href='user_account.html' >here</a>";
	   }
         }
     };  //xhr
     try{     
        xhr.open('GET', link);
        xhr.setRequestHeader('Cache-Control', 'no-cache');
        xhr.send();
     }catch(err){
       console.log(err);
    }
  }catch(err){
     document.getElementById(message_box).innerHTML="User not found, please regster a PIN <a href='user_account.html' >here</a>";
     console.log("URL error ", err.message);	
     return "";	  
  }
}


function authenticator(url, gitlabuser,fitsmpass,mprocess,message_box, gtoken_field, updateToken, getTempleteSnippets){
  if(!! url){
    if (typeof updateToken === "function" && typeof getTempleteSnippets === "function") { 
       document.getElementById(message_box).innerHTML="Validating";
       if(!! gitlabuser ){
  	  gitlabuser=gitlabuser.toLowerCase();
            if(!! url ){
              if(!! mprocess ) {
                 var xhr = new XMLHttpRequest();
                 xhr.onreadystatechange = function() {
                     if (this.readyState == 4) {
                         if (xhr.status == 200 ) {
                            const jasonobject = JSON.parse(xhr.responseText);
                            if(!! jasonobject) {
                               mprocess=mprocess.toUpperCase();
                               const tokens=jasonobject["TOKENS"];
                               if(!! tokens ) {
                                  const token=tokens[mprocess];
                                  if(!! token) {
                                    const email=jasonobject["EMAIL"];
                                    if(! email ) {
                                       console.log("Email not found");
                                    }
                                    decrypt(token, fitsmpass, mprocess,email ,message_box, gtoken_field,updateToken, getTempleteSnippets);
                                 }else{
                                    document.getElementById(message_box).innerHTML="User not in process";
                                 }
                               }else{
                                  document.getElementById(message_box).innerHTML="User not autherised to acess ".concat(mprocess);
                               }
                            }
                         }
                     }
                 };  //xhr
                 xhr.open('GET', url, true);
                 xhr.setRequestHeader('Content-Type', 'application/json');
                 xhr.send();
              }
            }
       }else{
               document.getElementById(message_box).innerHTML="GitLab user name not valid ";
       }
  	
    }else{
      document.getElementById(message_box).innerHTML="Internal error: decrypted_token was not a function";
    }
  }else{
      document.getElementById(message_box).innerHTML="User not found, please regster a PIN <a href='user_account.html' >here</a>";
  }
}


//function handleEvent(e) {
//     console.log("Error ",  "  ", e.type);
//     xhr.addEventListener('loadstart', handleEvent);
//     xhr.addEventListener('load', handleEvent);
//     xhr.addEventListener('loadend', handleEvent);
//     xhr.addEventListener('progress', handleEvent);
//     xhr.addEventListener('error', handleEvent);
//     xhr.addEventListener('abort', handleEvent);
//}


