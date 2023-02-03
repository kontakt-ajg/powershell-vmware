. ".\Keystrokes (JP).ps1"
Import-Module VMware.PowerCLI
Connect-VIServer -Server 'hostname.domain.tld' -User 'administrator@vsphere.local' -Password 'mypassword' -Force

$vmName = "myVM1"

#notify user
Write-Host "Processing: $vmName "

#Open Remote Console
$vm = Get-VM $vmName
$vm | Open-VMConsoleWindow

####CUSTOMIZE STARTING HERE###
##############################

# Show Password Field
Set-VMKeystrokes -VMName $vmName -SpecialKeyInput "KeyEnter"
Start-Sleep -Seconds 5.0

# Type in Password and login
Set-VMKeystrokes -VMName $vmName -StringInput "windowspassword"
Start-Sleep -Seconds 1.0
Set-VMKeystrokes -VMName $vmName -SpecialKeyInput "KeyEnter"

####CUSTOMIZE ENDS HERE###
##############################
}

Disconnect-VIServer -Confirm:$false