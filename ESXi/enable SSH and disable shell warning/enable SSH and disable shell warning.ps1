Connect-VIServer -Server 1.2.3.4 -Protocol https -User "root" -Password "mypassword" -Force

#enable
Get-VMHost | Get-VMHostService | Where { $_.Key -eq "TSM-SSH" } | Start-VMHostService
Get-VMHost | Get-AdvancedSetting UserVars.SuppressShellWarning | Set-AdvancedSetting -Value 1 -Confirm:$false