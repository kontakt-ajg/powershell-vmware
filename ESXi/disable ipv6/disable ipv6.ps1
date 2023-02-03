Connect-VIServer -Server 1.2.3.4 -Protocol https -User "root" -Password "mypassword" -Force

$VMHost = Get-VMHost 1.2.3.4

$esxcli = Get-EsxCli -VMHost $VMhost -V2
$argument = $esxcli.system.module.parameters.set.CreateArgs()
$argument.module = "tcpip4"
$argument.parameterstring = "ipv6=0"
$esxcli.system.module.parameters.set.Invoke($argument)
Write-Host "IPv6 Disabled for host: $($VMHost)"
Write-Host "You need to put the host in maintenance mode and reboot for changes to take effect."