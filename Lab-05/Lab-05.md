---
lab:
    title: '5: Implementing and Configuring Azure Storage File and Blob Services'
    module: 'Module 5: Implement Storage Accounts'
---

# Lab: Implementing and Configuring Azure Storage File and Blob Services
# Student lab manual

## Lab scenario

Adatum Corporation hosts large amounts of unstructured and
semi-structured data in its on-premises storage. Its maintenance becomes
increasingly complex and costly. Some of the data is preserved for
extensive amount of time to address data retention requirements. The
Adatum Enterprise Architecture team is looking for inexpensive
alternatives that would support tiered storage, while, at the same time
allow for secure access that minimizes the possibility of data
exfiltration. While the team is aware of practically unlimited capacity
offered by Azure Storage, it is concerned about the usage of account
keys, which grant unlimited access to the entire content of the
corresponding storage accounts. While keys can be rotated in an orderly
manner, such operation needs to be carried out with proper planning. In
addition, access keys constitute exclusively an authorization mechanism,
which limits the ability to properly audit their usage.

To address these shortcomings, the Architecture team decided to explore
the use of shared access signatures. A shared access signature (SAS)
provides secure delegated access to resources in a storage account while
minimizing the possibility of unintended data exposure. SAS offers
granular control over data access, including the ability to limit access
to an individual storage object, such as a blob, restricting such access
to a custom time window, as well as filtering network access to a
designated IP address range. In addition, the Architecture team wants to
evaluate the level of integration between Azure Storage and Azure Active
Directory, hoping to address its audit requirements. The Architecture
team also decided to determine suitability of Azure Files as an
alternative to some of its on-premises file shares.

To accomplish these objectives, Adatum Corporation will test a range of
authentication and authorization mechanisms for Azure Storage resources,
including:

-   Using shared access signatures on the account, container, and
    object-level

-   Configuring access level for blobs

-   Using storage account access keys

-   Using Service Endpoints

## Objectives

After completing this lab, you will be able to:

-   Implement authorization of Azure Storage blobs by leveraging shared
    access signatures

-   Implement authorization of Azure Storage blobs by leveraging Azure
    Active Directory

-   Implement authorization of Azure Storage file shares by leveraging
    access keys

-   Implement authorization of Azure Storage account by leveraging
    Service Endpoints.

## Lab Environment

Estimated Time: 45 minutes

### Exercise 0: Prepare the lab environment

The main tasks for this exercise are as follows:

1.  Deploy Azure VMs and Virtual Networks

#### Task 1: Deploy Azure VMs and Virtual Networks

