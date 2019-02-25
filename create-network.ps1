param (
  [string]$rgName = "demoresourcegroup",

  [string]$vnetName = "demovnet"
)

New-AzResourceGroup -Name $rgName -Location "Australia East"

$vnet = New-AzVirtualNetwork -Name $vnetName -AddressPrefix 192.168.0.0/16 -ResourceGroupName $rgName -Location "Australia East"

$subnetConfigGw = New-AzVirtualNetworkSubnetConfig -Name GatewaySubnet -AddressPrefix 192.168.0.0/27
$vnet.Subnets.Add($subnetConfigGw)
Set-AzVirtualNetwork -VirtualNetwork $vnet

$subnetConfigJb = New-AzVirtualNetworkSubnetConfig -Name jumpbox -AddressPrefix 192.168.1.0/29
$vnet.Subnets.Add($subnetConfigJb)
Set-AzVirtualNetwork -VirtualNetwork $vnet

$subnetConfigMgmt = New-AzVirtualNetworkSubnetConfig -Name management -AddressPrefix 192.168.2.0/24
$vnet.Subnets.Add($subnetConfigMgmt)
Set-AzVirtualNetwork -VirtualNetwork $vnet

$rdp = New-AzNetworkSecurityRuleConfig -Name "allow-RDP-from-jumpbox" -SourcePortRange * -Protocol TCP -SourceAddressPrefix "192.168.2.0/24" -Access Allow -Priority 110 -Direction Inbound -DestinationPortRange 3389 -DestinationAddressPrefix *
$ssh = New-AzNetworkSecurityRuleConfig -Name "allow-SSH-from-internet" -SourcePortRange * -Protocol TCP -SourceAddressPrefix Internet -Access Allow -Priority 120 -Direction Inbound -DestinationPortRange 22 -DestinationAddressPrefix *

New-AzNetworkSecurityGroup -Name management -SecurityRules $rdp -ResourceGroupName $rgName -Location "Australia East"
New-AzNetworkSecurityGroup -Name jumpbox -SecurityRules $ssh -ResourceGroupName $rgName -Location "Australia East"

$vnet = Get-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName

$nsg = Get-AzNetworkSecurityGroup -Name jumpbox -ResourceGroupName $rgName
$subnet = Get-AzVirtualNetworkSubnetConfig -Name jumpbox -VirtualNetwork $vnet
$vnetConfig = Set-AzVirtualNetworkSubnetConfig -Name jumpbox -VirtualNetwork $vnet -NetworkSecurityGroup $nsg -AddressPrefix $subnet.AddressPrefix
Set-AzVirtualNetwork -VirtualNetwork $vnetConfig

$nsg = Get-AzNetworkSecurityGroup -Name management -ResourceGroupName $rgName
$subnet = Get-AzVirtualNetworkSubnetConfig -Name management -VirtualNetwork $vnet
$vnetConfig = Set-AzVirtualNetworkSubnetConfig -Name management -VirtualNetwork $vnet -NetworkSecurityGroup $nsg -AddressPrefix $subnet.AddressPrefix
Set-AzVirtualNetwork -VirtualNetwork $vnetConfig