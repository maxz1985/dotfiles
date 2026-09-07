#requires -version 5.1
#requires -RunAsAdministrator

[CmdletBinding()]
param(
    [switch]$SkipOffice,
    [switch]$SkipNgen,
    [switch]$SkipCleanup,
    [switch]$OpenWindowsUpdate,
    [switch]$OpenStore
)

$ErrorActionPreference = 'Continue'

$LogDirectory = Join-Path $env:ProgramData 'WindowsMaintenance'
$LogFile = Join-Path $LogDirectory (
    'Maintenance-{0:yyyyMMdd-HHmmss}.log' -f (Get-Date)
)

New-Item -ItemType Directory -Path $LogDirectory -Force | Out-Null
Start-Transcript -Path $LogFile

function Write-Step {
    param([string]$Message)

    Write-Host
    Write-Host ('=' * 70) -ForegroundColor Cyan
    Write-Host $Message -ForegroundColor Cyan
    Write-Host ('=' * 70) -ForegroundColor Cyan
}

function Test-PendingReboot {

    $rebootPending = $false

    $paths = @(
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending',
        'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired'
    )

    foreach ($path in $paths) {
        if (Test-Path $path) {
            $rebootPending = $true
        }
    }

    $sessionManager =
        'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'

    try {
        $pendingRename = Get-ItemProperty `
            -Path $sessionManager `
            -Name PendingFileRenameOperations `
            -ErrorAction Stop

        if ($pendingRename.PendingFileRenameOperations) {
            $rebootPending = $true
        }
    }
    catch {
        # Value does not exist -- normal.
    }

    return $rebootPending
}

try {

    #
    # 1. Initial reboot state
    #

    Write-Step 'Checking reboot status'

    $InitialRebootPending = Test-PendingReboot

    if ($InitialRebootPending) {
        Write-Warning 'A reboot is already pending.'
    }
    else {
        Write-Host 'No reboot is currently pending.' -ForegroundColor Green
    }


    #
    # 2. Refresh WinGet sources
    #

    Write-Step 'Refreshing WinGet sources'

    if (Get-Command winget.exe -ErrorAction SilentlyContinue) {

        & winget.exe source update

        Write-Step 'Available WinGet updates'

        & winget.exe upgrade `
            --accept-source-agreements

        Write-Step 'Installing WinGet updates'

        & winget.exe upgrade `
            --all `
            --include-unknown `
            --accept-source-agreements `
            --accept-package-agreements

    }
    else {
        Write-Warning 'WinGet was not found.'
    }


    #
    # 3. Microsoft Office Click-to-Run
    #

    if (-not $SkipOffice) {

        Write-Step 'Checking Microsoft Office Click-to-Run'

        $OfficeUpdaterPaths = @(
            "$env:ProgramFiles\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe",
            "${env:ProgramFiles(x86)}\Common Files\Microsoft Shared\ClickToRun\OfficeC2RClient.exe"
        )

        $OfficeUpdater = $OfficeUpdaterPaths |
            Where-Object { Test-Path $_ } |
            Select-Object -First 1

        if ($OfficeUpdater) {

            Write-Host "Office updater found:"
            Write-Host $OfficeUpdater

            Write-Host 'Starting Office update...'

            & $OfficeUpdater `
                /update user `
                displaylevel=false `
                forceappshutdown=false
        }
        else {
            Write-Host 'Office Click-to-Run installation not found.'
        }
    }


    #
    # 4. .NET Framework NGEN
    #

    if (-not $SkipNgen) {

        Write-Step '.NET Framework native image generation'

        $NgenPaths = @(
            "$env:WINDIR\Microsoft.NET\Framework64\v4.0.30319\ngen.exe",
            "$env:WINDIR\Microsoft.NET\Framework\v4.0.30319\ngen.exe"
        )

        foreach ($Ngen in $NgenPaths) {

            if (Test-Path $Ngen) {

                Write-Host
                Write-Host "Processing:"
                Write-Host $Ngen

                #
                # Find assemblies whose native images became invalid.
                #
                & $Ngen update /queue

                #
                # Immediately process everything in the queue rather
                # than waiting for the scheduled maintenance task.
                #
                & $Ngen executeQueuedItems
            }
        }
    }


    #
    # 5. Windows component cleanup
    #

    if (-not $SkipCleanup) {

        Write-Step 'Cleaning Windows component store'

        & DISM.exe `
            /Online `
            /Cleanup-Image `
            /StartComponentCleanup
    }


    #
    # 6. Final WinGet check
    #

    Write-Step 'Final WinGet update check'

    if (Get-Command winget.exe -ErrorAction SilentlyContinue) {

        & winget.exe upgrade `
            --accept-source-agreements
    }


    #
    # 7. Final reboot check
    #

    Write-Step 'Final reboot status'

    $FinalRebootPending = Test-PendingReboot

    if ($FinalRebootPending) {
        Write-Warning 'Windows reports that a reboot is pending.'
    }
    else {
        Write-Host 'No reboot is currently pending.' -ForegroundColor Green
    }


    #
    # 8. Things Windows does not cleanly expose for automation
    #

    if ($OpenWindowsUpdate) {

        Write-Step 'Opening Windows Update'

        Start-Process 'ms-settings:windowsupdate'
    }

    if ($OpenStore) {

        Write-Step 'Opening Microsoft Store updates'

        Start-Process 'ms-windows-store://downloadsandupdates'
    }


    Write-Step 'Maintenance complete'

    Write-Host "Log:"
    Write-Host $LogFile
}
finally {

    Stop-Transcript
}