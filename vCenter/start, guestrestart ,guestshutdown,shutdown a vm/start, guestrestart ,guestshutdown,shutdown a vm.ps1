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

#Start
#Start-VM -VM $vmName -Confirm:$False

#Guest Restart
#Restart-VMGuest -VM $vmName -Confirm:$False

#Guest Shutdown
#Shutdown-VMGuest -VM $vmName -Confirm:$False

#Shutdown
#Stop-VM -VM $vmName -Confirm:$False

####CUSTOMIZE ENDS HERE###
##############################
}

Disconnect-VIServer -Confirm:$false