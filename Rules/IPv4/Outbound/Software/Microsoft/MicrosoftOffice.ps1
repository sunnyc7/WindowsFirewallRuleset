
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
Outbound firewall rules for MicrosoftOffice

.DESCRIPTION
Outbound firewall rules for Microsoft Office software suite

.EXAMPLE
PS> .\MicrosoftOffice.ps1

.INPUTS
None. You cannot pipe objects to MicrosoftOffice.ps1

.OUTPUTS
None. MicrosoftOffice.ps1 does not generate any output

.NOTES
None.
#>

#region Initialization
#Requires -RunAsAdministrator
. $PSScriptRoot\..\..\..\..\..\Config\ProjectSettings.ps1

# Check requirements
Initialize-Project -Abort

# Imports
. $PSScriptRoot\..\..\DirectionSetup.ps1
Import-Module -Name Ruleset.UserInfo

# Setup local variables
$Group = "Microsoft - Office"
$Accept = "Outbound rules for Microsoft Office will be loaded, recommended if Microsoft Office is installed to let it access to network"
$Deny = "Skip operation, outbound rules for Microsoft Office will not be loaded into firewall"

# User prompt
Update-Context "IPv$IPVersion" $Direction $Group
if (!(Approve-Execute -Accept $Accept -Deny $Deny)) { exit }
#endregion

# First remove all existing rules matching group
Remove-NetFirewallRule -PolicyStore $PolicyStore -Group $Group -Direction $Direction -ErrorAction Ignore

#
# Office installation directories
#
$OfficeRoot = "%ProgramFiles%\Microsoft Office\root\Office16"
$OfficeShared = "%ProgramFiles%\Common Files\microsoft shared"

#
# Microsoft office rules
#

# Test if installation exists on system
if ((Confirm-Installation "MicrosoftOffice" ([ref] $OfficeRoot)) -or $ForceLoad)
{
	$Program = "$OfficeRoot\MSACCESS.EXE"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Access" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "" | Format-Output

	# Clicktorun.exe starts downloading the most recent version of itself.
	# After finishing the download Clicktorun.exe starts THE DOWNLOADED Version which then downloads the new office version.
	# For some odd reason the downloaded clicktorun wants to communicate with ms servers directly completely ignoring the proxy.
	# https://www.reddit.com/r/sysadmin/comments/7hync7/updating_office_2016_hb_click_to_run_through/
	# TL;DR: netsh winhttp set proxy proxy-server="fubar" bypass-list="<local>"
	$Program = "$OfficeShared\ClickToRun\OfficeClickToRun.exe"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Click to Run" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $LocalSystem `
		-Description "Required for updates to work. Click-to-Run is an alternative to the traditional Windows Installer-based (MSI) method
	of installing and updating Office, that utilizes streaming and virtualization technology
	to reduce the time required to install Office and help run multiple versions of Office on the same computer." | Format-Output

	$Program = "$OfficeShared\ClickToRun\OfficeC2RClient.exe"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "ClickC2RClient" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 443 `
		-LocalUser $LocalSystem `
		-Description "Allows users to check for and install updates for Office on demand." | Format-Output

	$Program = "$OfficeRoot\MSOSYNC.EXE"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Document Cache" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Block -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "The Office Document Cache is a concept used in Microsoft Office Upload Center
	to give you a way to see the state of files you are uploading to a SharePoint server. " | Format-Output

	$Program = "$OfficeRoot\EXCEL.EXE"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Excel" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "" | Format-Output

	$Program = "$OfficeRoot\ADDINS\Microsoft Power Query for Excel Integrated\bin\Microsoft.Mashup.Container.NetFX40.exe"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Excel (Mashup Container)" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "Used to query data from web in excel." | Format-Output

	$Program = "$OfficeRoot\CLVIEW.EXE"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Help" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "" | Format-Output

	$Program = "$OfficeRoot\OUTLOOK.EXE"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Outlook (HTTP/S)" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "" | Format-Output

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Outlook (IMAP SSL)" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 993 `
		-LocalUser $UsersGroupSDDL `
		-Description "Incoming mail server over SSL." | Format-Output

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Outlook (IMAP)" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 143 `
		-LocalUser $UsersGroupSDDL `
		-Description "Incoming mail server." | Format-Output

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Outlook (POP3 SSL)" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 110 `
		-LocalUser $UsersGroupSDDL `
		-Description "Incoming mail server over SSL." | Format-Output

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Outlook (POP3)" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 995 `
		-LocalUser $UsersGroupSDDL `
		-Description "Incoming mail server." | Format-Output

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Outlook (SMTP)" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 25 `
		-LocalUser $UsersGroupSDDL `
		-Description "Outgoing mail server." | Format-Output

	$Program = "$OfficeRoot\POWERPNT.EXE"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "PowerPoint" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "" | Format-Output

	$Program = "$OfficeRoot\WINPROJ.EXE"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Project" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "" | Format-Output

	$Program = "$OfficeRoot\MSPUB.EXE"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Publisher" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "" | Format-Output

	# NOTE: If you load office rules soon after it has been installed sdxhelper may be missing
	# reload again later when it appears
	$Program = "$OfficeRoot\SDXHelper.exe"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "sdxhelper" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "this executable is used when later Office versions are installed in parallel with an earlier version so that they can peacefully coexist." | Format-Output

	$Program = "$OfficeRoot\lync.exe"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Skype for business" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443, 33033 `
		-LocalUser $UsersGroupSDDL `
		-Description "Skype for business, previously lync." | Format-Output

	$Program = "$OfficeRoot\msoia.exe"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Telemetry Agent" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Block -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "The telemetry agent collects several types of telemetry data for Office.
	https://docs.microsoft.com/en-us/deployoffice/compat/data-that-the-telemetry-agent-collects-in-office" | Format-Output

	# TODO: Visio and Project are not part of office by default
	$Program = "$OfficeRoot\VISIO.EXE"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Visio" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "" | Format-Output

	$Program = "$OfficeRoot\WINWORD.EXE"
	Test-ExecutableFile $Program

	New-NetFirewallRule -Platform $Platform `
		-DisplayName "Word" -Service Any -Program $Program `
		-PolicyStore $PolicyStore -Enabled True -Action Allow -Group $Group -Profile $DefaultProfile -InterfaceType $DefaultInterface `
		-Direction $Direction -Protocol TCP -LocalAddress Any -RemoteAddress Internet4 -LocalPort Any -RemotePort 80, 443 `
		-LocalUser $UsersGroupSDDL `
		-Description "" | Format-Output
}

Update-Log
