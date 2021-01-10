
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

#
# Module manifest for module "Ruleset.Utility"
#
# Generated by: metablaster
#
# Generated on: 11.2.2020.
#

@{
	# Script module or binary module file associated with this manifest, (alias: ModuleToProcess)
	# Previous versions of PowerShell called this element the ModuleToProcess.
	# NOTE: To create a manifest module this must be empty,
	# the name of a script module (.psm1) creates a script module,
	# the name of a binary module (.exe or .dll) creates a binary module.
	RootModule = "Ruleset.Utility.psm1"

	# Version number of this module.
	ModuleVersion = "0.9.1"

	# Supported PSEditions
	CompatiblePSEditions = @(
		"Core"
		"Desktop"
	)

	# ID used to uniquely identify this module
	GUID = "5f38e46f-1bc4-489d-90df-72755129cfdd"

	# Author of this module
	Author = "metablaster zebal@protonmail.ch"

	# Company or vendor of this module
	# CompanyName = "Unknown"

	# Copyright statement for this module
	Copyright = "Copyright (C) 2019-2021 metablaster zebal@protonmail.ch"

	# Description of the functionality provided by this module
	Description = "PowerShell utility module for Windows Firewall Ruleset project"

	# Minimum version of the PowerShell engine required by this module
	# Valid values are: 1.0 / 2.0 / 3.0 / 4.0 / 5.0 / 5.1 / 6.0 / 6.1 / 6.2 / 7.0 / 7.1
	PowerShellVersion = "5.1"

	# Name of the Windows PowerShell host required by this module
	# PowerShellHostName = ""

	# Minimum version of the Windows PowerShell host required by this module
	# PowerShellHostVersion = ""

	# Minimum version of Microsoft .NET Framework required by this module.
	# This prerequisite is valid for the PowerShell Desktop edition only.
	# Valid values are: 1.0 / 1.1 / 2.0 / 3.0 / 3.5 / 4.0 / 4.5
	DotNetFrameworkVersion = "4.5"

	# Minimum version of the common language runtime (CLR) required by this module.
	# This prerequisite is valid for the PowerShell Desktop edition only.
	# Valid values are: 1.0 / 1.1 / 2.0 / 4.0
	CLRVersion = "4.0"

	# Processor architecture (None, X86, Amd64) required by this module.
	# Valid values are: x86 / AMD64 / Arm / IA64 / MSIL / None (unknown or unspecified).
	ProcessorArchitecture = "None"

	# Modules that must be imported into the global environment prior to importing this module
	# RequiredModules = @()

	# Assemblies that must be loaded prior to importing this module
	# RequiredAssemblies = @()

	# Script files (.ps1) that are run in the caller's environment prior to importing this module.
	# ScriptsToProcess = @()

	# Type files (.ps1xml) to be loaded when importing this module
	# TypesToProcess = @()

	# Format files (.ps1xml) to be loaded when importing this module
	# FormatsToProcess = @()

	# Modules to import as nested modules of the module specified in RootModule.
	# Loading (.ps1) files here is equivalent to dot sourcing the script in your root module.
	# NestedModules = @()

	# Functions to export from this module, for best performance, do not use wildcards and do not
	# delete the entry, use an empty array if there are no functions to export.
	FunctionsToExport = @(
		"Approve-Execute"
		"Build-ServiceList"
		"Compare-Path"
		"Confirm-FileEncoding"
		"ConvertFrom-Wildcard"
		"Get-FileEncoding"
		"Get-TypeName"
		"Invoke-Process"
		"Out-DataTable"
		"Resolve-FileSystemPath"
		"Select-EnvironmentVariable"
		"Set-NetworkProfile"
		"Set-Permission"
		"Set-ScreenBuffer"
		"Set-Shortcut"
	)

	# Cmdlets to export from this module, for best performance, do not use wildcards and do not
	# delete the entry, use an empty array if there are no cmdlets to export.
	CmdletsToExport = @()

	# Variables to export from this module.
	# Wildcard characters are permitted, by default, all variables ("*") are exported.
	VariablesToExport = @(
		"CheckInitUtility"
		"ServiceHost"
	)

	# Aliases to export from this module, for best performance, do not use wildcards and do not
	# delete the entry, use an empty array if there are no aliases to export.
	AliasesToExport = @("gt")

	# DSC resources to export from this module
	# DscResourcesToExport = @()

	# List of all modules packaged with this module.
	# These modules are not automatically processed.
	# ModuleList = @()

	# List of all files packaged with this module.
	# As with ModuleList, FileList is an inventory list.
	FileList = @(
		"en-US\about_Ruleset.Utility.help.txt"
		"en-US\Ruleset.Utility-help.xml"
		"Help\en-US\about_Ruleset.Utility.md"
		"Help\en-US\Approve-Execute.md"
		"Help\en-US\Build-ServiceList.md"
		"Help\en-US\Compare-Path.md"
		"Help\en-US\Confirm-FileEncoding.md"
		"Help\en-US\ConvertFrom-Wildcard.md"
		"Help\en-US\Get-FileEncoding.md"
		"Help\en-US\Invoke-Process.md"
		"Help\en-US\Out-DataTable.md"
		"Help\en-US\Get-TypeName.md"
		"Help\en-US\Resolve-FileSystemPath.md"
		"Help\en-US\Ruleset.Utility.md"
		"Help\en-US\Select-EnvironmentVariable.md"
		"Help\en-US\Set-NetworkProfile.md"
		"Help\en-US\Set-Permission.md"
		"Help\en-US\Set-ScreenBuffer.md"
		"Help\en-US\Set-Shortcut.md"
		"Help\README.md"
		"Private\Set-Privilege.ps1"
		"Public\Approve-Execute.ps1"
		"Public\Build-ServiceList.ps1"
		"Public\Compare-Path.ps1"
		"Public\Confirm-FileEncoding.ps1"
		"Public\ConvertFrom-Wildcard.ps1"
		"Public\Get-FileEncoding.ps1"
		"Public\Get-TypeName.ps1"
		"Public\Invoke-Process.ps1"
		"Public\Out-DataTable.ps1"
		"Public\README.md"
		"Public\Resolve-FileSystemPath.ps1"
		"Public\Select-EnvironmentVariable.ps1"
		"Public\Set-NetworkProfile.ps1"
		"Public\Set-Permission.ps1"
		"Public\Set-ScreenBuffer.ps1"
		"Public\Set-Shortcut.ps1"
		"Ruleset.Utility_5f38e46f-1bc4-489d-90df-72755129cfdd_HelpInfo.xml"
		"Ruleset.Utility.psd1"
		"Ruleset.Utility.psm1"
	)

	# Specifies any private data that needs to be passed to the root module specified by the RootModule.
	# This contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{

		PSData = @{

			# Tags applied to this module.
			# These help with module discovery in online galleries.
			Tags = @(
				"Utility"
				"FirewallUtility"
			)

			# A URL to the license for this module.
			LicenseUri = "https://raw.githubusercontent.com/metablaster/WindowsFirewallRuleset/master/LICENSE"

			# A URL to the main website for this project.
			ProjectUri = "https://github.com/metablaster/WindowsFirewallRuleset"

			# A URL to an icon representing this module.
			# IconUri = ""

			# ReleaseNotes of this module
			# ReleaseNotes = ""

			# A PreRelease string that identifies the module as a prerelease version in online galleries.
			Prerelease = "https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Readme/CHANGELOG.md"

			# Flag to indicate whether the module requires explicit user acceptance for
			# install, update, or save.
			RequireLicenseAcceptance = $true

			# A list of external modules that this module is dependent upon.
			# ExternalModuleDependencies = @()
		} # End of PSData hashtable
	} # End of PrivateData hashtable

	# HelpInfo URI of this module
	# HelpInfoURI = "https://raw.githubusercontent.com/metablaster/WindowsFirewallRuleset/master/Modules/Ruleset.Utility/Ruleset.Utility_5f38e46f-1bc4-489d-90df-72755129cfdd_HelpInfo.xml"

	# Default prefix for commands exported from this module.
	# Override the default prefix using Import-Module -Prefix.
	# DefaultCommandPrefix = ""
}
