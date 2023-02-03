$vCenterIPAddress = "1.1.1.1" #vCenter server address
$vCenterUsername = "administrator@vsphere.local" #vCenter admin user
$vCenterPassword = "mypassword" #vCenter password
$csv_file_path = "./migrate vms to target host and datastore.csv"
$maxsession = 5
$runsession = 0

echo "---------------Summary----------------"
echo "This script is to perform the Virtual Storage vMotion with give max sessions"
echo "--------------------------------------"

#Log into vCenter
Connect-VIServer -Server $vCenterIPAddress -User $vCenterUsername -Password $vCenterPassword -Force

import-csv $csv_file_path | foreach {

	if ( $_.enabled -eq 1 ) {

		echo "------------------------------------------------"
		echo "Checking the running vMotion now.... Pls wait...."
		echo "------------------------------------------------"

		Do {

			$runsession = (get-task | where {$_.name -like "RelocateVM_Task" -and $_.State -eq "Running" }).count

			if ($runsession -ge $maxsession) {
				echo "The current running vMotion sessions is $runsession. No new vMotion will be started. Next check will be performed in 10 seconds."
				Start-Sleep -s 10
				get-task | where {$_.State -eq "running"}
			}

			else {
				echo "The current running vMotion sessions is $runsession, a new storage vMotion will be started soon."
				Start-Sleep -s 5
			}

		} While ( $runsession -ge $maxsession)



		if ( $_.storage_vmotion -eq 1 ) {
			echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
			echo "Storage AND Host vMotion for will start for below VM ..."
			echo $_.vmname
			echo $_.targetds
			echo $_.targethost
			Get-VM $_.vmname | Move-VM -Destination $_.targethost -Datastore $_.targetds -RunAsync -Confirm:$false
			echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		}	
			
		else {
			echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
			echo "Host vMotion for will start for below VM ..."
			echo $_.vmname
			echo $_.targethost
				Get-VM $_.vmname | Move-VM -Destination $_.targethost -RunAsync -Confirm:$false
			echo ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
		}	
	}
}

Write-Host "`nFinished vMotion for all VMs in the CSV file!"
pause