#!/bin/bash
id="plugin-$(date +%s)"
fram="https://metadoc.sigma2.no/status_graph/?period=week&type=cpu&size=large&dynamic=false&start=0&end=0&format=png&machine=fram"
fram_name="fram-$(date +%s).png"
saga="https://metadoc.sigma2.no/status_graph/?period=week&type=cpu&size=large&dynamic=false&start=0&end=0&format=png&machine=saga"
saga_name="saga-$(date +%s).png"
betzy="https://metadoc.sigma2.no/status_graph/?period=week&type=cpu&size=large&dynamic=false&start=0&end=0&format=png&machine=betzy"
betzy_name="betzy-$(date +%s).png"
wget -O "$fram_name" $fram &>/dev/null
wget -O "$saga_name" $saga &>/dev/null
wget -O "$betzy_name" $betzy &>/dev/null

HTML=""
HTML="${HTML}<p> <h2> Fram  load</h2> <img src=\"${fram_name}\" alt=\"fram\"> </p>"
HTML="${HTML}<p> <h2> SAGA  load</h2> <img src=\"${saga_name}\" alt=\"saga\"> </p>"
HTML="${HTML}<p> <h2> Betzy load</h2> <img src=\"${betzy_name}\" alt=\"betzy\"> </p>"
HTML="${HTML}"

echo "${HTML}"
