#!/bin/bash

#Update RFC sdk Parameters
mkdir -p /etc/ld.so.conf.d/ \
   && mkdir -p /usr/sap/ \
   && echo "# include nwrfcsdk" > /etc/ld.so.conf.d/nwrfcsdk.conf \
   && echo "/usr/local/sap/nwrfcsdk/lib" >> /etc/ld.so.conf.d/nwrfcsdk.conf
ldconfig

if [[ ! -f "/sapcon-app/sapcon/config/system/settings.json" ]]; then
   cp "/sapcon-app/template/settings.json" "/sapcon-app/sapcon/config/system/settings.json"
else
   echo "settings.json already exists and therefore will not be replaced"
fi