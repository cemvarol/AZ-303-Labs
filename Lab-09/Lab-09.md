---
lab:
    title: '9: Protecting Hyper-V VMs by using Azure Site Recovery'
    module: 'Module 9: Manage Workloads in Azure'
---

# Lab: Protecting Hyper-V VMs by using Azure Site Recovery
# Student lab manual

## Lab scenario

While Adatum Corporation has, over the years, implemented a number of
high availability provisions for their on-premises workloads, its
disaster recovery capabilities are still insufficient to address the
Recovery Point Objectives (RPOs) and Recovery Time Objectives (RTOs)
demanded by its business. Maintaining the existing secondary on-premises
site requires an extensive effort and incurs significant costs. The
failover and failback procedures are, for the most part, manual and are
poorly documented.

To address these shortcomings, the Adatum Enterprise Architecture team
decided to explore capabilities of Azure Site Recovery, with Azure
taking on the role of the hoster of the secondary site. Azure Site
Recovery automatically and continuously replicates workloads running on
physical and virtual machines from the primary to the secondary site.
Site Recovery uses storage-based replication mechanism, without
intercepting application data. With Azure as the secondary site, data is
stored in Azure Storage, with built-in resilience and low cost. The
target Azure VMs are hydrated following a failover by using the
replicated data. The Recovery Time Objectives (RTO) and Recovery Point
objectives are minimized since Site Recovery provides continuous
replication for VMware VMs and replication frequency as low as 30
seconds for Hyper-V VMs. In addition, Azure Site Recovery also handles
orchestration of failover and failback processes, which, to large
extent, can be automated. It is also possible to use Azure Site Recovery
for migrations to Azure, although the recommended approach relies on
Azure Migrate instead.

The Adatum Enterprise Architecture team wants to evaluate the use of
Azure Site Recovery for protecting on-premises Hyper-V virtual machines
to Azure VM.

## Objectives

After completing this lab, you will be able to:

-   Configure Azure Site Recovery

-   Perform test failover

-   Perform planned failover

-   Perform unplanned failover

## Lab Environment

Windows Server admin credentials

-   User Name: **QA**

-   Password: **1q2w3e4r5t6y\***

Estimated Time: 60 minutes

### Exercise 0: Prepare the lab environment

The main tasks for this exercise are as follows:

1.  Deploy an Azure VM for the Lab

2.  Configure nested virtualization in the Azure VM

#### Task 1: Deploy an Azure VM for the Lab

