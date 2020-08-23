
#
# Module manifest for module 'Project.AllPlatforms.Logging'
#
# Generated by: metablaster
#
# Generated on: 21.2.2020.
#

@{
	# Script module or binary module file associated with this manifest.
	RootModule = 'Project.AllPlatforms.Logging.psm1'

	# Version number of this module.
	ModuleVersion = "0.6.0"

	# Supported PSEditions
	CompatiblePSEditions = 'Desktop, Core'

	# ID used to uniquely identify this module
	GUID = '5f38e46f-1bc4-489d-90df-72755129cfdd'

	# Author of this module
	Author = 'metablaster zebal@protonmail.ch'

	# Company or vendor of this module
	# CompanyName = 'Unknown'

	# Copyright statement for this module
	Copyright = 'Copyright (C) 2020 metablaster'

	# Description of the functionality provided by this module
	Description = 'Module for logging native PowerShell Write-* commandlets'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '5.1'

	# Name of the Windows PowerShell host required by this module
	# PowerShellHostName = ''

	# Minimum version of the Windows PowerShell host required by this module
	# PowerShellHostVersion = ''

	# Minimum version of Microsoft .NET Framework required by this module.
	# This prerequisite is valid for the PowerShell Desktop edition only.
	DotNetFrameworkVersion = '4.5'

	# Minimum version of the common language runtime (CLR) required by this module.
	# This prerequisite is valid for the PowerShell Desktop edition only.
	CLRVersion = '4.0'

	# Processor architecture (None, X86, Amd64) required by this module
	ProcessorArchitecture = 'None'

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

	# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
	# NestedModules = @()

	# Functions to export from this module, for best performance, do not use wildcards and do not
	# delete the entry, use an empty array if there are no functions to export.
	FunctionsToExport = @(
		"Update-Log"
	)

	# Cmdlets to export from this module, for best performance, do not use wildcards and do not
	# delete the entry, use an empty array if there are no cmdlets to export.
	CmdletsToExport = @()

	# Variables to export from this module
	VariablesToExport = @(
		"CheckInitLogging"
		"Logs"
		"ErrorStatus"
		"WarningStatus"
	)

	# Aliases to export from this module, for best performance, do not use wildcards and do not
	# delete the entry, use an empty array if there are no aliases to export.
	AliasesToExport = @()

	# DSC resources to export from this module
	# DscResourcesToExport = @()

	# List of all modules packaged with this module
	# ModuleList = @()

	# List of all files packaged with this module
	FileList = @(
		"Project.AllPlatforms.Logging.psd1"
		"Project.AllPlatforms.Logging.psm1"
		"about_Project.AllPlatforms.Logging.help.txt"
	)

	# Private data to pass to the module specified in RootModule/ModuleToProcess.
	# This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{

		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @("Logging")

			# A URL to the license for this module.
			LicenseUri = 'https://github.com/metablaster/WindowsFirewallRuleset/blob/master/LICENSE'

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/metablaster/WindowsFirewallRuleset'

			# A URL to an icon representing this module.
			# IconUri = ''

			# Prerelease string of this module
			Prerelease = "This pre-release is sufficiently stable to provide core logging functionality for Windows Firewall Ruleset project"

			# ReleaseNotes of this module
			# ReleaseNotes = ''
		} # End of PSData hashtable
	} # End of PrivateData hashtable

	# HelpInfo URI of this module
	# HelpInfoURI = ''

	# Default prefix for commands exported from this module.
	# Override the default prefix using Import-Module -Prefix.
	# DefaultCommandPrefix = ''
}
