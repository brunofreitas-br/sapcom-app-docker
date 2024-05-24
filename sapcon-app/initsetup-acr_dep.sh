#!/bin/bash

#install Pyrfc python
#pip3 install pynwrfc==2.1.0 >/dev/null 2>&1
python -c "import pyrfc" >/dev/null 2>&1

if [ ! $? -eq 0 ]; then
   #unzip sdk zip
   echo 'showing inst folder'
   ls /sapcon-app/inst/
   echo 'trying to unzip the SDK'
   unzip -o "$(find /sapcon-app/inst/ -type f -name "nwrfc75*.zip")" -d /usr/local/sap/ >/dev/null

   #Update RFC sdk Parameters
   mkdir -p /etc/ld.so.conf.d/ \
      && mkdir -p /usr/sap/ \
      && echo "# include nwrfcsdk" > /etc/ld.so.conf.d/nwrfcsdk.conf \
      && echo "/usr/local/sap/nwrfcsdk/lib" >> /etc/ld.so.conf.d/nwrfcsdk.conf
   ldconfig

   cd sapcon
   cd setup || exit 1
   pip install --no-index pyrfc-3.3.1-cp39-cp39-linux_x86_64.whl
   if [ $? -eq 0 ]; then
      echo 'pyrfc was installed'
   fi
fi

if [[ ! -d "/sapcon-app/sapcon/config/system/log" ]]; then
   mkdir -p /sapcon-app/sapcon/config/system/log/
else
   echo "log dir already exists and therefore will not be created"
fi

if [[ ! -f "/sapcon-app/sapcon/config/system/settings.json" ]]; then
   cp "/sapcon-app/template/settings.json" "/sapcon-app/sapcon/config/system/settings.json"
else
   echo "settings.json already exists and therefore will not be replaced"
fi

cd /sapcon-app/ || exit 1

ln -s /usr/bin/python3 python >/dev/null 2>&1
