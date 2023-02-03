Connect-VIServer -Server "1.1.1.1" -User 'administrator@vsphere.local' -Password 'password' -Force

$my_vm = "myVM1"

$my_portgroup = Get-VirtualPortGroup -Name "pg-myPortgroup_101","pg-Business-Internal_110" -VMHost 2.2.2.2

New-VM -Name $my_vm -VMHost 2.2.2.2 -DiskGB 100 -MemoryGB 4 -NumCpu 2 -CoresPerSocket 2 -Datastore $my_vm -DiskStorageFormat Thin -Portgroup $my_portgroup