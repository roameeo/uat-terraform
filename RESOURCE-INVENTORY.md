# UAT Azure Resources Inventory

## Resource Summary
**Subscription:** Ulterra UAT (f830b735-d380-4c43-b54b-73ba9ff8cd9d)  
**Region:** Central US  
**Last Updated:** November 12, 2025

---

## Resource Groups

| Name | Purpose | Location |
|------|---------|----------|
| UATNETRG | Network infrastructure | centralus |
| UATSERVERRG | Compute resources | centralus |
| NetworkWatcherRG | Azure Network Watcher (auto-created) | centralus |
| terraform_rg | Terraform state storage | centralus |

---

## Network Resources (UATNETRG)

### Virtual Network
- **Name:** UATSERVERVNET
- **Address Space:** 10.0.0.0/22
- **Resource ID:** `/subscriptions/f830b735-d380-4c43-b54b-73ba9ff8cd9d/resourceGroups/UATNETRG/providers/Microsoft.Network/virtualNetworks/UATSERVERVNET`

### Subnets
| Name | Address Range | Purpose |
|------|---------------|---------|
| default | 10.0.0.0/24 | Default subnet |
| AzureBastionSubnet | 10.0.1.0/26 | Azure Bastion |
| UATSERVERS | 10.0.2.0/24 | Server resources |

### Bastion
- **Name:** UATSERVERVNET-Bastion
- **SKU:** Basic
- **Public IP:** uatservervnet-bastion (Static, Standard)

---

## Compute Resources (UATSERVERRG)

### Virtual Machines

#### UATAD01 (Domain Controller)
- **Size:** Standard_D2ds_v6
- **OS:** Windows Server 2022 Datacenter Azure Edition
- **OS Disk:** UATAD01_OsDisk_1_02eb907362e24ddb8b88ddfc0a219148 (StandardSSD_LRS, 127 GB)
- **Network Interface:** uatad01600
- **Public IP:** UATAD01-ip (Static, Standard)
- **NSG:** UATAD01-nsg
- **License:** Windows_Server (Hybrid Benefit)
- **Admin User:** azadmin

#### UATAD02 (Domain Controller)
- **Size:** Standard_D2ds_v6
- **OS:** Windows Server 2022 Datacenter Azure Edition
- **OS Disk:** UATAD02_OsDisk_1_141e7ef277424a359a2a91f3d9c7d308 (StandardSSD_LRS, 127 GB)
- **Network Interface:** uatad02958
- **License:** Windows_Server (Hybrid Benefit)
- **Admin User:** azadmin

#### UATMULTI01 (Multi-purpose Server)
- **Size:** Standard_D4as_v6
- **OS:** Windows Server 2022 Datacenter Azure Edition
- **OS Disk:** UATMULTI01_OsDisk_1_dd4f35cabe854be9b0160868e28e5d02 (Premium_LRS, 127 GB)
- **Data Disk:** UATMULTI01_DataDisk_0 (Premium_LRS, 1024 GB, LUN 0, ReadOnly caching)
- **Network Interface:** uatmulti01871
- **NSG:** UATMULTI01-nsg
- **License:** Windows_Server (Hybrid Benefit)
- **Admin User:** azadmin
- **Boot Diagnostics:** Enabled
- **Tags:**
  - Build by: Stormy Winters
  - Build date: 11/10/2025
  - Contact: Glenn Redfern
  - Environment: UAT
  - Function: File/Print/CA/Multi use
  - Owner: Cloud Admins

### Network Security Groups
| NSG Name | Associated Resource |
|----------|-------------------|
| UATAD01-nsg | uatad01600 (NIC) |
| UATMULTI01-nsg | uatmulti01871 (NIC) |

---

## Terraform Module Mapping

| Azure Resource | Terraform Resource Address |
|----------------|---------------------------|
| UATNETRG | `module.resource_groups.azurerm_resource_group.network` |
| UATSERVERRG | `module.resource_groups.azurerm_resource_group.servers` |
| UATSERVERVNET | `module.network.azurerm_virtual_network.vnet` |
| default subnet | `module.network.azurerm_subnet.default` |
| AzureBastionSubnet | `module.network.azurerm_subnet.bastion` |
| UATSERVERS subnet | `module.network.azurerm_subnet.servers` |
| Bastion Host | `module.network.azurerm_bastion_host.bastion` |
| Bastion Public IP | `module.network.azurerm_public_ip.bastion` |
| UATAD01 VM | `module.compute.azurerm_windows_virtual_machine.uatad01` |
| UATAD02 VM | `module.compute.azurerm_windows_virtual_machine.uatad02` |
| UATMULTI01 VM | `module.compute.azurerm_windows_virtual_machine.uatmulti01` |
| UATMULTI01 Data Disk | `module.compute.azurerm_managed_disk.uatmulti01_data` |

---

## Not Managed by Terraform

The following resources exist in the subscription but are **not** included in Terraform:

- **NetworkWatcherRG** - Auto-created by Azure, typically not managed via IaC
- **terraform_rg** - Contains Terraform state, managed separately
- **sttfstate7801** - Storage account for Terraform state

---

## Common Tags

All managed resources use these tags:

```hcl
BuildBy     = "Stormy"
BuildDate   = "2025-11-10"
Environment = "UAT"
Function    = "CoreInfra"
```

Note: UATMULTI01 has additional custom tags as shown above.

---

## Costs & SKU Information

### VM SKUs
- **Standard_D2ds_v6:** 2 vCPU, 8 GB RAM, NVMe controller
- **Standard_D4as_v6:** 4 vCPU, 16 GB RAM, NVMe controller

### Storage
- **StandardSSD_LRS:** Lower cost, standard SSD
- **Premium_LRS:** Higher performance, premium SSD

### Network
- **Bastion Basic SKU:** Up to 25 concurrent connections
- **Public IP Standard SKU:** Required for Bastion

---

## Import Status

✅ All resources have been configured for Terraform import  
✅ Import script available: `Scripts/import-resources.ps1`  
⏳ Requires admin_password to be set before import  

See [IMPORT-GUIDE.md](IMPORT-GUIDE.md) for detailed instructions.
