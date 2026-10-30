<#
.SYNOPSIS
    Start, stop, inspect, or screenshot the VetTV MCE test VM.

.DESCRIPTION
    Wraps VirtualBox's VBoxManage for the Phase 0/1 test VM. The blueprint
    targets Hyper-V on Windows 11 Pro; VirtualBox 7 is the documented
    fallback and is what this host currently uses (Hyper-V role not yet
    enabled — enabling it needs an elevated shell and a reboot).

    Every action is safe to re-run. Stop uses ACPI power button and waits
    for poweroff; it never hard-powers-off a running guest.

.PARAMETER Action
    Status (default), Start, Stop, or Screenshot.

.PARAMETER VmName
    VirtualBox VM name. Default: VetTV-MCE-Phase0.

.PARAMETER ScreenshotPath
    Where Screenshot writes the PNG. Default: build-output\boot.png
    next to this repo.

.EXAMPLE
    .\scripts\boot-vm.ps1 -Action Start
    .\scripts\boot-vm.ps1 -Action Screenshot -ScreenshotPath C:\tmp\boot.png
#>
[CmdletBinding()]
param(
    [ValidateSet('Status', 'Start', 'Stop', 'Screenshot')]
    [string]$Action = 'Status',
    [string]$VmName = 'VetTV-MCE-Phase0',
    [string]$ScreenshotPath = (Join-Path $PSScriptRoot '..\build-output\boot.png'),
    [string]$VBoxManagePath = 'C:\Program Files\Oracle\VirtualBox\VBoxManage.exe'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $VBoxManagePath)) {
    throw "VBoxManage not found at $VBoxManagePath. Install VirtualBox 7 or pass -VBoxManagePath."
}

function Get-VmState {
    $line = & $VBoxManagePath showvminfo $VmName --machinereadable |
        Select-String '^VMState='
    if (-not $line) { throw "VM '$VmName' not found." }
    return ($line.ToString() -replace '^VMState="?', '' -replace '"$', '')
}

switch ($Action) {
    'Status' {
        Write-Host "$VmName : $(Get-VmState)"
    }
    'Start' {
        if ((Get-VmState) -eq 'running') {
            Write-Host "$VmName is already running."
            break
        }
        & $VBoxManagePath startvm $VmName --type headless
    }
    'Stop' {
        if ((Get-VmState) -ne 'running') {
            Write-Host "$VmName is not running."
            break
        }
        & $VBoxManagePath controlvm $VmName acpipowerbutton
        foreach ($i in 1..24) {
            Start-Sleep -Seconds 5
            if ((Get-VmState) -eq 'poweroff') {
                Write-Host "$VmName powered off."
                return
            }
        }
        throw "$VmName did not power off within 120s. Left running; investigate before forcing."
    }
    'Screenshot' {
        if ((Get-VmState) -ne 'running') {
            throw "$VmName is not running; start it first."
        }
        $dir = Split-Path -Parent $ScreenshotPath
        if ($dir) { New-Item -ItemType Directory -Force $dir | Out-Null }
        & $VBoxManagePath controlvm $VmName screenshotpng $ScreenshotPath
        Write-Host "Screenshot written to $ScreenshotPath"
    }
}
