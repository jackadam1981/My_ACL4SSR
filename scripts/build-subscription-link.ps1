<#
.SYNOPSIS
  Print a subconverter-style Clash subscription URL (my_rules.ini + airport sub).

.PARAMETER SubscriptionUrl
  Your airport / node subscription URL (plain text, not Base64).

.PARAMETER ConverterBase
  Public subconverter host (no trailing slash). Change if your API differs.
#>
param(
  [Parameter(Mandatory = $true)]
  [string]$SubscriptionUrl,

  [string]$ConverterBase = "https://api.dler.io"
)

$ErrorActionPreference = "Stop"
$configIni = "https://raw.githubusercontent.com/jackadam1981/My_ACL4SSR/main/my_rules.ini"
$b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($SubscriptionUrl))
$urlParam = [uri]::EscapeDataString($b64)
$configParam = [uri]::EscapeDataString($configIni)
$q = "target=clash&new_name=true&insert=false&url=$urlParam&config=$configParam"
$full = "$ConverterBase/sub`?$q"
Write-Host "Paste this as subscription URL (or verify your converter supports config=):" -ForegroundColor Green
Write-Host $full
Write-Host ""
Write-Host "If your API uses a different param than config=, replace per that service docs." -ForegroundColor Yellow