1.  Start a web browser, navigate to the [Azure
    portal](https://portal.azure.com/), and sign in.

2.  Open **Cloud Shell** pane by selecting on the toolbar icon directly
    to the right of the search textbox.

3.  If prompted to select either **Bash** or **PowerShell**,
    select **Bash**.

4.  Run the command

   ```sh
curl -O https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-05/Lab-05-Resources.bash
ls -la Lab-05-Resources.bash
chmod +x Lab-05-Resources.bash
./Lab-05-Resources.bash
```

> **Note**: Do not wait for the deployment to complete but instead proceed
to the next exercise. 
> The deployment should take less than 5 minutes.

5.  In the Azure portal, close the **Cloud Shell** pane.

### Exercise 1: Configure Azure Storage account authorization by using shared access signature.

The main tasks for this exercise are as follows:

1.  Create an Azure Storage account

2.  Configure VM

3.  Generate an account-level shared access signature

4.  Create a blob container by using Azure Storage Explorer

5.  Upload a file to a blob container by using AzCopy

6.  Access a blob by using a blob-level shared access signature

#### Task 1: Create an Azure Storage Account

1.  In the Azure portal, select **+ Add** and search for and
    select **Storage Accounts** 

2.  Specify the following settings (leave others with their default
    values): and Select **Next: Networking \>**
    
    

    | Setting | Value | 
    | --- | --- |
    | Subscription | the name of the Azure subscription you are using in this lab |
    | Resource group | the name of a new resource group **AZ-303Lab-05** |
    | Storage account name | any globally unique name between 3 and 24 in length consisting of letters and digits |
    | Location | **East Us**  |
    | Performance | **Standard** |
    | Account kind | **StorageV2 (general purpose v2)** |
    | Replication | **Locally redundant storage (LRS)** |

    

3.  On the **Networking** tab, accept the default options and
    select **Next: Data protection \>**

4.  On the **Data protection** tab, accept the defaults, select **Next:
    Advanced \>**.

5.  On the **Advanced** tab, accept the defaults, select **Review +
    Create**, wait for the validation process to complete and
    select **Create**.

> **Note**: Wait for the Storage account to be created. This should take
> about 2 minutes.

#### Task 2: Configure VM

**Note**: Ensure that the deployment of the Azure VM you initiated at
the beginning of this lab has completed before you proceed.

1.  In the Azure portal, search for and select **Virtual machines**,
    and, select **L05-VM01**.

2.  On the **L05-VM01**, select **Connect**, select **RDP**, and then
    **Download RDP File**.

3.  When prompted, sign in with the following credentials:

> User: **QA** Password: **1q2w3e4r5t6y\***

4.  Within the RDP session to **L05-VM01**, run the command on
    PowerShell console.

 ```powershell
cd\
mkdir SC
$url1 = "https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-05/VMSetting.ps1"
$output1 = "C:\SC\VMSetting.ps1"
Invoke-WebRequest -Uri $url1 -OutFile $output1
Start-Sleep -s 3
Start-Process Powershell.exe -Argumentlist "-file $output1"
   ```
 #### IMPORTANT NOTE: Please do the rest of the exercises on this remote Machine 

#### Task 3: Generate an account-level shared access signature

1.  Sign in to Azure Portal on Chrome.

2.  Navigate to the first storage account, select **Access keys**.

> **Note**: Each storage account has two keys which you can
> independently regenerate. Knowledge of the storage account name and
> either of the two keys provides full access to the entire storage
> account.

3.  Select **Shared access signature** and review the settings.

4.  Specify the following settings (leave others with their default
    values):
    
    | Setting | Value | 
    | --- | --- |
    | Allowed services | **Blob** |
    | Allowed resource types | **Service** and **Container** |
    | Allowed permissions | **Read**, **List** and **Create** |
    | Blob versioning permissions | disabled (uncheck the box) |
    | Start | 24 hours before the current time in your current time zone | 
    | End | 24 hours after the current time in your current time zone |
    | Allowed protocols | **HTTPS only** |
    | Signing key | **key1** |

5.  Select **Generate SAS and connection string**.

> **Note:** You can upload the file after enabling object option. However this will be available with the new Blob service SAS URL.

6.  Note the value of **Blob service SAS URL** onto a notepad.

#### Task 4: Create a blob container by using Azure Storage Explorer

1.  Navigate to the download page of [Azure Storage
    Explorer](https://download.microsoft.com/download/A/E/3/AE32C485-B62B-4437-92F7-8B6B2C48CB40/StorageExplorer.exe)

2.  Install Azure Storage Explorer with the default settings.

3.  On the Azure Storage Explorer Console, in the **Connect to Azure
    Storage** window, select **Use a shared access signature (SAS)
    URI** and select **Next**.

4.  In the **URI** text box, paste the value you copied into Notepad,
    and select **Next**.

> **Note**: You can append **-blob** to distinguish from other connections.

5.  In the **Connection Summary** window, select **Connect**.

6.  In the **EXPLORER** pane, navigate to the storage account entry,
    expand it and note that you have access to *Blob Container* endpoint
    only.

7.  Right-click, and select **Create Blob Container**, and create a new
    blob container with the name **container01**.

8.  Select **container01** and choose **Upload Files**,

9.  Select the ellipsis button and select **C:\\Windows\\system.ini**
    and click **Upload**

10. Observe the error message displayed in the **Activities** list.

> **Note**: This is expected, since the shared access signature does not provide object-level permissions.

11. Leave the Azure Storage Explorer window open.

#### Task 5: Upload a file to a blob container by using AzCopy

1.  Download [AzCopy](https://aka.ms/downloadazcopy-v10-windows) onto
    your remote computer.

2.  Open the downloaded file and copy **azcopy** file to C: drive

3.  Open PowerShell window and type **cd \\** to go to c:\ drive

4.  Type and run **.\azcopy** to check if azcopy command works fine.

5.  Leave the PowerShell window running

6.  Get back to the browser window, on the **Shared access
    signature** blade, provide the following additional settings (leave
    others with default values):
    
    
    | Setting | Value | 
    | --- | --- |
    | Allowed services | **Blob** |
    | Allowed resource types | **Object** |
    | Allowed permissions | **Read**, **Create** |
    | Blob versioning permissions | disabled (uncheck the box) |
    | Start | 24 hours before the current time in your current time zone | 
    | End | 24 hours after the current time in your current time zone |
    | Allowed protocols | **HTTPS only** |
    | Signing key | **key1** |


7.  Click **Generate SAS and connection string**.

8.  Note **SAS Token** to a notepad.

9.  Click Overview and note **Storage Account Name**

10. Go back to **PowerShell** prompt you opened before.

11. On the PowerShell window you opened earlier in this task, run the
    command below to create an html file to upload via AzCopy

 ```powershell
New-Item -Path './az303Lab-05.html'
Set-Content './az303Lab-05.html' '<h3> Hello from Windows Server this file is uploaded via AzCopy authenticated by SAS</h3>' 
 ```

12. Replace the \"\<The_Name_of_the_storage_Account\>\" placeholder with
    the storage account name you noted on step 9
 ```powershell
$storageAccountName = "<The_Name_of_the_storage_Account>"
 ```
13. Replace the \<sas_token\> placeholder with the value of the shared
    access signature you copied to notepad on step 8.
    
```powershell
.\azcopy cp './az303Lab-05.html' "https://$storageAccountName.blob.core.windows.net/container01/az303Lab-05.html <sas_token>"
```
14. Review the output generated by AzCopy and verify that the job
    completed successfully.

15. In the browser window, on the storage account blade, in the **Blob
    service** section, select **Containers**.

16. In the list of containers, select **container01** verify
    that **az303Lab-05.html** is in the list of blobs.

17. Close the PowerShell window.

#### Task 6: Access a blob by using a blob-level shared access signature

1.  On the browser window, under **container01**, click **Change access
    level**, verify that is set to **Private (no anonymous access)**,
    and click **Cancel**.

> **Note**: If you want to allow anonymous access, you can set the public access level to **Blob (anonymous read access for blobs only)** or **Container (anonymous read access for containers and blobs)**

2.  On the **container01** blade, select **az303Lab-05.html**.

3.  Click **Generate SAS**, and then select **Generate SAS token and
    URL**.

4.  Copy the value of the **Blob SAS URL** into Clipboard.

5.  Open a new tab in the browser window and navigate to the URL you
    copied into Clipboard in the previous step.

6.  Verify that the page with *Hello Message* appears in the browser
    window.

> **Note**: More options are available E.g Allowed IP address...

### Exercise 2: Implement Azure Files

The main tasks for this exercise are as follows:

1.  Create an Azure Storage file share

2.  Map a drive to an Azure Storage file share from Windows

#### Task 1: Create an Azure Storage file share

1.  In the browser window on the remote server, navigate back to the **container01** blade.

2.  On the overview page select **File shares**.

3.  Select **+ File share** and create a file share with the following settings:

> Name: **Share01** Quota: **1GiB**

#### Task 2: Map a drive to an Azure Storage file share from Windows

1.  Select the newly created file share and select **Connect**.

2.  Ensure that the **Windows** tab is selected, and select **Copy to
    clipboard**.

> **Note**: Azure Storage file share mapping uses the storage account name and one of two storage account 
keys as the equivalents of user name and password, respectively in order to gain access to the target share.

3.  On the remote computer, open a PowerShell prompt, paste and execute
    the script you copied to clipboard.

4.  Verify that the script completed successfully. (Hit Enter if
    necessary)

5.  Start File Explorer, navigate to **Z:** drive and verify that the
    mapping was successful.

6.  In File Explorer, create a folder named **Folder01** and a text file
    inside the folder named **File01.txt**.

7.  Switch back to the browser window, on the **share01** blade,
    click **Refresh**, and verify that **Folder1** appears in the list
    of folders.

8.  Select **Folder1** and verify that **File1.txt** appears in the list
    of files.

### Exercise 3: Service Endpoints

The main tasks for this exercise are as follows:

1.  Assign Service Endpoints.

2.  Test the Storage Endpoints Access from L05-VM01

3.  Test the Storage Endpoints Access from L05-VM02

#### *Task 1: Assign Service Endpoints

1.  On the remote machine, Navigate to Storage Account

2.  Click **Firewalls and Virtual Networks** under Settings of the
    Storage Account

3.  Choose **Selected Networks**

4.  Click **Add an Existing Virtual Network**

    -   Virtual Network **Lab05-VNet01**

    -   Subnets **SNA02**

    -   Click **Enable**

    -   After Enabled, Click **Add** (Same dialog box)

    -   Uncheck **Allow trusted Microsoft Services to access this
        Storage Account**

    -   Click **Save**

#### Task 2: Test the Storage Endpoints Access from L05-VM01

1.  Click **Overview** and click **Containers**

2.  Click **Container01**

3.  You won't be able to reach the content

4.  Check the z:\\ drive access.

5.  This will also fail.

**Note**: This is because only SNA02 has the permission to reach the
Storage Account content within the internal connections from Azure
resources.

#### Task 3: Test the Storage Endpoints Access from L05-VM02

1.  In the Azure portal, search for and select **Virtual machines**,
    and, select **L05-VM02**.

2.  On the **L05-VM02**, select **Connect**, select **RDP**, and then
    **Download RDP File**.

3.  When prompted, sign in with the following credentials:

> User: **QA** Password: **1q2w3e4r5t6y\***

4.  Within the RDP session to **L05-VM02**, run the command on
    PowerShell console.
    
```powershell
cd\
mkdir SC
$url1 = "https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-05/VMSetting.ps1"
$output1 = "C:\SC\VMSetting.ps1"
Invoke-WebRequest -Uri $url1 -OutFile $output1
Start-Sleep -s 3
Start-Process Powershell.exe -Argumentlist "-file $output1"
   ```

5.  Sign in to [**Azure Portal**](https://portal.azure.com/) on Chrome.

6.  Navigate to the **Storage Account**,

7.  Click **Overview** and click **Containers**

8.  Ensure that you can access the Storage Account content that you
    could not access from VM01

9.  You won't be able to access the Storage Account content from your
    own computer.
