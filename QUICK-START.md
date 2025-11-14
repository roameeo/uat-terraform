# Quick Start - Import UAT Resources

## Step 1: Set Admin Password
Choose one method:

### Method A: Environment Variable (Recommended)
```powershell
$env:TF_VAR_admin_password = "YourActualVMPassword"
```

### Method B: Add to terraform.tfvars
```hcl
admin_password = "YourActualVMPassword"
```

## Step 2: Run Import Script
```powershell
.\Scripts\import-resources.ps1
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
→ admin_password doesn't match actual password

**Authentication error**
→ Run `az login` and try again

**Module errors**
→ Run `terraform init` first

---
For complete documentation, see [IMPORT-GUIDE.md](IMPORT-GUIDE.md)
