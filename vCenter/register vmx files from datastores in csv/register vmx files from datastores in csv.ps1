#
# Traverses all folders of a data store and adds all VMX files to the inventory
#

### SETTINGS
$vCenterIPAddress = "1.1.1.1" #vCenter server address
$vCenterUsername = "administrator@vsphere.local" #vCenter admin user
$vCenterPassword = "mypassword" #vCenter password
$ESXHost = "2.2.2.2"
$DatastoreListCSV = "./register vmx files from datastores in csv.csv"


#Requires -Version 2 
Set-StrictMode -Version 2

# Loads snapins
function LoadSnapins([string[]] $snapins)
{
   $loaded = Get-PSSnapin -Name $snapins -ErrorAction SilentlyContinue | % {$_.Name}
   $registered = Get-pssnapin -Name $snapins -Registered -ErrorAction SilentlyContinue  | % {$_.Name}
   $notLoaded = $registered | ? {$loaded -notcontains $_}
   
   if ($notLoaded -ne $null)
   {
	  foreach ($newlyLoaded in $notLoaded)
	  {
		 Add-PSSnapin $newlyLoaded
	  }
   }
}

# Load snapins
LoadSnapins @("VMware.VimAutomation.Core")

# Avoid stupid questions
Set-PowerCLIConfiguration -DefaultVIServerMode multiple -Confirm:$false

#Log into vCenter
Connect-VIServer -Server $vCenterIPAddress -User $vCenterUsername -Password $vCenterPassword -Force

# Import Datastore list CSV
Import-Csv $DatastoreListCSV | Foreach-Object { 

	#only work on enabled entries in CSV
	if ( $_.enabled -eq 1 ) {
		Write-Host "`n###Adding VMX files from Datastore: $($_.dsname)`n"

		# Set up search for .VMX files in datastore
		$ds = Get-Datastore -Name $_.dsname | %{Get-View $_.Id}
		$SearchSpec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
		$SearchSpec.matchpattern = "*.vmx"
		$dsBrowser = Get-View $ds.browser
		$DatastorePath = "[" + $ds.Summary.Name + "]"

		# Find all .VMX file paths in datastore, filtering out ones with .snapshot (useful for NetApp NFS)
		$SearchResult = $dsBrowser.SearchDatastoreSubFolders($DatastorePath, $SearchSpec) `
						| where {$_.FolderPath -notmatch ".snapshot"} `
						| %{$_.FolderPath + ($_.File | select Path).Path}

		#Register all .vmx files as VMs on the datastore
		foreach($VMXFile in $SearchResult)
		{
			Write-Host "`n###Adding VMX file: $($VMXFile)`n"
			New-VM -VMFilePath $VMXFile -VMHost $ESXHost
		}
	}
}

Write-Host "`nFinished!"
pause