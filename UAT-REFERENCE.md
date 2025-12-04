# UAT Environment - Quick Reference

## Domain Information
- **Domain Name**: uat.local
- **NetBIOS Name**: UAT
- **Domain Controllers**: 
  - UATAD01 (10.48.2.4)
  - UATAD02 (10.48.2.5)

## User Accounts
- **Total Users**: 310
  - 176 enabled users
  - 134 disabled users (moved to Disabled Users OU)
- **Default Password for Imported Users**: `ChangeMe123!`
  - Must change at next logon

## Domain Admin Accounts
| Username | Password | Groups |
|----------|----------|--------|
| azadmin | (From Key Vault) | Built-in admin |
| terraform.adm | 3NNz[YQy[,""2J(Ab=w?vxd\|0L;!u#61 | Domain Admins, Enterprise Admins |
| swinters.adm | &P,Ivifl0"%Y,v'uM&8as2\|{SojuR8mI | Domain Admins, Enterprise Admins |
| stjohnson.adm | ChangeMe2SomethingElse! | Domain Admins, Enterprise Admins |
| aphillips.adm | ChangeMe2SomethingElse! | Domain Admins, Enterprise Admins |
| awill.adm | ChangeMe2SomethingElse! | Domain Admins, Enterprise Admins |

## VM Passwords (Azure Key Vault)
All VM passwords are stored in Key Vault: `CUS-UAT-KEYVAULT`
- UATAD01
- UATAD02
- UATATLAS01
- UATIIS01
- UATMULTI01
- UATSQL01

## Member Servers
- **UATATLAS01** (10.48.2.132) - Application subnet
- **UATIIS01** (10.48.2.133) - Application subnet
- **UATMULTI01** (10.48.2.134) - Application subnet
- **UATSQL01** (10.48.2.196) - SQL subnet

## Network Configuration
- **Virtual Network**: UATSERVERVNET (10.48.0.0/16)
- **Subnets**:
  - AzureBastionSubnet: 10.48.1.0/26
  - UATAD: 10.48.2.0/25
  - UATAPPLICATION: 10.48.2.128/26
  - UATSQL: 10.48.2.192/26
  - UATDMZ: 10.48.3.0/26

## Meraki vMX
- **VM Name**: UATVMX01
- **Public IP**: 172.169.122.242
- **VM Size**: Standard_F4s_v2
- **Managed Resource Group**: mrg-cisco-meraki-vmx-20251203082153
- **Management**: Meraki Dashboard (dashboard.meraki.com)

## Active Directory Groups
### Custom Groups Created (17 total):
- IT (53 members)
- Atlas Authentication (34 members)
- NAV_PDF_Reader_PDox (14 members)
- Ulterra Enterprise Application Users (14 members)
- Engineering Console Users (11 members)
- Power_BI_Report (7 members)
- Citrix Xen 7 - Ulterra Enterprise Apps (7 members)
- DDF_ApplicationsEngineers (6 members)
- SQL 2019 Cluster Admins (6 members)
- SQL Cluster Admins (6 members)
- DDF_DesignEngineers (4 members)
- sql_remote_users (4 members)
- JETServiceTier (2 members)
- Bit Photos Write (2 members)
- AppID_Users (1 member)
- Atlas Data (1 member)
- Citrix Xen 7 - CommInvoice (1 member)

## Azure Resources
- **Subscription**: Ulterra UAT
- **Resource Groups**:
  - UATNETRG (Network resources)
  - UATSERVERRG (Compute resources)
  - CUS-UAT-KV-RG (Key Vault)
- **Region**: Central US

## Important Files
- User import source: `C:\Temp\importusers.csv`
- All automation scripts: `Scripts/` directory
- Meraki documentation: `MERAKI-VMX.md`

## Quick Commands
```powershell
# List all AD users
Get-ADUser -Filter * | Select Name, SamAccountName, Enabled

# List Domain Admins
Get-ADGroupMember -Identity "Domain Admins"

# Check domain controller replication
repadmin /replsummary

# Verify DNS
nslookup uat.local
```

## Notes
- All infrastructure managed with Terraform (except Meraki vMX - Azure Managed App)
- Repository: https://github.com/roameeo/uat-terraform
- All VMs use individual passwords from Key Vault
- Users must change password on first logon
