## shell-folder-report

PowerShell 5.1 script that reports the real filesystem paths of the current user's
Windows shell folders (Desktop, Documents, Downloads, Pictures, Music, Videos).
Useful for spotting OneDrive Known Folder Move redirection, network-share
redirection, or manually moved folders that no longer sit under
C:\Users\<name>\<folder>.

### Why

When Desktop, Documents, and Pictures are redirected (commonly by OneDrive Known
Folder Move) the target paths are not obvious from Explorer alone. This script
reads the per-user shell folder registry keys and prints exactly where each folder
points, so you can confirm redirection state during migrations, backup planning, or
troubleshooting.

### Requirements

- Windows
- PowerShell 5.1 (Windows PowerShell)
- Runs as the signed-in user (reads HKCU). No admin rights needed.

### Usage

    powershell -ExecutionPolicy Bypass -File .\Get-ShellFolders.ps1

Example output:

    Folder    Path
    ------    ----
    Desktop   C:\Users\<name>\OneDrive - Contoso\Desktop
    Documents C:\Users\<name>\OneDrive - Contoso\Documents
    Downloads C:\Users\<name>\Downloads
    Pictures  C:\Users\<name>\OneDrive - Contoso\Pictures
    Music     C:\Users\<name>\Music
    Videos    C:\Users\<name>\Videos

### How it works

Two registry keys are read:

- User Shell Folders - configured/redirected paths. Values may contain environment
  variables or be blank. Blank means the folder is not redirected.
- Shell Folders - resolved absolute paths, used as a fallback when the value above
  is blank.

For each folder the script prefers the configured value and falls back to the
resolved value, then expands any %VAR% tokens.

### Notes and gotchas

- Runs only against the current user. To report another user you would load their
  hive (reg load) and repoint the script at that hive.
- A blank value in User Shell Folders is expected for non-redirected folders and is
  not an error.
- The registry value names use spaces (My Pictures, My Music, My Video). That exact
  spelling is required.

### License

See LICENSE.
