param (
  [string]$rgName = "demoresourcegroup",

  [string]$vnetName = "demovnet"
)

New-AzureRmResourceGroup -Name $rgName -Location "Australia East"

$vnet = New-AzureRmVirtualNetwork -Name $vnetName -AddressPrefix 192.168.0.0/16 -ResourceGroupName $rgName -Location "Australia East"

$subnetConfigGw = New-AzureRmVirtualNetworkSubnetConfig -Name GatewaySubnet -AddressPrefix 192.168.0.0/27
$vnet.Subnets.Add($subnetConfigGw)
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet

$subnetConfigJb = New-AzureRmVirtualNetworkSubnetConfig -Name jumpbox -AddressPrefix 192.168.1.0/29
$vnet.Subnets.Add($subnetConfigJb)
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet

$subnetConfigMgmt = New-AzureRmVirtualNetworkSubnetConfig -Name management -AddressPrefix 192.168.2.0/24
$vnet.Subnets.Add($subnetConfigMgmt)
Set-AzureRmVirtualNetwork -VirtualNetwork $vnet

$rdp = New-AzureRmNetworkSecurityRuleConfig -Name "allow-RDP-from-jumpbox" -SourcePortRange * -Protocol TCP -SourceAddressPrefix "192.168.2.0/24" -Access Allow -Priority 110 -Direction Inbound -DestinationPortRange 3389 -DestinationAddressPrefix *
$ssh = New-AzureRmNetworkSecurityRuleConfig -Name "allow-SSH-from-internet" -SourcePortRange * -Protocol TCP -SourceAddressPrefix Internet -Access Allow -Priority 120 -Direction Inbound -DestinationPortRange 22 -DestinationAddressPrefix *

New-AzureRmNetworkSecurityGroup -Name management -SecurityRules $rdp -ResourceGroupName $rgName -Location "Australia East"
New-AzureRmNetworkSecurityGroup -Name jumpbox -SecurityRules $ssh -ResourceGroupName $rgName -Location "Australia East"

$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

$nsg = Get-AzureRmNetworkSecurityGroup -Name jumpbox -ResourceGroupName $rgName
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name jumpbox -VirtualNetwork $vnet
$vnetConfig = Set-AzureRmVirtualNetworkSubnetConfig -Name jumpbox -VirtualNetwork $vnet -NetworkSecurityGroup $nsg -AddressPrefix $subnet.AddressPrefix
Set-AzureRmVirtualNetwork -VirtualNetwork $vnetConfig

$nsg = Get-AzureRmNetworkSecurityGroup -Name management -ResourceGroupName $rgName
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name management -VirtualNetwork $vnet
$vnetConfig = Set-AzureRmVirtualNetworkSubnetConfig -Name management -VirtualNetwork $vnet -NetworkSecurityGroup $nsg -AddressPrefix $subnet.AddressPrefix
Set-AzureRmVirtualNetwork -VirtualNetwork $vnetConfig