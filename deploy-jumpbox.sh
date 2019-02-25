#!/bin/bash

ADMINNAME="jumpboxadmin"

az vm create --image UbuntuLTS --generate-ssh-keys --admin-username ${ADMINNAME} --location australiaeast --name jumpbox --resource-group ${RGNAME} --size Standard_D3_v2 --vnet-name ${VNETNAME} --subnet jumpbox --nsg "" --output table

az vm extension set --publisher Microsoft.Azure.ActiveDirectory.LinuxSSH --name AADLoginForLinux --resource-group ${RGNAME} --vm-name jumpbox