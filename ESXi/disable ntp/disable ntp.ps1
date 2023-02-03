Connect-VIServer -Server 1.2.3.4 -Protocol https -User "root" -Password "mypassword" -Force

$VMHost = Get-VMHost "1.2.3.4"

#disable ntp service and startup
Get-VmHostService -VMHost $VMHost | Where-Object {$_.key -eq "ntpd"} | Set-VMHostService -policy "off"
Get-VmHostService -VMHost $VMHost | Where-Object {$_.key -eq "ntpd"} | Stop-VMHostService

#configure ntp server
Get-VMHost $VMHost | Remove-VMHostNtpServer -NtpServer "0.jp.pool.ntp.org"