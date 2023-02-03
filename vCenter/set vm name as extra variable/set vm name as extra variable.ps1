###Settings
$vServerAddress = "vcenter.domain.tld" #vCenter server address
$vServerUser = "administrator@vsphere.local" #vCenter admin user
$vServerPass = "mypassword" #vCenter password

#Connect to vcenter
Import-Module VMware.PowerCLI
Connect-VIServer -Server $vServerAddress -User $vServerUser -Password $vServerPass -Force

$vmList = @(myVM1,myVM2)

#Loop through the list
foreach ($vmName in $vmList)
{

#notify user
Write-Host "Processing: $vmName "

#Open Remote Console
$vm = Get-VM $vmName
$vm | Open-VMConsoleWindow

####CUSTOMIZE STARTING HERE###
##############################

#Set vmName as extra VM variable so Guest can read it with vmtools
$vmSet = Get-VM $vmName | Get-View
$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
$gInfo = New-Object VMware.Vim.optionvalue
$ginfo.Key="guestinfo.hostname"
$gInfo.Value=$vmSet.Name
$vmConfigSpec.extraconfig += $gInfo
$vmSet.ReconfigVM($vmConfigSpec)

####CUSTOMIZE ENDS HERE###
##############################
}

Disconnect-VIServer -Confirm:$false