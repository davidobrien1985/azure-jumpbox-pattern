ADMINNAME="windowsadmin"
ADMINPASSWORD="P@ssw0rd123!"

az vm create --image Win2019Datacenter --admin-username ${ADMINNAME} --admin-password ${ADMINPASSWORD} --location australiasoutheast --name windowstest --resource-group $1 --size Standard_D3_v2 --vnet-name $2 --subnet management --public-ip-address "" --nsg "" --output table
