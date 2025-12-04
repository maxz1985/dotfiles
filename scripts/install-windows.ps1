$allUsersProfile = $PROFILE.CurrentUserAllHosts
$targetProfile   = "$HOME\dotfiles\windows\powershell\profile.ps1"

# Ensure directory exists
$dir = Split-Path $allUsersProfile
New-Item -ItemType Directory -Force -Path $dir | Out-Null

# Write a bridge loader
$bridge = ". `"$targetProfile`""

Set-Content -Path $allUsersProfile -Value $bridge -Force

Write-Host "Installed PowerShell AllUsersAllHosts profile loader." -ForegroundColor Green
Write-Host "Profile points to: $targetProfile"
