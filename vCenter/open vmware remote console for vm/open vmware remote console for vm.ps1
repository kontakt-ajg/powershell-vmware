Import-Module VMware.PowerCLI
Connect-VIServer -Server 'hostname.domain.tld' -User 'administrator@vsphere.local' -Password 'mypassword' -Force

# This defines the VM Prefixed that will be used for the name of the VM

#Choose ONE type of list. custom vs continous
$vmList = @(myVM1,myVM2)

#Loop through the list
foreach ($vmName in $vmList)
{

#notify user
Write-Host "Processing: $vmName "

#Open Remote Console
$vm = Get-VM $vmName
$vm | Open-VMConsoleWindow
}

Disconnect-VIServer -Confirm:$false