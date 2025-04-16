# Checkmk monitoring script in PowerShell

# Error handling function
function Write-ErrorAndExit {
    param (
        [string]$Message
    )
    Write-Error $Message
    exit 1
}

# Check if smartctl is installed
if (-not (Get-Command smartctl -ErrorAction SilentlyContinue)) {
    Write-ErrorAndExit "ERROR: smartctl not found"
}

# Check smartctl version
$smartctlVersion = smartctl -V
if ($smartctlVersion -notmatch '^smartctl 7') {
    Write-ErrorAndExit "ERROR: smartctl version 7 or newer is required"
}

# Output for smart_posix_all
Write-Host "<<<smart_posix_all:sep(0)>>>"
$devices = smartctl --scan | ForEach-Object { $_.Split("#")[0].Trim() }

foreach ($device in $devices) {
    smartctl --all --json=c $device
    Write-Host ""
}

# Output for smart_posix_scan_arg
Write-Host "<<<smart_posix_scan_arg:sep(0)>>>"
$deviceArgs = smartctl --scan | ForEach-Object { $_.Split("#")[0].Trim() }

foreach ($deviceArg in $deviceArgs) {
    # Run smartctl with the extracted device information
    smartctl --all --json=c $deviceArg
    Write-Host ""
}

