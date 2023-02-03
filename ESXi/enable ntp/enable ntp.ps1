Connect-VIServer -Server 1.2.3.4 -Protocol https -User "root" -Password "mypassword" -Force

$VMHost = Get-VMHost "1.2.3.4"

#configure ntp server
Get-VMHost $VMHost | Add-VMHostNtpServer -NtpServer "0.jp.pool.ntp.org"

#enable ntp service and startup
Get-VmHostService -VMHost $VMHost | Where-Object {$_.key -eq "ntpd"} | Start-VMHostService
Get-VmHostService -VMHost $VMHost | Where-Object {$_.key -eq "ntpd"} | Set-VMHostService -policy "on"