function Install-RequiredModule {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Name,

        [string]$MinimumVersion,

        [switch]$Import
    )

    # Is the module already available?
    $module = Get-Module -ListAvailable -Name $Name -ErrorAction SilentlyContinue
    if (-not $module) {
        try {
            Write-Host "Installing PowerShell module '$Name' for current user..." -ForegroundColor Cyan

            $params = @{
                Name   = $Name
                Scope  = 'CurrentUser'
                Force  = $true
            }
            if ($MinimumVersion) {
                $params.MinimumVersion = $MinimumVersion
            }

            Install-Module @params -ErrorAction Stop
        }
        catch {
            Write-Host "WARNING: Failed to install module '$Name': $($_.Exception.Message)" -ForegroundColor Yellow
            return
        }
    }

    if ($Import) {
        try {
            Import-Module $Name -ErrorAction Stop
        }
        catch {
            Write-Host "WARNING: Failed to import module '$Name': $($_.Exception.Message)" -ForegroundColor Yellow
        }
    }
}

# ~ to cd $HOME
function ~ { Set-Location $HOME }

# --- Dependencies ---
Install-RequiredModule -Name 'posh-git' -Import
Install-RequiredModule -Name 'Get-ChildItemColor' -Import
Install-RequiredModule -Name 'Terminal-Icons' -Import

function la {
    Get-ChildItemColor -Force | Format-Table -AutoSize
}

# PSReadLine is normally built-in, but this makes sure it's available
if (-not (Get-Module -ListAvailable -Name PSReadLine -ErrorAction SilentlyContinue)) {
    Install-RequiredModule -Name 'PSReadLine'
}

# Oh My Posh prompt
oh-my-posh init pwsh --config "$HOME\dotfiles\shared\oh-my-posh\devops.omp.json" | Invoke-Expression

# PSReadLine (history + suggestions)
if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
}

# Colorized ls
Set-Alias ls Get-ChildItemColor -Option AllScope
Set-Alias ll Get-ChildItemColorFormatWide -Option AllScope

# Kubectl completion + alias
if (Get-Command kubectl -ErrorAction SilentlyContinue) {
    kubectl completion powershell | Out-String | Invoke-Expression
    Set-Alias k kubectl
}

# Aliases
Set-Alias -Name vi -Value vim

# OPTIONAL: zoxide (directory jumping)
# if (Get-Command zoxide -ErrorAction SilentlyContinue) {
#     Invoke-Expression (& { (zoxide init powershell | Out-String) })
# }
