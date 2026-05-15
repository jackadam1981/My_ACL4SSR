<#
.SYNOPSIS
  Print a subconverter-style Clash subscription URL (rules ini + airport sub).

.PARAMETER ConfigIni
  Raw URL to my_rules.ini or my_rules_netflix.ini (default: my_rules.ini).

.PARAMETER SubscriptionUrl
  Your airport / node subscription URL (plain text, not Base64).

.PARAMETER ConverterBase
  Public subconverter host (no trailing slash). Change if your API differs.
#>
param(
  [Parameter(Mandatory = $true)]
  [string]$SubscriptionUrl,

  [string]$ConverterBase = "https://api.dler.io",

  [string]$ConfigIni = "https://raw.githubusercontent.com/jackadam1981/My_ACL4SSR/main/my_rules.ini"
)

$ErrorActionPreference = "Stop"
$configIni = $ConfigIni
$b64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($SubscriptionUrl))
$urlParam = [uri]::EscapeDataString($b64)
$configParam = [uri]::EscapeDataString($configIni)
$q = "target=clash&new_name=true&insert=false&url=$urlParam&config=$configParam"
$full = "$ConverterBase/sub`?$q"
Write-Host "Paste this as subscription URL (or verify your converter supports config=):" -ForegroundColor Green
Write-Host $full
Write-Host ""
Write-Host "If your API uses a different param than config=, replace per that service docs." -ForegroundColor Yellow
