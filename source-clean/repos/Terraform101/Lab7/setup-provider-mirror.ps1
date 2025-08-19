# Download azapi provider and create a local filesystem mirror, then run terraform init using the local mirror
param()

$ErrorActionPreference = 'Stop'
$P = Split-Path -Parent $MyInvocation.MyCommand.Definition
Write-Host "Working dir: $P"

$mirrorRoot = "C:\terraform-mirror-synth"
$namespace = "azure-synth"
$name = "azapi-synth"
$version = "0.0.0-synth"
$osarch = "windows_amd64"

$providerUrl = "https://github.com/$namespace/terraform-provider-$name/releases/download/v$version/terraform-provider-$name_$version_$osarch.zip"
$tmpZip = Join-Path $env:TEMP "${name}_${version}.zip"

Write-Host "Querying GitHub release API for v$version assets"
$apiUrl = "https://api.github.com/repos/$namespace/terraform-provider-$name/releases/tags/v$version"
try {
    $apiResp = Invoke-RestMethod -Uri $apiUrl -Headers @{ 'User-Agent' = 'TerraformMirrorScript' } -ErrorAction Stop
}
catch {
    Write-Host "Failed to query GitHub API: $($_.Exception.Message)"
    throw
}

# Find a matching asset for OS/arch
$asset = $apiResp.assets | Where-Object { $_.name -match "$name.*$version.*windows.*amd64" } | Select-Object -First 1
if (-not $asset) {
    Write-Host "Could not find a windows_amd64 asset in release assets. Listing available assets:";
    $apiResp.assets | ForEach-Object { Write-Host " - $($_.name)" }
    throw "No suitable asset found for windows_amd64"
}

$downloadUrl = $asset.browser_download_url
Write-Host "Found asset: $($asset.name) -> $downloadUrl"
Write-Host "Downloading $downloadUrl to $tmpZip"
try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tmpZip -UseBasicParsing -Headers @{ 'User-Agent' = 'TerraformMirrorScript' } -ErrorAction Stop
}
catch {
    Write-Host "Download failed: $($_.Exception.Message)"
    throw
}

Write-Host "Creating mirror directory"
$destDir = Join-Path $mirrorRoot "registry.terraform.io\$namespace\$name\$version\$osarch"
New-Item -ItemType Directory -Path $destDir -Force | Out-Null

Write-Host "Extracting $tmpZip to $destDir"
Expand-Archive -LiteralPath $tmpZip -DestinationPath $destDir -Force

Write-Host "Cleaning temporary file"
Remove-Item -Path $tmpZip -Force

# Create terraform.rc in script directory (we'll use it via TF_CLI_CONFIG_FILE)
$terraformRcPath = Join-Path $P "terraform.rc"
$rcContent = @"
provider_installation {
    filesystem_mirror {
        path    = "C:\\terraform-mirror-synth"
    }
    direct {}
}
"@
Set-Content -Path $terraformRcPath -Value $rcContent -Encoding UTF8

Write-Host "Wrote terraform.rc at $terraformRcPath"

# Run terraform init with TF_CLI_CONFIG_FILE pointing to our terraform.rc
Write-Host "Running terraform init using local mirror..."
$env:TF_CLI_CONFIG_FILE = $terraformRcPath
# disable http2 for the process
$env:GODEBUG = "http2client=0"
# force TLS1.2 for .NET parts (best-effort)
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Push-Location $P
try {
    terraform init -no-color -upgrade
}
finally {
    Pop-Location
}

Write-Host "Done. If init succeeded, provider was installed from local mirror."
