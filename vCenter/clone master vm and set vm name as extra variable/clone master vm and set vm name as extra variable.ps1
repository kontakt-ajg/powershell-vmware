###Settings
$vServerAddress = "vcenter1.my.lab" #vCenter server address
$vServerUser = "administrator@vsphere.local" #vCenter admin user
$vServerPass = "mypassword" #vCenter password
$vmMaster = "myVM0" #master vm name
$vmHost = "esx1.my.lab" #target esxi host
$vmDatastore = "myDatastore" #target data store

#Import HDI input
. ".\Keystrokes (JP).ps1"

#Connect to vcenter
Import-Module VMware.PowerCLI
Connect-VIServer -Server $vServerAddress -User $vServerUser -Password $vServerPass -Force

# This defines the VM Prefixed that will be used for the name of the VM
$vmPrefix = "myVM"

#Choose ONE type of list. custom vs continous
#$vmNumbers = @(1,3,5,7,10)
$vmNumbers = 1..123

#Loop through the list
foreach ($vmNumber in $vmNumbers)
{
# 0 pad the vmNumber if needed
$vmNumber0Padded = ([string]$vmNumber).PadLeft(3,'0')
#Create complete VM name
$vmName = $vmPrefix + $vmNumber0Padded

#notify user
Write-Host "Processing: $vmName "

#Open Remote Console
$vm = Get-VM $vmName
$vm | Open-VMConsoleWindow

####CUSTOMIZE STARTING HERE###
##############################

#Clone VM
New-VM -Name $vmName -VMHost $vmHost -VM $vmMaster -Datastore $vmDatastore

#Set vmName as extra VM variable so Guest can read it with vmtools
$vmSet = Get-VM $vmName | Get-View
$vmConfigSpec = New-Object VMware.Vim.VirtualMachineConfigSpec
$gInfo = New-Object VMware.Vim.optionvalue
$ginfo.Key="guestinfo.hostname"
$gInfo.Value=$vmSet.Name
$vmConfigSpec.extraconfig += $gInfo
$vmSet.ReconfigVM($vmConfigSpec)

# This will Power On the New VM
Start-VM -VM $vmName

####CUSTOMIZE ENDS HERE###
##############################
}

Disconnect-VIServer -Confirm:$false