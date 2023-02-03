#Settings
$vCenterIPAddress = "1.1.1.1" #vCenter server address
$vCenterUsername = "administrator@vsphere.local" #vCenter admin user
$vCenterPassword = "mypassword" #vCenter password
$CSV_file_path = "./create datastores on nimble volumes.csv"
$esxName = '2.2.2.2'

#Log into vCenter
Connect-VIServer -Server $vCenterIPAddress -User $vCenterUsername -Password $vCenterPassword -Force

# Import csv file
Import-Csv $CSV_file_path | Foreach-Object { 

		$_.serial_number = "eui." + $_.serial_number
		Write-Host "`n###Creating datastore $_.datastore_name on device $_.serial_number ...`n"
		New-Datastore -Server $vCenterIPAddress -VMHost $esxName -Name $_.datastore_name -Path $_.serial_number -Vmfs -FileSystemVersion 6
		#Read-Host -Prompt "`nOK? Press any key to continue"
}