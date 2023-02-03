. ".\Keystrokes (JP).ps1"
Import-Module VMware.PowerCLI
Connect-VIServer -Server 'hostname.domain.tld' -User 'administrator@vsphere.local' -Password 'mypassword' -Force

$vmName = "myVM"

#notify user
Write-Host "Processing: $vmName "

#Open Remote Console
$vm = Get-VM $vmName
$vm | Open-VMConsoleWindow

####CUSTOMIZE STARTING HERE###
##############################

#Unmount ISO (SHUTDOWN NEEEDED!!!)
Shutdown-VMGuest -VM $vmName -Confirm:$False
Get-VM -Name $vmName | Get-CDDrive | Set-CDDrive -NoMedia -Confirm:$false
Start-VM -VM $vmName

####CUSTOMIZE ENDS HERE###
##############################
}

Disconnect-VIServer -Confirm:$false