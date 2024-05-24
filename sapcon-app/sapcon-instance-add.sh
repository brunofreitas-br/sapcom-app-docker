#!/bin/bash
#Copyright (c) Microsoft Corporation. All rights reserved.
echo 'Microsoft Azure Sentinel SAP Continuous Threat Monitoring.
SAP ABAP Logs Connector - Limited Private Preview

Copyright (c) Microsoft Corporation. This preview software is Microsoft Confidential, and is subject to your Non-Disclosure Agreement with Microsoft. 
You may use this preview software internally and only in accordance with the Azure preview terms, located at https://azure.microsoft.com/en-us/support/legal/preview-supplemental-terms/  

Microsoft reserves all other rights
****'
function pause(){
   read -p "$*"
}

#Globals
dockerimage=sentinel4sapprivateprview.azurecr.io/sapcon
containername=sapcon
sysconf=systemconfig.ini
tagver=":latest"

echo '
-----Quick sapcon container start/add for KV deployment ----
This process will download the latest version of Sentinel SAP Connector, install and then run it. A currently running version of the instance will be stopped and automatically start after the process.
In order to process you will need the following prerequisites: 
Please enter the user/token you have received to install your sapcon-adapter
'
pause '[Press enter to agree and proceed as we will guide you through the installation process or control +  c to cancel the process]'


read -p 'Username: ' uservar
read -sp 'Token: ' tokenvar
echo ''
echo $tokenvar | docker login -u $uservar --password-stdin sentinel4sapprivateprview.azurecr.io

if [ $? -eq 1 ];
then 
	echo '
The user\token is incorrect - please get the correct user pass and rerun'
	exit 1
fi

echo 'Starting Docker image Pull'
docker pull $dockerimage
if [ $? -eq 1 ];
then 
	echo 'There is an error downloading the Sentinel SAP connector from the online repository, please contact Microsoft for support'
	exit 1
fi
pause 'Latest Sentinel Connector has been downloaded - Press <Enter> key to continue
'

echo 'Please enter the host folder path where systemconfig.ini and metadata.db is located so it can be mounted to the container'
read -p 'sysconfig file location: ' sysfileloc

last=${sysfileloc: -1}

if [ "$last" != "/" ];
then
        sysfileloc="$sysfileloc/"
fi

while [ ! -d "$sysfileloc" ] || [ ! -f "$sysfileloc$sysconf" ]
do
	echo '
The path is not a dir or does not exist'
	echo 'Please enter the host folder path where systemconfig.ini (e.g /home/user/config) is located. If you do not have a configuration ready, please create one or use the fresh install process. '
	read -p 'sysconfig file location: ' sysfileloc
done



sysid=$(cat $sysfileloc$sysconf | awk '$1=="sysid" {print $3}') 
echo $sysid
while [ ${#sysid} -ne 3 ] 
do 
	echo 'Your SAP connector configuration systemconfig.ini is invalid, missing SID configuration. Please ensure you have a complete configuration or create a new one using the fresh installation process.'
	pause 'Make sure the file is correct and try again'
	sysid=$(cat $sysfileloc$sysconf | awk '$1=="sysid" {print $3}')
done

containername="$containername-$sysid"

docker create -v $sysfileloc:/sapcon-app/sapcon/config/system --name $containername $dockerimage$tagver >/dev/null
if [ $? -eq 1 ];
then 
	echo '
Sentinel SAP connector is already installed, the previous connector will be removed and replaced by the new version'
	pause 'Press any key to update'
	docker stop $containername >/dev/null
	docker container rm $containername >/dev/null
	docker create -v $sysfileloc:/sapcon-app/sapcon/config/system --name $containername $dockerimage >/dev/null
	echo 'Sentinel SAP connector was updated for instance '"$sysid"
	pause 'Press any key to continue'
fi

echo '
Please enter the full file location path of your downloaded SAP NetWeaver SDK zip that has been downloaded, to download follow the link below

https://launchpad.support.sap.com/#/softwarecenter/template/products/%20_APP=00200682500000001943&_EVENT=DISPHIER&HEADER=Y&FUNCTIONBAR=N&EVENT=TREE&NE=NAVIGATE&ENR=01200314690100002214&V=MAINT&TA=ACTUAL&PAGE=SEARCH/SAP%20NW%20RFC%20SDK

Select SAP NW RFC SDK 7.50 -> Select Linux on X86_64 64BIT -> Download the latest version

Example: /home/user/nwrfc750P_7-70002752.zip'
#Press [Enter] key to continue...'

read -p 'SDK file location: ' sdkfileloc 
 
while [  ! -f "$sdkfileloc" ];
do
 	echo "
----file $sdkfileloc does not exist----"
	echo 'Please enter the full file location path of your downloaded SAP NetWeaver SDK zip that has been downloaded, to download follow the link below

https://launchpad.support.sap.com/#/softwarecenter/template/products/%20_APP=00200682500000001943&_EVENT=DISPHIER&HEADER=Y&FUNCTIONBAR=N&EVENT=TREE&NE=NAVIGATE&ENR=01200314690100002214&V=MAINT&TA=ACTUAL&PAGE=SEARCH/SAP%20NW%20RFC%20SDK

Select SAP NW RFC SDK 7.50 -> Select Linux on X86_64 64BIT -> Download the latest version

Example: /home/user/nwrfc750P_7-70002752.zip'
    read -p 'SDK file location: ' sdkfileloc 
done

unzip > /dev/null 2>&1
ifunzip=$?


if [ $ifunzip -eq 0 ]
then
	unzip -Z1 $sdkfileloc |  grep nwrfcsdk/demo/sso2sample.c > /dev/null
	sdkok=$?
	sdknum=$(unzip -Z1 $sdkfileloc |  wc -l)
else 
	if [ $(du "$sdkfileloc" | awk '{print $1+0}') -ge 16000 ] 
	then 
		sdkok=0 
		sdknum=34 
	else 
		sdkok=1
	fi
fi

while [ $? -eq 1 ] || [ $sdkok -eq 1 ] || [ ! $sdknum -ge 34 ] ;
do
	echo 'The NetWeaver SDK provided is invalid, likely an incorrect version or corrupt file, Please download the file and try again'
	read -p 'SDK file location: ' sdkfileloc
	if [ $ifunzip -eq 0 ]
	then
		unzip -Z1 $sdkfileloc |  grep nwrfcsdk/demo/sso2sample.c > /dev/null
		sdkok=$?
		sdknum=$(unzip -Z1 $sdkfileloc |  wc -l)
	else 
		if [ $(du "$sdkfileloc" | awk '{print $1+0}') -ge 16000 ] 
		then 
			sdkok=0 
			sdknum=34 
		else 
			sdkok=1
		fi
	fi
done

docker cp $sdkfileloc $containername:/sapcon-app/inst/ >/dev/null
if [ $? -eq 0 ];
then 
	echo 'SDK archive was successfully updated'
else  
	echo 'Sentinel Connector upgrade failed – the NetWeaver SDK could not be added to the image. Please contact Microsoft for support'
	exit 1
fi

docker start $containername >/dev/null
if [ $? -eq 0 ];
then 
	echo '
Sentinel SAP connector was started- quick reference for future steps:
View logs: docker logs '"$containername"'
View logs continuously docker logs -f '"$containername"'
Stop the connector: docker stop '"$containername"'
Start the connector: docker start '"$containername"'
The process has been successfully completed, thank you !'
	exit 0
else  
	echo 'Sentinel Connector upgrade failed – the NetWeaver SDK could not be added to the image. Please contact Microsoft for support'
	exit 1
fi