1.  Open [**Cloud Shell**](https://shell.azure.com) pane by selecting on
    the toolbar icon directly to the right of the search textbox.

2.  If prompted, select **Bash** .

> **Note**: If this is the first time you are starting **Cloud Shell** and you are presented with the **You have no storage mounted** message, select the subscription you are using in this lab,  and select **Create storage**.

3.  In the toolbar of the Cloud Shell pane, run the following command to create the vm.

```sh
curl -O https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-09/Lab-09-Resources.bash
ls -la Lab-09-Resources.bash
chmod +x Lab-09-Resources.bash
./Lab-09-Resources.bash
```

#### Task 2: Configure nested virtualization in the Azure VM

1.  Select **Virtual machines** and, on the **Virtual machines** blade,
    select **Prot-VM01**.

2.  Select **Networking**.

3.  Select **Connect**, in the drop-down menu, select **RDP**, and then
    click **Download RDP File**.

4.  When prompted, sign in with the following credentials:

-   User Name: **QA**

-   Password: **1q2w3e4r5t6y\***

> **IMPORTANT NOTE:** All the actions you will follow including this step
    will be done on this Remote Computer's Console.

5.  Within the Remote Desktop session run the following command in
    **PowerShell** to create the guest vm to protect.
    
  ```powershell

  cd\
mkdir Lab09
$url = "https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-09/Set-Lab.ps1"
$output = "C:\Lab09\Lab09.ps1"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process Powershell.exe -Argumentlist "-file C:\Lab09\Lab09.ps1"
  ```
> **IMPORTANT NOTE:** Step 5 (above) will take about 8-10 minutes. Please wait without action until you see Hyper-V Console

6.  Open the Virtual Machine Connection window to **2012-R2** on **Hyper-V** Console


    1.  On the **Settings** Page choose **United Kingdom** for *Country or Region* and click **Next**

    2.  On the **License terms** page, select **Accept**.

    3.  Set the password of the built-in Administrator account to **London2021\*** and select **Finish**.

    4.  After Restart, sign in by using the newly set password.

-   Note: Your Guest Vm will be ready after this step.

### Exercise 1: Create and configure an Azure Site Recovery vault

- Important Note: Please make sure you are doing these steps below on the Host Computer not on the Guest OS (2012)

The main tasks for this exercise are as follows:

1.  Create an Azure Site Recovery vault

2.  Configure the Azure Site Recovery vault

#### Task 1: Create an Azure Site Recovery vault


1.  Within the Remote Desktop session to **Prot-VM01**, navigate to
    the [Azure portal](https://portal.azure.com/), and sign in.
    
    
2.  On the **Create Recovery Services vault** blade, specify the
    following settings (leave others with their default values) and
    select **Review + create**:

    | Setting | Value |
    | --- | --- |
    | Subscription | the name of the Azure subscription you are using in this lab |
    | Resource group | the name of a new resource group **Lab-09-Protected** |
    | Vault name | **Protector** |
    | Location | **East Us**  |

3.  On the **Review + create** tab of the **Create Recovery Services
    vault** blade, select **Create**:

> **Note**: By default, the default configuration for Storage
> Replication type is set to Geo-redundant (GRS) and Soft Delete is
> enabled. You will change these settings in the lab to simplify
> deprovisioning, but you should use them in your production
> environments.

#### Task 2: Configure the Azure Site Recovery vault

1.  Open the newly created *Recovery Services vault* **Protector**.

2.  Select **Properties**.

3.  Select the **Update** link under the **Backup Configuration** label.

    -   Set **Storage replication type** to **Locally-redundant**, and
        select **Save** and close the **Backup Configuration** blade.

> **Note**: Storage replication type cannot be changed once you start
> protecting items.

4.  Select the **Update** link under the **Security Settings** label.

    -   Set **Soft Delete** to **Disable**, and select **Save** and
        close the **Security Settings** blade.

### Exercise 2: Implement Hyper-V protection by using Azure Site Recovery Vault

The main tasks for this exercise are as follows:

1.  Prepare Infrastructure

2.  Enable replication

3.  Remove Azure resources deployed in the lab

4.  Review Azure VM replication settings

5.  Perform the Failover of the Hyper-V virtual machine

6.  Remove Azure resources deployed in the lab


#### Task 1: Prepare Infrastructure

1.  Within the Remote Desktop Select Site Recovery **Protector**, under
    **Site Recovery**, click **Getting Started**

2.  Under **Hyper-V Machines to Azure**, section, select **Prepare
    infrastructure**.

-   Note: Your instructor should explain the other options.

3. On the **Prepare infrastructure** blade, you will have 5 steps to
   follow

   1.  **Deployment Planning**
        - Choose **Yes, I have done it** and click **Next**
        
   
   2. **Source Settings**
        - Click No for "Are you using SCVMM to manage your Hyper-V Hosts?*
        - Add Hyper-V Site: **QA-London**
        - Hyper-V Servers
          -  Click **Add Hyper-V Server**
      
                -   Click download the installer to download the installer
      
                -   Click the big blue button to download the registration file

          - Launch the downloaded **AzureSiteRecoveryProvider.exe** file. This will start the installation wizard.
      
          - On the Microsoft Update page, select **Off** and select **Next**.
      
          - On the Provider installation page, select **Install**.

          - Click **Register** when the wizard asks. Select Browse, navigate to the **Downloads**, select the *vault credentials file*, and click **Open**.
          
          - Click **Finish** when the installation completes
       
   3.  **Target Settings**
        - This Automatically chooses the existing subscription and checks if you have available storage account at the location. Leave with the default setting. Click **Next**.
        
   4.  **Replication Policy**
       - **Create new policy and associate**. (Leave default settings, ensure you assign a Name and set initial Replication as **Immediately**)
         - Name: Provide a name e.g: **Rep-Pol**
           - Copy Frequency
           - Recovery point retention in hours
           - App-Consistent snapshot frequency in hours
           - Initial Replication start time: **Immediately**	
            - Click **Next** after completed	
            
    5.  **Review**  
          * Click **Prepare**	
4. This will divert you back to **Protector \| Site Recovery** blade. Else, navigate yourself.

#### Task 2: Enable replication

1.  Under **Protector \| Site Recovery**, click **Getting Started**

2.  Under **Hyper-V Machines to Azure**, section, select **Enable
    replication**.

3. On the **Enable Replication** blade, you will have 6 steps to follow

   1. **Source Environment**

      - Choose **QA-London** and click Next
            

   2. **Target Environment**

      - **Subscription**
        - You can even choose a different subscription, alas it is
              under the same **Tenancy**

      - **Post-Failover Resource Group**
        - Choose the RG. **Lab-09-Protected** for this exercise. This menu does not allow you to create a new RG. You can
              create on a different menu and refresh the page to see here.    
      - **Post-failover deployment model.**
        - Choose **Resource Manager**. This is the default setting
      - **Storage**
        - Choose the storage account ending with **prt01**
      - **Network**
        - Virtual Network: **Prt-VNet**
        - Subnet: **SN02**
      - Click **Next**

   3. **Virtual Machine Selection** 
    
        - Choose 2012-R2 and click **Next**

   4. **Replication Settings**
        - Choose OS Type as Windows. (this is for drivers for that OS) and click **Next**
         
   5. **Replication Policy**
        - Leave the default selected Replication Policy and click **Next** 
   
   6. **Review**
        - Review the settings and click **Enable Replication**
   
4.  This will take approximately 5-7 minutes. You can follow the steps
    by clicking notifications on the dark blue bar of azure portal.

5.  Good time to have a nice coffee break

6.  Also, you can follow the replication progress on Hyper-V console, by
    the status of the 2012-R2 virtual machine.

#### Task 3: Review Azure VM replication settings


1.  In the Azure portal, navigate to the **Protector** blade, under
    Overview \| Site Recovery and select **Replicated items**.

2.  On **Replicated items** blade, ensure that 2012-R2 VM is listed
    as **Healthy** and that its **Status** is listed as either Enabling
    protection or **Protected.**

> **Note**: You will need to wait until status is listed as
> **Protected** before the next step. This might take additional 5
> minutes

3.  Select the **2012-R2** entry.

4.  Click **Compute and Network** and click **Edit.** Update the
    properties as below.

    -   Resource Group: **Lab-09-Protected**

    -   Size: Standard **B2s** **(2 cores 4GB Memory, 3 NICs)**

    -   Virtual Network: Prt-VNet

    -   Azure Hybrid Benefit: **Yes,** and **Confirm**

5.  Click **Save**

6.  Click **Overview**

#### Task 4: Perform a Test failover of the Hyper-V virtual machine

1.  Select **Test failover**.

2.  On the **Test failover** blade, specify the following settings

    -   Choose a recovery point: **Leave as default** option for latest
        processed.

    -   Azure virtual network: **Prt-VNet**

3.  Click **OK**

4.  Click **Notifications** and click **Starting the test failover**
    link. Observe the status of the **Test failover** job. Wait until
    all the steps listed as **Successful**.

5.  In the Azure portal, ensure that newly provisioned virtual
    machine **2012-R2-test** is listed.

6.  Navigate back to the **Protector.**

7.  Click **Replicated Items** and click **2012-R2** and select
    ***Cleanup** **test failover***.

8.  Select the checkbox for *Testing is complete. Delete test failover
    virtual machine(s)* and select **OK**.

9.  Follow the notifications until the clean-up completed. (this will
    delete the test vm)

#### Task 5: Perform the Failover of the Hyper-V virtual machine

1.  Navigate back to the **Protector.** Click **Replicated Items** and
    click **2012-R2** 

2.  Select **Planned failover**.

3.  On the **Planned failover** blade, note that the failover direction
    settings are already set and not modifiable. Click **OK.**

4.  Follow the notifications until the failover completed.

5.  In the Azure portal, ensure that newly provisioned virtual
    machine **2012-R2** is listed.

6.  As on the earlier task, it was showing as 2012-R2-test, now it is
    the real Protected virtual machine.

7.  Close the **Failover** blade.

#### Task 6: Remove Azure resources deployed in the lab

1.  Navigate back to the **Protector.**

2.  Click **Site Recovery infrastructure**

3.  Navigate to **Hyper-V Hosts** and delete the **Hyper-V Host**

    -   If you can't find the option click the ellipses to find the
        delete option

4.  After deleted, Navigate to **Hyper-V Sites** and delete the Hyper-V
    Site **QA-London**

5.  From the Cloud Shell pane, run the following to list the resource
    group you created in this exercise:

```sh
az group list --query "[?contains(name,'Lab-09')]".name --output tsv 

```

> **Note**: Verify that the output contains only the resource group you
> created in this lab. This group will be deleted in this task.

6.  From the Cloud Shell pane, run the following to delete the resource
    group you created in this lab
```sh
az group list --query "[?contains(name,'Lab-09')]".name --output tsv | xargs -L1 bash -c 'az group delete --name $0 --no-wait --yes'
```                                                                    

> Note: The Remote Computer you have been using during this lab will be automatically deleted
