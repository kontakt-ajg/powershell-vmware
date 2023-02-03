. ".\keystrokes (JP).ps1"
$vCenterIPAddress = "1.1.1.1" #vCenter server address
$vCenterUsername = "administrator@vsphere.local" #vCenter admin user
$vCenterPassword = "mypassword" #vCenter password

Connect-VIServer -Server $vCenterIPAddress -User $vCenterUsername -Password $vCenterPassword -Force

#ask for first input
$VM_NAME = Read-Host -Prompt "Input the VM Name OR [0] to exit"

#Loop through the list
while($VM_NAME -ne "0")
{

	#notify user
	Write-Host "Processing: $VM_NAME "

	#Open Remote Console
	$vm = Get-VM $VM_NAME
	$vm | Open-VMConsoleWindow
	
	Read-Host -Prompt "`nLog in and then press ENTER to continue"

	Write-Host "###This is a helper script to upgrade / install VMware Tools on Centos / RHEL 5,6,7 Machines"
	Write-Host "###Input [0] to go back to VM Name input screen"
	Write-Host "###Input [1] to verify PERL version"
	Write-Host "###Input [2] to mount CD-ROM"
	Write-Host "###Input [3] to start the upgrade / install process"
	Write-Host "###Input [4] to reboot VM"
	Write-Host "###Input [5] to to check installed VMware Tools version"
	$CMD_CHOICE = Read-Host -Prompt "`nPlease enter your choice"
		
	while($CMD_CHOICE -ne "0"){	
		switch ( $CMD_CHOICE )
		{
			'1'
			{
				Set-VMKeystrokes -VMName $VM_NAME -StringInput "perl -v"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyEnter"
			}
			'2'
			{
				#Create temporary CD-ROM mount directory
				Set-VMKeystrokes -VMName $VM_NAME -StringInput "mkdir /tmp/cdrom"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyEnter"
				Start-Sleep -Seconds 1.0
				
				#Mount VMware Tools ISO
				Mount-Tools $VM_NAME
				Start-Sleep -Seconds 1.0
				
				#Mount CD-ROM in created mount directory
				Set-VMKeystrokes -VMName $VM_NAME -StringInput "mount /dev/cdrom /tmp/cdrom"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyEnter"
				Start-Sleep -Seconds 1.0
			}
			'3'
			{
				#Change into the /tmp directory
				Set-VMKeystrokes -VMName $VM_NAME -StringInput "cd /tmp"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyEnter"
				Start-Sleep -Seconds 1.0
				
				#Change into the /tmp directory
				Set-VMKeystrokes -VMName $VM_NAME -StringInput "tar zxpf /tmp/cdrom/VMwareTools-"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyTAB"
				Start-Sleep -Seconds 1.0				
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyEnter"
				Start-Sleep -Seconds 1.0
				
				#Change into the /tmp directory
				Set-VMKeystrokes -VMName $VM_NAME -StringInput "umount /tmp/cdrom"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyEnter"
				Start-Sleep -Seconds 1.0
				
				#Change into the /tmp directory
				Set-VMKeystrokes -VMName $VM_NAME -StringInput "cd vmware-tools-distrib"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyEnter"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -StringInput "./vmware-install.pl -d"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyEnter"
				Start-Sleep -Seconds 1.0
			}
			'4'
			{
				Set-VMKeystrokes -VMName $VM_NAME -StringInput "reboot"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyEnter"
			}
			'5'
			{
				Set-VMKeystrokes -VMName $VM_NAME -StringInput "vmware-toolbox-cmd -v"
				Start-Sleep -Seconds 1.0
				Set-VMKeystrokes -VMName $VM_NAME -SpecialKeyInput "KeyEnter"
			}
			default
			{
				Write-Host "SWITCH CASE DEFAULT CHOICE"
			}
		}
		
		$CMD_CHOICE = Read-Host -Prompt "`nPlease enter your choice"
	}
	
	$VM_NAME = Read-Host -Prompt "Input the VM Name OR [0] to exit"
}

Disconnect-VIServer -Confirm:$false