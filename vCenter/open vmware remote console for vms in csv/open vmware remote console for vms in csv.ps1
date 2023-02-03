### SETTINGS
$CSV = "./open vmware remote console for vms in csv.csv"

Connect-VIServer -Server '1.1.1.1' -User 'administrator@vsphere.local' -Password 'mypassword' -Force

Import-Csv $CSV | Foreach-Object { 
	if ( $_.enabled -eq 1 ) {
        	echo  $_.name
		$vm = Get-VM $_.name
		$vm | Open-VMConsoleWindow
		Read-Host "Press Enter..."
	}
}
Write-Host "`nFinished!"
pause
