Connect-VIServer -Server 1.2.3.4 -Protocol https -User "root" -Password "mypassword" -Force

#disable
Get-VMHost | Get-VMHostService | Where { $_.Key -eq "TSM-SSH" } | Stop-VMHostService
Get-VMHost | Get-AdvancedSetting UserVars.SuppressShellWarning | Set-AdvancedSetting -Value 0 -Confirm:$false