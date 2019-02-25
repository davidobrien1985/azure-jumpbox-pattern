# Simple Azure Jumpbox Pattern

This is sample code to deploy a simple Microsoft Azure jumpbox.

## How to deploy

The code is split into two stages deploying all resources into "Australia East" region:

Stage 1:

- `create-network.ps1`
  - creates a Resource Group with
    - one vnet
    - three subnets (GatewaySubnet, jumpbox, management)
    - two Network Security Groups
      - for the jumpbox subnet only allowing port `22` inbound from the internet
      - for the management subnet only allowing port `3389` inbound from the jumpbox subnet

Stage 2:

- `deploy-jumpbox.sh`
  - deploys an Ubuntu VM with a public IP into the jumpbox subnet
  - installs the `AADLoginForLinux` VM extension to the VM which will enable AAD users to log in to the VM
- `deploy-windowsvm.sh`
  - deploys a Windows Server 2019 VM with only a private IP into the management subnet

## How to connect

Users can now connect to the private IP of the Windows VM by tunneling the RDP connection through the SSH tunnel to the Linux VM.