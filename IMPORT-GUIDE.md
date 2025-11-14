# UAT Azure Infrastructure - Terraform Import Guide

This repository contains Terraform configuration for managing UAT Azure infrastructure.

## 📋 Resources Managed

### Resource Groups
- **UATNETRG** - Network resources
- **UATSERVERRG** - Server/compute resources

### Network Resources
- Virtual Network: `UATSERVERVNET` (10.0.0.0/22)
  - Default Subnet: 10.0.0.0/24
  - AzureBastionSubnet: 10.0.1.0/26
  - UATSERVERS Subnet: 10.0.2.0/24
- Azure Bastion Host with Public IP

### Compute Resources
- **UATAD01** - Domain Controller 1 (Standard_D2ds_v6)
  - Includes: NSG, Public IP, NIC, VM
- **UATAD02** - Domain Controller 2 (Standard_D2ds_v6)
  - Includes: NIC, VM only (no public IP or NSG)
- **UATMULTI01** - Multi-purpose Server (Standard_D4as_v6)
  - Includes: NSG, NIC, VM, 1TB data disk

## 🚀 Getting Started

### Prerequisites
- Azure CLI installed and authenticated (`az login`)
- Terraform installed (v1.0+)
- PowerShell 7+ (for import script)
- Access to UAT subscription: `f830b735-d380-4c43-b54b-73ba9ff8cd9d`

### Initial Setup

1. **Clone the repository** (if not already done)
   ```bash
   cd uat-terraform
   ```

2. **Set the admin password**
   
   You have two options:
   
   **Option A:** Environment Variable (Recommended)
   ```powershell
   $env:TF_VAR_admin_password = "YourActualVMPassword"
   ```
   
   **Option B:** terraform.tfvars file
   ```hcl
   admin_password = "YourActualVMPassword"
   ```
   
   ⚠️ **Important:** Use the actual password that was set when the VMs were created in Azure.

3. **Initialize Terraform**
   ```bash
   terraform init
   ```

4. **Run the import script**
   ```powershell
   .\Scripts\import-resources.ps1
   ```

5. **Verify the import**
   ```bash
   terraform state list
   terraform plan
   ```

## 📁 Directory Structure

```
uat-terraform/
├── main.tf                  # Root module configuration
├── variables.tf             # Root variables
├── terraform.tfvars         # Variable values
├── backend.tf              # Remote state configuration
├── providers.tf            # Provider configuration
├── ResourceGroups/         # Resource group module
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── Network/                # Network resources module
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── Compute/                # Compute resources module
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── Scripts/
    └── import-resources.ps1  # PowerShell import script
```

## 🔧 Module Structure

### ResourceGroups Module
Manages the two resource groups: UATNETRG and UATSERVERRG

### Network Module
Manages:
- Virtual Network
- Subnets (default, bastion, servers)
- Bastion Host and Public IP

### Compute Module
Manages:
- Network Security Groups
- Network Interfaces
- Public IPs
- Virtual Machines (UATAD01, UATAD02, UATMULTI01)
- Managed Disks

## ⚠️ Important Notes

### About the Import Process

1. **Admin Password Required**: The import script imports the VM resources, but Terraform requires the admin password to be specified. This password is NOT imported from Azure (it's stored encrypted). You must provide the actual password used when the VMs were created.

2. **Import is Idempotent**: If a resource is already imported, the script will show an error for that resource but continue with others. This is safe.

3. **State Matches Reality**: After import, `terraform plan` should show minimal or no changes. Any changes shown indicate differences between your Terraform configuration and actual Azure resources.

### Common Import Issues

- **Password doesn't match**: If `terraform plan` shows VM replacement, the password in your config may not match the actual password.
- **Disk names**: OS disk names are unique IDs from Azure and are preserved in the configuration.
- **Tags**: Some resources may show tag differences - these can be applied safely.

## 🔐 Security Best Practices

1. **Never commit passwords**: The admin_password is marked as sensitive
2. **Use environment variables**: Set `TF_VAR_admin_password` instead of storing in files
3. **Protect state files**: ⚠️ State files contain sensitive data including VM passwords - backend is configured to use Azure Storage with access controls
4. **Review .gitignore**: Ensure terraform.tfvars is excluded if it contains secrets
5. **Password in plain text**: Note that Terraform stores the admin_password in state files in plain text - ensure state backend is properly secured

## 📝 Next Steps After Import

1. **Review and apply any differences**:
   ```bash
   terraform plan
   terraform apply
   ```

2. **Add additional resources** as needed to the appropriate modules

3. **Configure VM extensions** (if needed) for:
   - Domain join operations
   - Monitoring agents
   - Security configurations

4. **Set up CI/CD** for Terraform deployments

## 🆘 Troubleshooting

### Import Script Fails
- Ensure you're logged into Azure CLI: `az account show`
- Verify subscription access: `az account set --subscription f830b735-d380-4c43-b54b-73ba9ff8cd9d`
- Check Terraform is initialized: `terraform init`

### Plan Shows Differences
- Verify admin_password matches the actual VM password
- Check that resource configurations match Azure reality
- Review any tags or metadata differences

### State Issues
- Verify backend storage account access
- Check that state file isn't locked by another operation
- Use `terraform state list` to see imported resources

## 📞 Support

For issues or questions:
- Contact: Stormy Winters
- Environment: UAT
- Subscription: Ulterra UAT (f830b735-d380-4c43-b54b-73ba9ff8cd9d)
