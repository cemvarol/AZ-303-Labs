---

    'Managing Azure AD Authentication and Authorization'
    
---

## Lab Environment

Windows Server admin credentials

-  User Name: **QA**

-  Password: **1q2w3e4r5t6y***

Estimated Time: 60 minutes

## Instructions

### Exercise 0: Prepare the lab environment

The main tasks for this exercise are as follows:

1. Create a Vm for a Domain Controller

1. Promote the Vm as your domain controller

1. Create Domain Accounts


#### Task 1: Create a Vm for a Domain Controller

1. Navigate to the [Azure portal](https://portal.azure.com), and  [Azure Shell](https://shell.azure.com)   sign in by your credentials.

1. In the **Cloud Shell**, select  **Bash** , run the command below to create a new vm for this exercise

    ```powershell
    curl -O https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/AAD/dcvm.bash
    ls -la dcvm.bash
    chmod +x dcvm.bash
    ./dcvm.bash
    ```
      > **Note**: Wait until the vm is created. This will take 4-6 minutes.



#### Task 2: Promote the Vm as your domain controller

1.  Select **Virtual machines** and, on the **Virtual machines** blade, select **US-DC01**.

2.  Select **Networking**.

3.  Select **Connect**, in the drop-down menu, select **RDP**, and then click **Download RDP File**.

4.  When prompted, sign in with the following credentials:

    | Setting | Value |
    | --- | --- |
    | User Name | **QA** |
    | Password | **1q2w3e4r5t6y*** |

> **Important Note:** All the actions you will follow including this step will be done on this Remote Computer's Console.

5.  Within the Remote Desktop session run the following command in **PowerShell** to promote to a Domain Controller.
    
  ```powershell

  cd\
mkdir AADLab
$url = "https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/AAD/Set-Lab.ps1"
$output = "C:\AADLab\Set-Lab.ps1"
Invoke-WebRequest -Uri $url -OutFile $output
Start-Process Powershell.exe -Argumentlist "-file C:\AADLab\Set-Lab.ps1"
  ```
> **Note**: After this script is run, the VM will be restarted automatically. You will need to re-connect to this vm on the next Task.

#### Task 3: Create Local Domain Accounts

1. Please connect to the same VM again. You can follow the steps 1-4 of Task 2.

1. On the desktop of your profile, right click the Create AD Users.ps1 file and choose **Run with Powershell**

1. Accept by typing A and hit Enter if any Powershell Policy is asked.

1. Script will ask for **How many users to create** Provide 50 as the number of users to create, and hit Enter. 

1. Observe the created users and groups in Local Domain.

> **Note**: This will create 50 users. They will be under OUs, and set for their group memberships. Observe the created users on Active Directory users and Computers. this will also create a user name **OnPremAdmin**

### Exercise 1: Configure an Azure AD tenant

The main tasks for this exercise are as follows:

1. Activate and assign Azure AD Premium P2 licensing

1. Create and configure Azure AD users


#### Task 1: Activate and assign Azure AD Premium P2 licensing

1. Back on the Azure portal, navigate to **Azure Active Directory**, click **Licenses**.

1. On the **Licenses | Overview** blade, select **All products**, select **+ Try/Buy**.

1. On the **Activate** blade, in the **Azure AD Premium P2** section, select **Free trial** and then select **Activate**. 

1. On the **Activate** blade, in the  **ENTERPRISE MOBILITY + SECURITY E5** section, select **Free trial** and then select **Activate**. 


#### Task 2: Create and configure Azure AD users

1. On the **Azure Active Directory**

1. Navigate to the **Users - All users** blade, and then select **+ New user**.

1. On the **New user** blade, create user with the following settings (leave others with their defaults):

    | Setting | Value |
    | --- | --- |
    | User name | **Superman** |
    | Name | **Clark Kent** |
    | Auto-generate password | enabled |
    | Show password | enabled |
    | Roles | **Global administrator** |
    
    >**Note**: Record the full user name (including the domain name) and the auto-generated password. You will need it later in this task.

1. Open an **InCognito** browser window and sign in to the [Azure portal](https://portal.azure.com) using the newly created user account. When prompted to update the password, change the password to **1q2w3e4r5t6y*** 


### Exercise 2: Integrate AD DS forest with an Azure AD tenant

The main tasks for this exercise are as follows:

1. Assign a custom domain name to the Azur AD tenant

1. Install Azure AD Connect

1. Configure Azure AD Connect

1. Check the synchronized user accounts

1. Optional Task

#### Task 1: Assign a custom domain name to the Azur AD tenant

1.  On the **Azure Active Directory**

1. Select **Custom domain names**.

1. Identify the primary, default DNS domain name associated with the Azure AD tenant. 

    >**Note**: Record the value of the primary DNS name of the Azure AD tenant. You will need it in the next task.

1. Select **+ Add custom domain**.

1. Type **Aurian.club**, and select **Add domain**. 

1. On the **Aurian.club** blade, review the information necessary to perform verification of the Azure AD domain name and close the blade.

    > **Note**: You will not be able to complete the validation process because you do not own the **Aurian.club** DNS domain name. This will *not* prevent you from synchronizing the **Aurian.club** Active Directory domain with the Azure AD tenant. You will use for this purpose the default primary DNS name of the Azure AD tenant (the name ending with the **onmicrosoft.com** suffix), which you identified earlier in this task. However, keep in mind that, as a result, the DNS domain name of the Active Directory domain and the DNS name of the Azure AD tenant will differ. This means that Aurian users will need to use different names when signing in to the Active Directory domain and when signing in to Azure AD tenant.
   
   > **Note**: As explained earlier, this is expected, since you could not verify the custom Azure AD DNS domain **Aurian.club**.

#### Task 2:  Install Azure AD Connect

1. Within the Remote Desktop session to **US-DC01**, Navigate to [Azure portal](https://portal.azure.com), select **Azure Active Directory** and click **Azure AD Connect**.

1. Select the **Download Azure AD Connect** link. You will be redirected to the **Microsoft Azure Active Directory Connect** download page, select **Download**.

1. After downloaded, **Run** to start the installation for **Microsoft Azure Active Directory Connect**.

1. On the first page of the **Microsoft Azure Active Directory Connect** wizard, select the checkbox **I agree to the license terms and privacy notice** and select **Continue**.

1. On the *Express Settings* step Choose **Use Express Settings**.

1. On the **Connect to AZure AD** step, provide the login information of newly created AzAD account and click **Next**. (Superman) *This is an account has the Global Administrator Role*

1. On the **Connect to ADDS** page, provide the login information of *Enterprise Administrator* account **AURIAN\OnPremAdmin** with password *London2020** *This account is created by the script*

    | Setting | Value |
    | --- | --- |
    | User Name | **AURIAN\OnPremAdmin** |
    | Password | *London2020** |
    
1. On the **Azure AD sign-in configuration** page, note the warning stating **Users will not be able to sign-in to Azure AD with on-premises credentials if the UPN suffix does not match a verified domain name**, enable the checkbox **Continue without matching all UPN suffixes to verified domain**, and click **Next**.
    
1. On the **Ready to configure** page, **UNCHECK** the **Start the synchronization process when configuration completes** checkbox is selected and select **Install**.

    > **Note**: Installation should take about 2-4 minutes.
    
1. **Configuration Complete** step, click **Exit** to complete the installation.

1. Navigate to Azure Active Directory, click **Users**, ensure that the new account with the name **On-Premises Directory Synchronization Service Account** is created.

#### Task 3:  Configure Azure AD Connect

1. Double-Click the **Azure Ad Connect** to configure the settings of Azure AD Connect.

1. On the **Welcome to Azure AD Connect** step, click **Configure**

1. On the **Additional Taks** step, choose **Customize Synchronization Options**, and click **Next**

1. On the **Connect to AZure AD** step, provide the password of Azure AD account and click **Next**. (superman) 

1. On the **Connect your directories** step, click **Next**.

1. On the **Domain and OU Filtering** step, choose **Sync Selected Domains and OUs**. Expand the aurian.club domain and uncheck the box next to domain name to clear all the boxes. 

1. Under *Sync Selected Domains and OUs* 
    - Choose either **Tens or Twenties** (Proves that you can choose nested level of OUs to sync individually)
    - Choose other OUs, e.g. **Thirties, Forties** etc.
    - Choose **Groups**

1. Click **Next**

1. On the **Optional Features** step, check **Password Writeback** and click **Next**

1. On the **Ready to Configure** step, **CHECK** the box for **Start the synchronization process when configuration completes** and click **Configure**

1. On the **Configuration Complete** step, click Exit.

#### Task 4: Check the synchronized user accounts

1. Navigate to the **Users**, ensure that users are synchronized.

1. Under *Azure Active Directory* click **Groups** blade, choose **All AdUsers** click **Member**. Observe the sycnhronized users. 

1. Within the Remote Desktop session to **US-DC01**, double click **Active Directory users and Computers** shortcut, navigate to Groups, and double click the **All AdUsers** group. Click *Members*.

1. Compare the difference between the members of Azure AD group and Local AD group called **All AdUsers**

 > **Note**: Groups are also objects to synchronize. Only the synchronized members are listed on Azure AD Group, however you have 50 members on-premises group has. 
 
 1. Navigate to the **Grops**, click **+ New Group** to add a new group. 
    | Setting | Value |
    | --- | --- |
    | Group Type | **Security** |
    | Group Name | **Thirties** |
    | Group Decription | Optional Value, can be left empty |
    | Membership Type | **Dynamic User** |
 
1. Click  **Add Dynamic Query**

1. Under **Property** choose the **department** option from the drop-down menu.

1. Under **Operator** choose the **Contains** option from the drop-down menu.

1. Under **Value** type **Thi** only and click **Save**.

>**Note:** If save seems passive, click the **Rule Syntax** field and Save will be available. 

1. You will be diverted back to New Group Create page,click **Create**.

>**Note:** Dynamic Group will be populated depending on the attribute value of Local AD accounts.

1. Within the Remote Desktop session to **US-DC01** Open **Active Directory users and Computers** console

1. Go to the OU for **3-Thirties** and choose random one or more accounts, and change the value of Department with something else but Thirties.
    -Under **Organization** Tab, Change the value to for **Department** Attribute.
    
> **Note** That change will reflect to Azure Active Directory on the next synchronization cycle. This happens automatically two times in every hour. You can trigger manually if you prefer. 

#### Optional Task

1. Within the Remote Desktop session to **US-DC01**, start *Windows PowerShell* and, run the following to start Azure AD Connect delta synchronization:

   ```powershell
   Import-Module -Name 'C:\Program Files\Microsoft Azure AD Sync\Bin\ADSync\ADSync.psd1'

   Start-ADSyncSyncCycle -PolicyType Delta
   ```

### Exercise 3: Implement Azure AD conditional access

The main tasks for this exercise are as follows:

1. Disable Azure AD security defaults.

1. Create an Azure AD conditional access policy

1. Verify Azure AD conditional access

1. Remove Azure resources deployed in the lab


#### Task 1: Disable Azure AD security defaults.

1. Navigate to **Azure Active Directory**, select **Properties**.

1. Select the **Manage Security defaults** link at the bottom of the page.

1. Ensure that **Enable Security defaults** set to **No**


#### Task 2: Create an Azure AD conditional access policy

1. Navigate to **Azure Active Directory**, select **Security**, click **Conditional Access**

1. On the **Conditional Access | Policies** blade, select **+ New policy**.

1. On the **New** blade, in the **Name** text box, type **Azure Portal MFA Enforcement**. 

1. In the **Assignments** section, select **Select Users and groups**, 
    - On the **Include** tab, check **Users and groups** checkbox
    - Select **user23** Group, and click **Select**. (Use the search bar if list is too crowded)

1. In the **Cloud apps or actions** section, select **Select Apps**
   - On the **Include** tab, select **Select apps** 
   - Select **Microsoft Azure Management** checkbox, and click **Select**.

1. In the **Access Controls** section, select **Grant**, 
   - On the **Grant** blade, ensure that the **Grant** option is selected 
   - Select **Require Multi-Factor Authentication** checkbox and select **Select**.

1. Back on the **New** blade, set the *Enable policy* switch to **On** and click **Create**.


#### Task 3: Verify Azure AD conditional access

1. Within the Remote Desktop session to **US-DC01**, start a new **Incognito** window and navigate to the [Access Panel Applications Portal](https://account.activedirectory.windowsazure.com)

1. When prompted, sign in by using the synchronized Azure AD account of the *choose any account you prefer*, using the full user name you recorded in the previous exercise.

    | Setting | Value |
    | --- | --- |
    | User Name | **user23@AZURE-AD-DOMAIN-NAME** |
    | Password | **London2020*** |

1. Verify that you can successfully sign in to the Access Panel Applications portal. 

1. In the same browser window, open a new tab and navigate to the [Azure portal](https://portal.azure.com)

1. Note that, this time, you are presented with the message **More information required**, click **Next**
> **Note** You won't be asked to provide your credentials, because you already have an authenticated session on the other tab within the same browser window. However the conditional access policy will check for Azure Portal Access.

6. You will be redirected to the **Additional security verification** page,

    > **Note**: Completing the multi-factor authentication configuration is optional. If you proceed, you will need to designate your mobile device as an authentication phone or to use it to run a mobile app.

### Exercise 3: Remove Azure resources deployed in the lab

#### Task 1: Delete the Resources

1. Delete the Resource Group **AADLab**

   >**Note**: This will automatically delete the remote server and your remote session will be terminated.

1. You can delete the users synched to Azure Active Directory. (optional step) 

