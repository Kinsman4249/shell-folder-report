## Changelog

This file tracks real changes to this repository. For the rules on how entries
here should be written, see the changelog formatting guide in
Kinsman4249/.github-private.

### Initial script and templates (round one)

1. Added Get-ShellFolders.ps1, a PowerShell 5.1 script that reports the real
   filesystem path of each per-user Windows shell folder (Desktop, Documents,
   Downloads, Pictures, Music, Videos). The script reads the User Shell Folders
   registry key for configured or redirected paths, falls back to the Shell Folders
   key when a value is blank, and expands any %VAR% tokens by echoing them through
   cmd. It runs entirely in the current user context against HKCU and needs no
   administrator rights. Verified against a profile with OneDrive Known Folder Move
   active, where both redirected and non-redirected folders were reported correctly.
2. Added the project README describing what the script does, how to run it, the two
   registry keys it reads, and the known gotchas (current-user-only scope, blank
   values meaning not redirected, and the required spacing in the registry value
   names).
3. Added the community-health files copied from Kinsman4249/.github-private: Code of
   Conduct, Contributing guide, Security policy, bug report and feature request issue
   templates, and the pull request template. Placeholders for project name and
   repository URL were filled in for this repository.
