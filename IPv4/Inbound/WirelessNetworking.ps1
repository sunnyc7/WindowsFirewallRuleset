
<#
MIT License

Copyright (c) 2019 metablaster zebal@protonmail.ch

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
# Import global variables
#
. "$PSScriptRoot\..\..\Modules\GlobalVariables.ps1"

# Ask user if he wants to load these rules
if (!(RunThis)) { exit }

#
# Setup local variables:
#
$Group = "Wireless Networking"
$Interface = "Wireless"

#First remove all existing rules matching group
Remove-NetFirewallRule -PolicyStore $PolicyStore -Group $Group -Direction Inbound -ErrorAction SilentlyContinue

#
# Windows system predefined rules for Wireless Display
#

# TODO: local user may need to be 'Any', needs testing.
New-NetFirewallRule -Confirm:$Execute -Whatif:$Debug -ErrorAction $OnError -Platform $Platform `
-DisplayName "Wireless Display" -Service Any -Program "%SystemRoot%\System32\WUDFHost.exe" `
-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile Private, Domain -InterfaceType $Interface `
-Direction Inbound -Protocol TCP -LocalAddress Any -RemoteAddress Any -LocalPort 443 -RemotePort Any `
-EdgeTraversalPolicy Block -LocalUser $NT_AUTHORITY_UserModeDrivers `
-Description "Driver Foundation - User-mode Driver Framework Host Process.
The driver host process (Wudfhost.exe) is a child process of the driver manager service.
loads one or more UMDF driver DLLs, in addition to the framework DLLs."

# TODO: remote port unknown, rule added because predefined rule for UDP exists
New-NetFirewallRule -Confirm:$Execute -Whatif:$Debug -ErrorAction $OnError -Platform $Platform `
-DisplayName "Wireless Display Infrastructure back channel" -Service Any -Program "%systemroot%\system32\CastSrv.exe" `
-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile Private, Domain -InterfaceType $Interface `
-Direction Inbound -Protocol TCP -LocalAddress Any -RemoteAddress Any -LocalPort 7250 -RemotePort Any `
-EdgeTraversalPolicy Block -LocalUser Any `
-Description "Miracast is a Wi-Fi display certification program announced by Wi-Fi Alliance for seamlessly displaying video between devices.
Users attempt to connect to a Miracast receiver as they did previously.
When the list of Miracast receivers is populated, Windows 10 will identify that the receiver is capable of supporting a connection over the infrastructure.
When the user selects a Miracast receiver, Windows 10 will attempt to resolve the device's hostname via standard DNS, as well as via multicast DNS (mDNS).
If the name is not resolvable via either DNS method, Windows 10 will fall back to establishing the Miracast session using the standard Wi-Fi direct connection."

#
# Windows system predefined rules for WiFi Direct
#

New-NetFirewallRule -Confirm:$Execute -Whatif:$Debug -ErrorAction $OnError -Platform $Platform `
-DisplayName "WLAN Service WFD ASP Coordination Protocol" -Service WlanSvc -Program "%systemroot%\system32\svchost.exe" `
-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile Private, Domain -InterfaceType $Interface `
-Direction Inbound -Protocol UDP -LocalAddress Any -RemoteAddress LocalSubnet4 -LocalPort 7325 -RemotePort 7325 `
-EdgeTraversalPolicy Block -LocalUser Any `
-Description "WLAN Service to allow coordination protocol for WFD Service sessions.
Wi-Fi Direct (WFD) Protocol Specifies: Proximity Extensions, which enable two or more devices that are running the same application
to establish a direct connection without requiring an intermediary, such as an infrastructure wireless access point (WAP).
For more info see description of WLAN AutoConfig service."

New-NetFirewallRule -Confirm:$Execute -Whatif:$Debug -ErrorAction $OnError -Platform $Platform `
-DisplayName "WLAN Service WFD Driver-only" -Service Any -Program System `
-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile Private, Domain -InterfaceType $Interface `
-Direction Inbound -Protocol TCP -LocalAddress Any -RemoteAddress LocalSubnet4 -LocalPort Any -RemotePort Any `
-EdgeTraversalPolicy Block -LocalUser $NT_AUTHORITY_System `
-Description "Rule for drivers to communicate over WFD, WFD Services kernel mode driver rule.
Wi-Fi Direct (WFD) Protocol Specifies: Proximity Extensions, which enable two or more devices that are running the same application
to establish a direct connection without requiring an intermediary, such as an infrastructure wireless access point (WAP).
For more info see description of WLAN AutoConfig service."

New-NetFirewallRule -Confirm:$Execute -Whatif:$Debug -ErrorAction $OnError -Platform $Platform `
-DisplayName "WLAN Service WFD Driver-only" -Service Any -Program System `
-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile Private, Domain -InterfaceType $Interface `
-Direction Inbound -Protocol UDP -LocalAddress Any -RemoteAddress LocalSubnet4 -LocalPort Any -RemotePort Any `
-EdgeTraversalPolicy Block -LocalUser $NT_AUTHORITY_System `
-Description "Rule for drivers to communicate over WFD, WFD Services kernel mode driver rule.
Wi-Fi Direct (WFD) Protocol Specifies: Proximity Extensions, which enable two or more devices that are running the same application
to establish a direct connection without requiring an intermediary, such as an infrastructure wireless access point (WAP).
For more info see description of WLAN AutoConfig service."

#
# Windows system predefined rules for Wireless portable devices
#

New-NetFirewallRule -Confirm:$Execute -Whatif:$Debug -ErrorAction $OnError -Platform $Platform `
-DisplayName "Wireless portable devices (SSDP)" -Service SSDPSRV -Program "%systemroot%\system32\svchost.exe" `
-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile Any -InterfaceType $Interface `
-Direction Inbound -Protocol UDP -LocalAddress Any -RemoteAddress LocalSubnet4 -LocalPort 1900 -RemotePort Any `
-EdgeTraversalPolicy Block -LocalUser Any `
-Description "Wireless Portable Devices to allow use of the Simple Service Discovery Protocol."

New-NetFirewallRule -Confirm:$Execute -Whatif:$Debug -ErrorAction $OnError -Platform $Platform `
-DisplayName "Wireless portable devices (UPnP)" -Service Any -Program System `
-PolicyStore $PolicyStore -Enabled False -Action Allow -Group $Group -Profile Any -InterfaceType $Interface `
-Direction Inbound -Protocol TCP -LocalAddress Any -RemoteAddress LocalSubnet4 -LocalPort 2869 -RemotePort Any `
-EdgeTraversalPolicy Block -LocalUser $NT_AUTHORITY_System `
-Description "Wireless Portable Devices to allow use of Universal Plug and Play."

