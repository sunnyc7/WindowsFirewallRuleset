
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
Outbound firewall rules for WindowsSDK

.DESCRIPTION
Outbound firewall rules for Windows SDK

.PARAMETER Force
If specified, no prompt to run script is shown.

.PARAMETER Trusted
If specified, rules will be loaded for executables with missing or invalid digital signature.
By default an error is generated and rule isn't loaded.

.EXAMPLE
PS> .\WindowsSDK.ps1

.INPUTS
None. You cannot pipe objects to WindowsSDK.ps1

.OUTPUTS
None. WindowsSDK.ps1 does not generate any output

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
. $PSScriptRoot\..\..\..\..\..\Config\ProjectSettings.ps1 $PSCmdlet
. $PSScriptRoot\..\..\DirectionSetup.ps1

Initialize-Project -Strict
Import-Module -Name Ruleset.UserInfo

# Setup local variables
$Group = "Development - Microsoft Windows SDK"
$Accept = "Outbound rules for Microsoft Windows SDK will be loaded, recommended if Microsoft Windows SDK is installed to let it access to network"
$Deny = "Skip operation, outbound rules for Microsoft Windows SDK will not be loaded into firewall"

if (!(Approve-Execute -Accept $Accept -Deny $Deny -ContextLeaf $Group -Force:$Force)) { exit }
$PSDefaultParameterValues["Test-ExecutableFile:Force"] = $Trusted -or $SkipSignatureCheck
#endregion

# First remove all existing rules matching group
Remove-NetFirewallRule -PolicyStore $PolicyStore -Group $Group -Direction $Direction -ErrorAction Ignore

#
# Windows SDK installation directories
#
$SDKDebuggers = "Unknown Directory"

#
# Rules for Windows SDK
#

# Test if installation exists on system
if ((Confirm-Installation "WindowsKits" ([ref] $SDKDebuggers)) -or $ForceLoad)
{
	$Program = "$SDKDebuggers\x86\windbg.exe"
	if (Test-ExecutableFile $Program)
	{
		New-NetFirewallRule -Platform $Platform `
			-DisplayName "WinDbg Symbol Server x86" -Service Any -Program $Program `
			-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
			-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
			-LocalUser $UsersGroupSDDL `
			-Description "WinDbg access to Symbols Server." | Format-Output
	}

	$Program = "$SDKDebuggers\x64\windbg.exe"
	if (Test-ExecutableFile $Program)
	{
		New-NetFirewallRule -Platform $Platform `
			-DisplayName "WinDbg Symbol Server x64" -Service Any -Program $Program `
			-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
			-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
			-LocalUser $UsersGroupSDDL `
			-Description "WinDbg access to Symbols Server" | Format-Output
	}

	$Program = "$SDKDebuggers\x86\symchk.exe"
	if (Test-ExecutableFile $Program)
	{
		New-NetFirewallRule -Platform $Platform `
			-DisplayName "Symchk Symbol Server x86" -Service Any -Program $Program `
			-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
			-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 443 `
			-LocalUser $UsersGroupSDDL `
			-Description "WinDbg Symchk access to Symbols Server." | Format-Output
	}

	$Program = "$SDKDebuggers\x64\symchk.exe"
	if (Test-ExecutableFile $Program)
	{
		New-NetFirewallRule -Platform $Platform `
			-DisplayName "Symchk Symbol Server x64" -Service Any -Program $Program `
			-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
			-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 443 `
			-LocalUser $UsersGroupSDDL `
			-Description "WinDbg Symchk access to Symbols Server" | Format-Output
	}
}

if ($UpdateGPO)
{
	Invoke-Process gpupdate.exe -NoNewWindow -ArgumentList "/target:computer"
}

Update-Log
