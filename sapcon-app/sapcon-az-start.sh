#!/bin/bash
#Start az ubuntu vm 18.04
if [ ! -z $1 ] 
then
	kv=$1-$(date +%s)
	vm=ubuntu-sapcon-main
	rg=sentinel-rg
	vmuser=azureuser
	az group create -n $rg -l "EastUS" >/dev/null
	oldvm=$(az resource list -g $rg --out json | jq -r '.[] | .id' | grep $vm)
	
	echo '
Delete Old VMs and KVs?(enter yes to delete - any other key to continue)?
'
	read -p 'Answer : ' vmdel
	vmdel=$(echo $vmdel| tr '[:upper:]' '[:lower:]')
	if [[ $vmdel =~ 'yes' ]] 
	then
		echo 'Starting Deletion'
		az resource delete --ids $oldvm
	fi
	az keyvault create --name $kv --resource-group $rg >/dev/null
	az vm create  --resource-group $rg   --name $vm  --image UbuntuLTS  --admin-username $vmuser --data-disk-sizes-gb 10 30 --size Standard_DS2_v2 --generate-ssh-keys  --assign-identity 

	if [ $? -ne 0 ]
	then
		echo 'There was an error starting the vm'
		exit 1
	else
        	spID=$(az vm show -g $rg -n $vm --query identity.principalId --out tsv)	
		az keyvault set-policy  --name $kv  --resource-group $rg  --object-id $spID  --secret-permissions get set
		vmip=$(az vm show -d -g $rg -n $vm --query publicIps -o tsv)
		scp ./sapcon-sentinel-kickstart.sh $vmuser@$vmip:~/
		ssh $vmuser@$vmip
fi
else 
	echo 'Please ented the kv name as the first var'
fi

