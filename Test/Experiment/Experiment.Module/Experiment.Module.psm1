
<#
MIT License

This file is part of "Windows Firewall Ruleset" project
Homepage: https://github.com/metablaster/WindowsFirewallRuleset

Copyright (C) 2020, 2021 metablaster zebal@protonmail.ch

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

# Initialization
New-Variable -Name ThisModule -Scope Script -Option ReadOnly -Value (Split-Path $PSScriptRoot -Leaf)

# Imports
. $PSScriptRoot\..\..\..\Config\ProjectSettings.ps1 -InModule
. $ProjectRoot\Modules\ModulePreferences.ps1

#
# Script imports
#

$ScriptsToProcess = @(
)

foreach ($Script in $ScriptsToProcess)
{
	Write-Debug -Message "[$ThisModule] Importing script: Scripts\$Script.ps1"
	. "$PSScriptRoot\Scripts\$Script.ps1"
}

$PrivateScripts = @(
)

foreach ($Script in $PrivateScripts)
{
	Write-Debug -Message "[$ThisModule] Importing script: Private\$Script.ps1"
	. "$PSScriptRoot\Private\$Script.ps1"
}

$PublicScripts = @(
	"Test-Function"
)

foreach ($Script in $PublicScripts)
{
	Write-Debug -Message "[$ThisModule] Importing script: Public\$Script.ps1"
	. "$PSScriptRoot\Public\$Script.ps1"
}

#
# Module variables
#

Write-Debug -Message "[$ThisModule] Initializing module variables"

# Template variable
New-Variable -Name ModuleVariable -Scope Global -Value "Module variable"

#
# Module cleanup
#

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
	Write-Debug -Message "[$ThisModule] Cleanup module"

	Remove-Variable -Name ModuleVariable -Scope Global
}
