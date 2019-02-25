#!/bin/bash

ADMINNAME="windowsadmin"

az vm create --image Win2019Datacenter --admin-username ${ADMINNAME} --location australiasoutheast --name windowstest --resource-group ${RGNAME} --size Standard_D3_v2 --vnet-name ${VNETNAME} --subnet management --public-ip-address "" --nsg "" --output table
