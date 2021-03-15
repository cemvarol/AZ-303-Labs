### This will upload vhd and create a vm out of that vhd


## Exercise 1: Create the environment

1.  Open [**Cloud Shell**](https://shell.azure.com) pane by selecting on
    the toolbar icon directly to the right of the search textbox.

2.  If prompted, select **Bash** .

> **Note**: If this is the first time you are starting **Cloud Shell** and you are presented with the **You have no storage mounted** message, select the subscription you are using in this lab,  and select **Create storage**.

3.  In the toolbar of the Cloud Shell pane, run the following command to create the vm.

```sh
curl -O https://raw.githubusercontent.com/cemvarol/Upload-N-Create/master/Resources.bash
ls -la Resources.bash
chmod +x Resources.bash
./Resources.bash
```


## Exercise 2: Create a VM to migrate to Azure

### Task 1: Configure nested virtualization in the Azure VM

1.  Select **Virtual machines** and, on the **Virtual machines** blade,
    select **Migrator**.

2.  Select **Networking**.

3.  Select **Connect**, in the drop-down menu, select **RDP**, and then
    click **Download RDP File**.

4.  When prompted, sign in with the following credentials:

-   User Name: **QA**

-   Password: **1q2w3e4r5t6y\***

> **Important Note:** All the actions you will follow including this step
    will be done on this Remote Computer's Console.

5.  Within the Remote Desktop session run the following command in
    **PowerShell** to create the guest vm to protect.
    

```Powershell
cd\
mkdir Lab
$url = "https://raw.githubusercontent.com/cemvarol/Upload-N-Create/master/SetLab.ps1"
$output = "C:\Lab\Lab.ps1"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process Powershell.exe -Argumentlist "-file C:\Lab\Lab.ps1"
```

> **Note:** This will take approximetaly 6-8 minutes. When finished Hyper-V Console will appear.

6.  In the Virtual Machine Connection window to **2012-R2**, on
    the **License terms** page, select **United Kingdom** and click *Next* to **Accept**.

7.  Set the password of the built-in Administrator account
    to **London2020\*** and select **Finish**.

8.  After Restart, sign in by using the newly set password.

-   Note: Your Guest Vm will be restarted once more automatically and will be ready after this step.


### Task 2: Check the output

1.  Go back to Azure portal and navigate to newly created Resource Group. Click the Traffic Manager **Mig-TM**
2.  On the overview page you will see 2 Endpoints. Ensure that Onprem is Online, and Migrated is Degraded.
       
    | Name | Status | Monitor Status |
    | --- | --- |--- |
    | Onprem | Enabled | **Online**|
    |Migrated | Enabled |**Degraded**|
    
2.  Copy the **DNS Name** and visit that URL on a new tab on your browser
3.  Ensure that the page welcomes you with the current date

> **Note:** If fails please ask for support, this will be needed for the next exercises.

> #### Result: We created a server hosting 2012-R2 VM. This vm is published to internet with its dns name and that name is behind a Traffic Manager. When a client visits the Traffic Manager URL, they will be diverted to use the 2012-R2 guest vm on the on-prem host.When the Lab completed, 2012-R2 VM will be migrated to Azure and Traffic Manager will show vise-versa, but the page will be still available.


## Exercise 3: Configure the VM for migration

### Task 1: Prepare the Host

1.  Install [**AZ-Copy**](https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10)
    >**Note:** Please extract AZ-Copy under C:\vms folder
1.  Install [**Azure Powershell**](https://docs.microsoft.com/en-us/powershell/azure/install-Az-ps?view=azps-4.3.0#code-try-1). You can run the script below 
        
     ```Powershell
        if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
        Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
        'Az modules installed at the same time is not supported.')
        } else {
          Install-Module -Name Az -AllowClobber -Scope CurrentUser
        }
     ```
    > **Note:** Please Accept all the installation options by typing A (Yes to ALL) follwing an Enter on the command 
    
    
### Task 2: Prepare the Guest
1.  After *Host* is ready, time to prepare the guest.

1.  [**Sysprep**](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/upload-generalized-managed#generalize-the-source-vm-by-using-sysprep) and shutdown the VM.
    1.  Open the Hyper-V Console and access 2012-R2 Console.
    1.  Right Click Start icon and choose *RUN* to open Run Menu, type **sysprep** and hit *Enter*
    1.  This will open Sysprep folder.
    1.  Double cick **sysprep**.
    1.  This will open *Sysprep Dialog Box*.
         1.  Leave **OOBE** (This was Default Setting)
        1.  Tick **Generalize**
        1.  Select **Shutdown**
1.  Wait Until Shut Down
1.  Run the command below on the **Host Computer** to convert the 2012R2 dynamically expanding disk to fixed disk
    ```Powershell
    cd \
    cd vms
    Convert-VHD -Path C:\VMs\2012-R2.vhd -DestinationPath C:\VMs\2012C.vhd -VHDType fixed
    ```

### Task 3: Prepare the Cloud

1.  Run this on 2019 PowerShell console. This will sign you in to Azure Account of yours on Local Computer Powershell Console. 

    ```Powershell
    Add-AzAccount
    ```
    Please complete the steps for authentication to Azure 

1.  Run this on 2019 PowerShell console this will use the size of your fixed size disk and create an empty disk space to upload your own disk to on Azure. 

    ```Powershell
    $L = (Get-AzResourceGroup -Name Migrator).Location
    $vhdSizeBytes = (Get-Item "C:\VMs\2012C.vhd").length
    $diskconfig = New-AzDiskConfig -SkuName 'Standard_LRS' -OsType 'Windows' -UploadSizeInBytes $vhdSizeBytes -Location $L -CreateOption 'Upload'
    New-AzDisk -ResourceGroupName "Migrator" -DiskName "cems.vhd" -Disk $diskconfig
    ```
    
1.  Run this on 2019 PowerShell console to allow azure PowerShell to access the empty managed disk

    ```Powershell
      $diskSas = Grant-AzDiskAccess -ResourceGroupName 'Migrator' -DiskName 'cems.vhd' -DurationInSecond 86400 -Access 'Write'
      $disk = Get-AzDisk -ResourceGroupName 'Migrator' -DiskName 'cems.vhd'
    ```
   
1.  Time to upload your 40GB disk to azure 
   
     ```Powershell
      .\azcopy.exe copy "2012C.vhd" $diskSas.AccessSAS --blob-type PageBlob
      Revoke-AzDiskAccess -ResourceGroupName 'Migrator' -DiskName 'cems.vhd'
     ```
     
## Exercise 3: Create the VM out of uploaded vhd
     
### Task 1: Time of the VM
     
1.  Now everything is ready to create the vm
     
     ```Powershell
    $disk = Get-AzDisk -ResourceGroupName 'Migrator' -DiskName 'cems.vhd'
    $location = (Get-AzResourceGroup -Name Migrator).Location
    $imageName = 'cems'
    $rgName = 'Migrator'

    $imageConfig = New-AzImageConfig `
    -Location $location
    $imageConfig = Set-AzImageOsDisk `
    -Image $imageConfig `
    -OsState Generalized `
    -OsType Windows `
    -ManagedDiskId $disk.Id

    $image = New-AzImage `
    -ImageName $imageName `
    -ResourceGroupName $rgName `
    -Image $imageConfig

    New-AzVm `
    -ResourceGroupName $rgName `
    -Name "CemsVm" `
    -Image $image.Id `
    -Location $location `
    -VirtualNetworkName "Mig-VNet" `
    -SubnetName "SN02" `
    -SecurityGroupName "MigNSG" `
    -PublicIpAddressName "Migrated-Pip" 
    ```

1.  After you run the command a dialog box will appear for a UserName and a Password for a VM. Provide something you will remember. 
    
    
| Username | Password |
| --- | --- |
| QA | 1q2w3e4r5t6y* |
> **Note:** Creating the VM may take like 3-5 minutes
    
    
### Task 2: Check the output

1.  Go back to Azure portal and navigate to newly created Resource Group. Click the Traffic Manager **Mig-TM**
2.  On the overview page you will see 2 Endpoints. Ensure that Onprem is Degraded, and Migrated is Online this time.
       
    | Name | Status | Monitor Status |
    | --- | --- |--- |
    | Onprem | Enabled | **Degraded**|
    |Migrated | Enabled |**Online**|
    
2.  Copy the **DNS Name** and visit that URL on a new tab on your browser
3.  Ensure that the page welcomes you with the content as you have seen on Exercise 2, Task 2



## Exercise 4: Remove Azure resources deployed in the lab

1. From the Cloud Shell pane, run the following to list the resource group you created in this exercise:

   ```sh
   az group list --query "[?contains(name,'Migr')]".name --output tsv
   ```

    > **Note**: Verify that the output contains only the resource group you created in this lab. This group will be deleted in this task.

1. From the Cloud Shell pane, run the following to delete the resource group you created in this lab

   ```sh
   az group list --query "[?contains(name,'Migr')]".name --output tsv | xargs -L1 bash -c 'az group delete --name $0 --no-wait --yes'
   ```

1. Close the Cloud Shell pane.

