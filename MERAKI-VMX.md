# Cisco Meraki vMX Deployment Information

## Deployment Details
The Meraki vMX was deployed from the Azure Portal via the Meraki Dashboard.

### Configuration
- **VM Name**: UATVMX01
- **Resource Group**: UATNETRG
- **Managed Resource Group**: mrg-cisco-meraki-vmx-20251203082153
- **Region**: Central US
- **VM Size**: Standard_F4s_v2
- **Virtual Network**: UATSERVERVNET
- **WAN Subnet**: UATDMZ (10.48.3.0/26)

### Authentication
- **Meraki Token**: Configured during deployment
- **Application Name**: CiscoMerakvMX

### Notes
- The vMX is deployed as an **Azure Managed Application**
- Resources are managed in the Managed Resource Group: `mrg-cisco-meraki-vmx-20251203082153`
- The vMX has a **public IP** for Meraki Dashboard connectivity
- Currently using **WAN interface only** (LAN can be added later if needed)
- Management is done through **Meraki Dashboard** (dashboard.meraki.com)

### Network Configuration
The DMZ subnet (UATDMZ) was created via Terraform specifically for the vMX deployment.

### Terraform Management
The vMX is **NOT managed by Terraform** because:
1. It was deployed as an Azure Managed Application
2. Managed Applications have their own lifecycle controlled by the publisher (Cisco)
3. Resources are in a locked managed resource group

The Terraform Meraki module has been commented out in `main.tf`.
