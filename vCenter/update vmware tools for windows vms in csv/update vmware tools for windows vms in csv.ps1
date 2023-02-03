#Settings
$vCenterIPAddress = "1.1.1.1" #vCenter server address
$vCenterUsername = "administrator@vsphere.local" #vCenter admin user
$vCenterPassword = "mypassword" #vCenter password
$CSV_file_path = "./update vmware tools for windows vms in csv.csv"

#Log into vCenter
Connect-VIServer -Server $vCenterIPAddress -User $vCenterUsername -Password $vCenterPassword -Force

# Import VolumeList.csv
Import-Csv $CSV_file_path | Foreach-Object { 

	if ( $_.enabled -eq 1 ) {
		Write-Host "`n###Updating VMware Tools on $($_.vm_name) ...`n"
		Update-Tools $_.vm_name -NoReboot
	}
}

Write-Host "`nFinished updating VMwareTools on all VMs in the CSV file!"
pause