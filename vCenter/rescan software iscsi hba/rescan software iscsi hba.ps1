#Settings
$vCenterIPAddress = "1.1.1.1" #vCenter server address
$vCenterUsername = "administrator@vsphere.local" #vCenter admin user
$vCenterPassword = "mypassword" #vCenter password
$esxName = '2.2.2.2'
$hbaName = "vmhba64"

#Log into vCenter
Connect-VIServer -Server $vCenterIPAddress -User $vCenterUsername -Password $vCenterPassword -Force

Write-Host "Rescanning HBAs on $esxName"
#Rescan HBA of ESXi
$esx = Get-VMHost -Name $esxName
$storSys1 = Get-View -Id $esx.ExtensionData.ConfigManager.StorageSystem
$storSys1.RescanHba($hbaName)