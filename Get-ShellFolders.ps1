#Requires -Version 5.1
<#
.SYNOPSIS
    Reports the real filesystem paths of the current user's Windows shell folders.
.DESCRIPTION
    Reads the per-user shell folder registry keys and prints where each well-known
    folder (Desktop, Documents, Downloads, Pictures, Music, Videos) actually points.
    This reveals redirection to OneDrive Known Folder Move, network shares, or other
    non-default locations that differ from C:\Users\<name>\<folder>.

    Two registry keys are consulted:
      User Shell Folders - configured/redirected paths (may contain env vars or be blank)
      Shell Folders      - resolved absolute paths (used as a fallback when the above is blank)
.NOTES
    PowerShell 5.1. Runs in the context of the current user (HKCU). No admin rights needed.
#>

# Configured/redirected paths. Values here may contain environment variables or be blank.
$usf = Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders'

# Resolved absolute paths. Used as a fallback when the matching value above is blank.
$sf  = Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders'

# Friendly label -> registry value name. Note the spaces in 'My Pictures' etc:
# that exact spelling is what the registry uses.
$map = [ordered]@{
    Desktop   = 'Desktop'
    Documents = 'Personal'
    Downloads = '{374DE290-123F-4565-9164-39C4925E467B}'
    Pictures  = 'My Pictures'
    Music     = 'My Music'
    Videos    = 'My Video'
}

# Walk the map and emit one object per folder.
foreach ($k in $map.Keys) {
    $name = $map[$k]
    $val  = $usf.$name
    # -not catches both null and empty string without calling a static method.
    if (-not $val) { $val = $sf.$name }
    # Expand any %VAR% tokens by letting cmd echo them. Only runs when a % is present.
    if ($val -match '%') { $val = (cmd /c "echo $val") }
    [PSCustomObject]@{ Folder = $k; Path = $val }
}
