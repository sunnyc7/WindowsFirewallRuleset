
<#
MIT License

This file is part of "Windows Firewall Ruleset" project
Homepage: https://github.com/metablaster/WindowsFirewallRuleset

Copyright (C) 2019-2021 metablaster zebal@protonmail.ch

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
#>

<#
.SYNOPSIS
Inbound firewall rules forfirewall rules for Windows services

.DESCRIPTION
Windows services rules
Rules which apply to Windows services which are not handled by predefined rules

.PARAMETER Force
If specified, no prompt to run script is shown.

.PARAMETER Trusted
If specified, rules will be loaded for executables with missing or invalid digital signature.
By default an error is generated and rule isn't loaded.

.EXAMPLE
PS> .\WindowsServices.ps1

.INPUTS
None. You cannot pipe objects to WindowsServices.ps1

.OUTPUTS
None. WindowsServices.ps1 does not generate any output

.NOTES
None.
#>

#Requires -Version 5.1
#Requires -RunAsAdministrator

[CmdletBinding()]
param (
	[Parameter()]
	[switch] $Trusted,

	[Parameter()]
	[switch] $Force
)

#region Initialization
. $PSScriptRoot\..\..\..\Config\ProjectSettings.ps1 $PSCmdlet
. $PSScriptRoot\DirectionSetup.ps1

Initialize-Project -Strict
Import-Module -Name Ruleset.UserInfo

# Setup local variables
$Group = "Windows Services"
$Accept = "Inbound rules for system services will be loaded, required for proper functioning of operating system"
$Deny = "Skip operation, inbound rules for system services will not be loaded into firewall"

if (!(Approve-Execute -Accept $Accept -Deny $Deny -ContextLeaf $Group -Force:$Force)) { exit }
$PSDefaultParameterValues["Test-ExecutableFile:Force"] = $Trusted -or $SkipSignatureCheck
#endregion

# First remove all existing rules matching group
Remove-NetFirewallRule -PolicyStore $PolicyStore -Group $Group -Direction $Direction -ErrorAction Ignore

#
# Delivery Optimization predefined rules
#

New-NetFirewallRule -DisplayName "Delivery Optimization" `
	-Platform $Platform -PolicyStore $PolicyStore -Profile Private, Domain `
	-Service DoSvc -Program $ServiceHost -Group $Group `
	-Enabled True -Action Allow -Direction $Direction -Protocol TCP `
	-LocalAddress Any -RemoteAddress LocalSubnet4 `
	-LocalPort 7680 -RemotePort Any `
	-LocalUser Any -EdgeTraversalPolicy Allow `
	-InterfaceType $DefaultInterface `
	-Description "Service responsible for delivery optimization.
Windows Update Delivery Optimization works by letting you get Windows updates and Microsoft Store
apps from sources in addition to Microsoft,
like other PCs on your local network, or PCs on the Internet that are downloading the same files.
Delivery Optimization also sends updates and apps from your PC to other PCs on your local network or
PCs on the Internet, based on your settings." | Format-Output

New-NetFirewallRule -DisplayName "Delivery Optimization" `
	-Platform $Platform -PolicyStore $PolicyStore -Profile Private, Domain `
	-Service DoSvc -Program $ServiceHost -Group $Group `
	-Enabled True -Action Allow -Direction $Direction -Protocol UDP `
	-LocalAddress Any -RemoteAddress LocalSubnet4 `
	-LocalPort 7680 -RemotePort Any `
	-LocalUser Any -EdgeTraversalPolicy Allow `
	-InterfaceType $DefaultInterface `
	-LocalOnlyMapping $false -LooseSourceMapping $false `
	-Description "Service responsible for delivery optimization.
Windows Update Delivery Optimization works by letting you get Windows updates and Microsoft Store
apps from sources in addition to Microsoft,
like other PCs on your local network, or PCs on the Internet that are downloading the same files.
Delivery Optimization also sends updates and apps from your PC to other PCs on your local network
or PCs on the Internet, based on your settings." | Format-Output

#
# @FirewallAPI.dll,-80204 predefined rule
#

New-NetFirewallRule -DisplayName "Windows Camera Frame Server" `
	-Platform $Platform -PolicyStore $PolicyStore -Profile Private, Public `
	-Service FrameServer -Program $ServiceHost -Group $Group `
	-Enabled False -Action Allow -Direction $Direction -Protocol TCP `
	-LocalAddress Any -RemoteAddress LocalSubnet4 `
	-LocalPort 554, 8554-8558 -RemotePort Any `
	-LocalUser Any -EdgeTraversalPolicy Block `
	-InterfaceType $DefaultInterface `
	-Description "Service enables multiple clients to access video frames from camera devices." |
Format-Output

New-NetFirewallRule -DisplayName "Windows Camera Frame Server" `
	-Platform $Platform -PolicyStore $PolicyStore -Profile Private, Public `
	-Service FrameServer -Program $ServiceHost -Group $Group `
	-Enabled False -Action Allow -Direction $Direction -Protocol UDP `
	-LocalAddress Any -RemoteAddress LocalSubnet4 `
	-LocalPort 5000-5020 -RemotePort Any `
	-LocalUser Any -EdgeTraversalPolicy Block `
	-InterfaceType $DefaultInterface `
	-LocalOnlyMapping $false -LooseSourceMapping $false `
	-Description "Service enables multiple clients to access video frames from camera devices." |
Format-Output

if ($UpdateGPO)
{
	Invoke-Process gpupdate.exe -NoNewWindow -ArgumentList "/target:computer"
}

Update-Log
