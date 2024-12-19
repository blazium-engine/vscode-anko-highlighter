# Requires PowerShell 5.0+
param (
    [Parameter(Mandatory=$true)]
    [ValidateSet("major", "minor", "patch")]
    [string]$VersionType
)

# Path to package.json
$PackageJsonPath = "./anko/package.json"

# Check if package.json exists
if (-Not (Test-Path -Path $PackageJsonPath)) {
    Write-Error "package.json not found at path: $PackageJsonPath"
    exit 1
}

# Read package.json
$PackageData = Get-Content -Path $PackageJsonPath -Raw | ConvertFrom-Json

# Ensure version field exists
if (-Not $PackageData.version) {
    Write-Error "No version field found in package.json"
    exit 1
}

# Parse version into major, minor, and patch
$VersionParts = $PackageData.version -split '\.'
if ($VersionParts.Count -ne 3) {
    Write-Error "Invalid version format in package.json. Expected format: major.minor.patch"
    exit 1
}

[int]$Major = $VersionParts[0]
[int]$Minor = $VersionParts[1]
[int]$Patch = $VersionParts[2]

# Increment version based on input
switch ($VersionType) {
    "major" {
        $Major++
        $Minor = 0
        $Patch = 0
    }
    "minor" {
        $Minor++
        $Patch = 0
    }
    "patch" {
        $Patch++
    }
}

# Update the version field
$PackageData.version = "$Major.$Minor.$Patch"

# Write updated package.json back to file
$PackageData | ConvertTo-Json -Depth 10 | Set-Content -Path $PackageJsonPath

# Output the new version
Write-Output $PackageData.version
