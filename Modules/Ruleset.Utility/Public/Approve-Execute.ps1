
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

using namespace System.Management.Automation.Host

<#
.SYNOPSIS
Used to prompt user to approve running script

.DESCRIPTION
In addition to prompt, execution context is shown.
Asking for approval helps to let run master script and only execute specific
scripts, thus loading only needed rules.

.PARAMETER Unsafe
If specified the command is considered unsafe, and the default action is then "No"

.PARAMETER Title
Prompt title

.PARAMETER Question
Prompt question

.PARAMETER Accept
Prompt help menu for default action

.PARAMETER Deny
Prompt help menu for deny action

.PARAMETER YesToAll
True if user selects YesToAll.
If this is already true, Approve-Execute will bypass the prompt and return true.

.PARAMETER NoToAll
true if user selects NoToAll.
If this is already true, Approve-Execute will bypass the prompt and return false.

.EXAMPLE
PS> Approve-Execute -Unsafe -Title "Sample title" -Question "Sample question"

.EXAMPLE
PS> [bool] $YesToAll = $false
PS> [bool] $NoToAll = $false
PS> Approve-Execute -YesToAll ([ref] $YesToAll) -NoToAll ([ref] $NoToAll)

.INPUTS
None. You cannot pipe objects to Approve-Execute

.OUTPUTS
[bool] True if the user wants to continue, false otherwise

.NOTES
None.
#>
function Approve-Execute
{
	[CmdletBinding(PositionalBinding = $false, DefaultParameterSetName = "None",
		HelpURI = "https://github.com/metablaster/WindowsFirewallRuleset/blob/master/Modules/Ruleset.Utility/Help/en-US/Approve-Execute.md")]
	[OutputType([bool])]
	param (
		[Parameter()]
		[switch] $Unsafe,

		[Parameter()]
		[string] $Title = "Executing: " + (Split-Path -Leaf $MyInvocation.ScriptName),

		[Parameter()]
		[string] $Question = "Do you want to run this script?",

		[Parameter()]
		[string] $Accept = "Continue with only the next step of the operation",

		[Parameter()]
		[string] $Deny = "Skip this operation and proceed with the next operation",

		[Parameter(Mandatory = $true, ParameterSetName = "ToAll")]
		[ref] $YesToAll,

		[Parameter(Mandatory = $true, ParameterSetName = "ToAll")]
		[ref] $NoToAll
	)

	Write-Debug -Message "[$($MyInvocation.InvocationName)] params($($PSBoundParameters.Values))"

	# The index of the label in the Choices to be presented to the user as the default choice
	# NOTE: Converts switch to int32, if Unsafe is specified it's 1, otherwise it's 0
	[int32] $DefaultAction = !!$Unsafe

	# Setup choices
	[ChoiceDescription[]] $Choices = @()
	$AcceptChoice = [ChoiceDescription]::new("&Yes")
	$DenyChoice = [ChoiceDescription]::new("&No")

	$AcceptChoice.HelpMessage = $Accept
	$DenyChoice.HelpMessage = $Deny
	$Choices += $AcceptChoice # Decision 0
	$Choices += $DenyChoice # Decision 1

	if ($null -ne $YesToAll)
	{
		if ($YesToAll.Value -eq $true) { return $true }
		if ($NoToAll.Value -eq $true) { return $false }

		$YesAllChoice = [ChoiceDescription]::new("Yes To &All")
		$NoAllChoice = [ChoiceDescription]::new("No To A&ll")

		$YesAllChoice.HelpMessage = "Continue with all the steps of the operation"
		$NoAllChoice.HelpMessage = "Skip this operation and all subsequent operations"

		$Choices += $YesAllChoice # Decision 2
		$Choices += $NoAllChoice # Decision 3
	}

	$Title += " [$Context]"

	[bool] $Continue = switch ($Host.UI.PromptForChoice($Title, $Question, $Choices, $DefaultAction))
	{
		0
		{
			$true
			break
		}
		1
		{
			$false
			break
		}
		2
		{
			$YesToAll.Value = $true
			$true
			break
		}
		default
		{
			$NoToAll.Value = $true
			$false
			break
		}
	}

	if ($Continue)
	{
		if ($Unsafe)
		{
			Write-Warning -Message "[$($MyInvocation.InvocationName)] The user refused default action"
		}
		else
		{
			Write-Verbose -Message "[$($MyInvocation.InvocationName)] The user accepted default action"
		}

		return $true
	}
	elseif ($Unsafe)
	{
		Write-Warning -Message "The operation has been canceled by default"
	}
	else
	{
		Write-Warning -Message "The operation has been canceled by the user"
	}

	return $false
}
