const user_details_map = new Map();
 
user_details_map.set("solomod","Solomon Debru");  
user_details_map.set("har010","Saruar Alam");  
user_details_map.set("mortele","Morten Ledum");  
user_details_map.set("TopRichard","Richard Topouchian");  
user_details_map.set("atvi","Adrian Tvilde Evensen");  
user_details_map.set("mamik","Martin Mikkelsen");  
user_details_map.set("benteb","Bente S. Barge");  
user_details_map.set("bjorgve","Magnar Bjorgve");  
user_details_map.set("heggeli","Erik Heggeli");  
user_details_map.set("emo104","Emmanuel Moutoussamy");  
user_details_map.set("faahi7267","Faustin Ahishakiye");  
user_details_map.set("tveito","Øystein Tveito");  
user_details_map.set("vetlewoie","Vetle Hofsøy-Woie");  
user_details_map.set("tstokowy","Tomasz Stokowy");  
user_details_map.set("torea","Tore Aalberg");  
user_details_map.set("jeco","Jeremy");  
user_details_map.set("andrske","Andreas Sæther Skeidsvoll");  
user_details_map.set("aeklund","Anders Eklund");  
user_details_map.set("torlyn","Torkel Lyng");  
user_details_map.set("carlt","Carl Thomas Stene");  
user_details_map.set("ingbli","Inger Lise Blikø");  
user_details_map.set("ole.saastad","Ole Widar Saastad");  
user_details_map.set("hicham","Hicham Agueny");  
user_details_map.set("klaus.johannsen","Klaus Johannsen");  
user_details_map.set("andreas.kalva","Andreas Kalvå");  
user_details_map.set("jacobz","Jacob Ziemke");  
user_details_map.set("vishist.sharma","Vishist Sharma");  
user_details_map.set("kjestr","Kjersti Strømme");  
user_details_map.set("rogkva","Roger Kvam");  
user_details_map.set("terjekv","Terje Kvernes");  
user_details_map.set("abdulrahman.azab","Abdulrahman Azab");  
user_details_map.set("jenamu","Jenny Andrea Amundsen");  
user_details_map.set("lorand","Lorand Szentannai");  
user_details_map.set("dhanya.pushpadas","Dhanya Pushpadas");  
user_details_map.set("stegun","Steinar Gundersen");  
user_details_map.set("alexander.oltu","Alexander Oltu");  
user_details_map.set("jorn.dietze","Jörn Dietze");  
user_details_map.set("trulsmat","Truls Mathiassen");  
user_details_map.set("mlinge","Marius Linge");  
user_details_map.set("maiken.pedersen","Maiken Pedersen");  
user_details_map.set("parosen","Axel Rosén");  
user_details_map.set("pavel.kucera","Pavel Kucera");  
user_details_map.set("espenfl","Espen Flage-Larsen");  
user_details_map.set("siri.kallhovd","Siri Kallhovd");  
user_details_map.set("thomas.roblitz","Thomas Röblitz");  
user_details_map.set("john.floan","John Floan");  
user_details_map.set("hs","Helge Stranden");  
user_details_map.set("saerda","Saerda Halifu");  
user_details_map.set("hanne.moa","Hanne Moa");  
user_details_map.set("adilhasan2","Adil Hasan");  
user_details_map.set("ilia","Ilia Zhakun");  
user_details_map.set("adfidjestol","Arne Dag Fidjestøl");  
user_details_map.set("marcin.krotkiewski","Marcin Krotkiewski");  
user_details_map.set("sabry.razick","Sabry Razick");  
user_details_map.set("tufan.arslan","Tufan Arslan");  
user_details_map.set("henrik.nagel","Henrik R. Nagel");  
user_details_map.set("radovan.bast","Radovan Bast");  
user_details_map.set("espen.tangen","Espen Tangen");  
user_details_map.set("vegard.eide","Vegard Eide");  
user_details_map.set("nikolaiv","Nikolai Vazov");  
user_details_map.set("vigdisg","Vigdis Guldseth");  
user_details_map.set("einarli","Einar Lillebrygfjeld");  
user_details_map.set("dan.jonsson","Dan Johan Jonsson");  
user_details_map.set("r.o.nordby","Roger O. Nordby");  
user_details_map.set("bjorn.lindi","Bjørn Lindi");  
user_details_map.set("haeide","Hans Eide");  
user_details_map.set("knarbakk","Stein Inge Knarbakk");  
user_details_map.set("steinar.tradal-henden","Steinar Henden");  
user_details_map.set("j.k.nilsen","Jon Kerr Nilsen");  
user_details_map.set("buzh","Andreas Skau");  
user_details_map.set("thierry.toutain","Thierry Toutain");  
user_details_map.set("einar.nass.jensen","Einar N Jensen");  
user_details_map.set("b.h.mevik","Bjørn-Helge Mevik");  
user_details_map.set("abach","Andreas Bach"); 

function getfullname(username){
  if( !! username){
    const name= user_details_map.get(username);
    if( !! name){
       return name;
    }  else{
       return  "";
    }
  }else{
     return  "";
  }
}

