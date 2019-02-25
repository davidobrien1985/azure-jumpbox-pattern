#!/bin/bash

ADMINNAME="jumpboxadmin"

az vm create --image UbuntuLTS --generate-ssh-keys --admin-username ${ADMINNAME} --location australiaeast --name jumpbox --resource-group $1 --size Standard_D3_v2 --vnet-name $2 --subnet jumpbox --nsg "" --output table

sleep 15

az vm extension set --publisher Microsoft.Azure.ActiveDirectory.LinuxSSH --name AADLoginForLinux --resource-group $1 --vm-name jumpbox