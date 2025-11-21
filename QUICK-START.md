# Quick Start - Import UAT Resources

## Step 1: Set Admin Passwords

Choose ONE of these approaches. Key Vault is strongly recommended for multiple VMs.

### Option A: Azure Key Vault (Per‑VM Passwords, Recommended)

1. Create secrets in the Key Vault (one per VM, secret names match VM names):

```powershell
az keyvault secret set --vault-name CUS-UAT-KEYVAULT --name UATAD01 --value <PASSWORD_FOR_UATAD01>
az keyvault secret set --vault-name CUS-UAT-KEYVAULT --name UATAD02 --value <PASSWORD_FOR_UATAD02>
az keyvault secret set --vault-name CUS-UAT-KEYVAULT --name UATMULTI01 --value <PASSWORD_FOR_UATMULTI01>
az keyvault secret set --vault-name CUS-UAT-KEYVAULT --name UATIIS01 --value <PASSWORD_FOR_UATIIS01>
az keyvault secret set --vault-name CUS-UAT-KEYVAULT --name UATNAV01 --value <PASSWORD_FOR_UATNAV01>
az keyvault secret set --vault-name CUS-UAT-KEYVAULT --name UATSQL01 --value <PASSWORD_FOR_UATSQL01>
```

1. Grant the Terraform identity Secret Get access (RBAC role "Key Vault Secrets User" or access policy).
1. Set variables (env vars or `terraform.tfvars`):

```powershell
$env:TF_VAR_key_vault_id = "/subscriptions/f830b735-d380-4c43-b54b-73ba9ff8cd9d/resourceGroups/CUS-UAT-KV-RG/providers/Microsoft.KeyVault/vaults/CUS-UAT-KEYVAULT"
$env:TF_VAR_vm_password_secret_names = '{"UATAD01":"UATAD01","UATAD02":"UATAD02","UATMULTI01":"UATMULTI01","UATIIS01":"UATIIS01","UATNAV01":"UATNAV01","UATSQL01":"UATSQL01"}'
```

1. (Optional) Remove or leave blank `admin_password` once all VMs use Key Vault.

### Option B: Single Password Variable (Legacy / Temporary)

Use only if Key Vault not yet configured; all VMs share one password.

```powershell
$env:TF_VAR_admin_password = "YourActualVMPassword"
```

or in `terraform.tfvars`:

```hcl
admin_password = "YourActualVMPassword"
```

## Step 2: Run Import Script

```powershell
./Scripts/import-resources.ps1
```

## Step 3: Verify Import

```bash
terraform state list
terraform plan
```

## What Gets Imported

✅ **2 Resource Groups**

- UATNETRG (Network resources)
- UATSERVERRG (Server resources)

✅ **Network Resources**

- Virtual Network (UATSERVERVNET)
- 3 Subnets (default, bastion, servers)
- Bastion Host + Public IP

✅ **Compute Resources**

- 3 Virtual Machines (UATAD01, UATAD02, UATMULTI01)
- Network Interfaces
- Network Security Groups
- Public IP for UATAD01
- Data disk for UATMULTI01

## Expected Result

After import, `terraform plan` should show:

- "No changes" or minimal differences
- Any changes shown are configuration drift that can be reviewed

## Troubleshooting

**Error: Resource already imported**
→ Safe to ignore, continue

**Plan shows VM replacement**
→ Typically indicates mismatched image or disk config. Password changes alone should be in-place.

**Password not updating (Key Vault)**
→ Verify secret names match VM names and Terraform identity has Secret Get permissions.

**Authentication error**
→ Run `az login` and try again

**Module errors**
→ Run `terraform init` first

---
For complete documentation, see [IMPORT-GUIDE.md](IMPORT-GUIDE.md)
