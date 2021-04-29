Additional Managed Identities Lab


If interested, 

Key vault commands

```powershell
Get-AzKeyVaultSecret -VaultName cvaz0221x2kv -Name cemo


$secret = Get-AzKeyVaultSecret -VaultName cvaz0221x2kv -Name cemo
$ssPtr = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secret.SecretValue)
try {
   $secretValueText = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($ssPtr)
} finally {
   [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ssPtr)
}
Write-Output $secretValueText
```






Generic start

```powershell

 $secret = Get-AzKeyVaultSecret -VaultName "<your-unique-keyvault-name>" -Name "<your secret name>"

```
