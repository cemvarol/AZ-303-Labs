---
lab:
    title: '12B: Configuring a Message-Based Integration Architecture'
    module: 'Module 12: Implement an Application Infrastructure'
---

# Lab: Configuring a Message-Based Integration Architecture

# Student lab manual

## Lab scenario

Adatum Corporation wants to implement custom monitoring of changes to a
resource group

## Objectives

After completing this lab, you will be able to:

-   Create an Azure logic app

-   Configure integration of an Azure logic app and an Azure event grid

## Lab Environment

Estimated Time: 30 minutes

## Lab Setup

Before starting the lab exercises, please go to
[outlook.com](https://outlook.com) and send an email to your account
used in this lab. Outlook will verify your account, to be able to send
emails. This will be necessary in this lab.\
Please do not skip this step.

### Exercise 1: Set up the lab environment that consists of an Azure storage account and an Azure logic app

The main tasks for this exercise are as follows:

1.  Create an Azure logic app

2.  Create an Azure AD service principal

3.  Assign the Reader role to the Azure AD service principal

4.  Register the Microsoft.EventGrid resource provider

#### Task 1: Create an Azure logic app

1.  From Azure Portal, Click **Create a Resource**.

2.  Search for **Logic App**

3.  Create an instance of **Logic App** with the following settings:

    -   Resource group: a new resource group named **AZ-303Lab-12b**

    -   Name: **LogApp-12b**

    -   Region: **EastUs**

    -   Log Analytics: **Off**

4.  Click **Review + Create**

5.  After validated click **Create**

6.  Wait until the app is provisioned. This will take about a minute.

#### Task 2: Create an Azure AD service principal

1.  Start a **PowerShell** session within the **Cloud Shell**.

2.  From the Cloud Shell pane, run the following to create a new Azure
    AD application that you will associate with the service principal
    you create in the subsequent steps of this task:
    
   ```sh
$password = '1q2w3e4r5t6y*'
$securePassword = ConvertTo-SecureString -Force -AsPlainText -String $password
$aadApp30312b = New-AzADApplication -DisplayName 'aadApp30312b' -HomePage 'http://aadApp30312b' -IdentifierUris 'http://aadApp30312b' -Password $securePassword
   ```

3.  From the Cloud Shell pane, run the following to create a new Azure
    AD service principal associated with the application you created in
    the previous step:

 ```sh
New-AzADServicePrincipal -ApplicationId $aadApp30312b.ApplicationId.Guid
 ```

4.  In the output of the **New-AzADServicePrincipal** command, note the
    value of the **ApplicationId** property. You will need this in the
    next exercise of this lab.

> **E.g:** ApplicationId: 0f83fde0-eef3-4d8d-8fe4-0170ffc0a12d

5.  From the Cloud Shell pane, run the following command.

 ```sh
Get-AzSubscription
```

6.  Note the value of the **TenantId** property of the Azure AD tenant
    associated with that subscription. You will also need them in the
    next exercise of this lab

> **E.g:** 23b4659a-7355-43a3-885d-ac33078e0f3b

7.  Close the Cloud Shell pane.

#### Task 3: Assign the Reader role to the Azure AD service principal

1.  In the Azure portal, navigate to **Home**.

2.  On the Azure Home Page click **Subscriptions**.

3.  Choose your subscription.

4.  On the Subscription blade, click **Access control (IAM)**.

5.  Click **+Add** and Assign the **Reader** role, select
    **aadApp30312b** service principal to assign the role to.

6.  Click **Save**

#### Task 4: Register the Microsoft.EventGrid resource provider

1.  In the Azure portal, reopen the **PowerShell** session within
    the **Cloud Shell**.

2.  From the Cloud Shell pane, run the following to register the
    Microsoft.EventGrid resource provider:

```sh
Register-AzResourceProvider -ProviderNamespace Microsoft.EventGrid
```

3.  Close the Cloud Shell pane.

> **Result**: After you completed this exercise, you have created a logic
app that you will configure in the next exercise of this lab, and an
Azure AD service principal that you will reference during that
configuration.

### Exercise 2: Configure Azure logic app to monitor changes to a resource group.


The main tasks for this exercise are as follows:

1.  Add a trigger to the Azure logic app

2.  Add an action to the Azure logic app

3.  Test the logic app

#### Task 1: Add a trigger to the Azure logic app

1.  In the Azure portal, navigate to the newly created Resource group
    AZ-303Lab-12b.

2.  Open the **Logic App Designer** blade of the newly provisioned Azure
    logic app.

3.  Click **Blank Logic App**. This will create a blank designer
    workspace and display a list of connectors and triggers to add to
    the workspace.

4.  Search for **Event Grid** triggers and, in the list of results,
    click the **When a resource event occurs** Azure Event Grid trigger
    to add it to the designer workspace.

5.  In the **Azure Event Grid** tile, click the **Connect with Service
    Principal** link, specify the following values, and
    click **Create**:

    -   Connection Name: **eg30312b**

    -   Client ID: the **ApplicationId** property you identified in the
        previous exercise

    -   Client Secret: **1q2w3e4r5t6y\***

    -   Tenant: the **TenantId** property you identified in the previous
        exercise

6.  In the **When a resource event occurs** tile, specify the following
    values:

    -   Subscription: Choose your subscription

    -   Resource Type: **Microsoft.Resources.Subscriptions**

    -   Resource Name: Choose your subscription

    -   Event Type Item -
        1: **Microsoft.Resources.ResourceWriteSuccess**

    -   Event Type Item -
        2: **Microsoft.Resources.ResourceDeleteSuccess**

#### Task 2: Add an action to the Azure logic app

1.  On the Logic App Designer blade of the newly provisioned Azure logic
    app, click **+ New step**.

2.  In the **Choose an action** pane, in the **Search connectors and
    actions** text box, type **Outlook**.

3.  In the list of results, click **Outlook.com**.

4.  In the list of actions for **Outlook.com**, click **Send an
    email(V2)**

5.  In the **Outlook.com** pane, click **Sign in**.

6.  When prompted, authenticate by using the Microsoft Account you are
    using in this lab.

7.  When prompted for the consent to grant Azure Logic App permissions
    to access Outlook resources, click **Yes**.

8.  In the **Send an email** pane, specify the following settings and
    click **Save.**

    -   To: *Microsoft Account you are using in this lab*

    -   Subject: Click the field and, in the **Dynamic Content** column
        to the right, choose **Event Type**.

    -   Body: Click the field and, in the **Dynamic Content** column to
        the right, search for and add

            Event Time
            ------------
            Event Type
            ------------
            ID
            ------------
            Subject
            ------------
            Data Object 
            ------------
    -   You can put these values on single lines and put \-\-\-\-- as
    separator between the values*

9.  Click **Save*
10.  Click **Run**


#### Task 3: Test the logic app

1.  In the Azure portal, create any Resource or an empty Resource group.

2.  Navigate to the inbox of the email account you configured in this
    exercise and verify that includes an email generated by the logic
    app.

3.  Another test: Navigate to the **LogApp-12b** blade,
    click **Refresh**, and note that the **Runs history** includes the
    entry corresponding to configuration change of the Azure storage
    account.

> **Result**: After you completed this exercise, you have configured an
Azure logic app to monitor changes to a your subscription. This can also
be applied to other Azure Resources.

### Exercise 3: Remove lab resources

#### Task 1: Open Cloud Shell

1.  At the top of the portal, click the **Cloud Shell** icon to open the
    Cloud Shell pane.

2.  If previous session is PowerShell *[type]{.ul}* **"bash"** to start
    the Bash shell session on PowerShell.

3.  Run the following command to list all resource groups you created in
    this lab:

```sh
az group list --query "[?contains(name,'Lab-12b')]".name --output tsv
```

4.  Verify that the output contains only the resource groups you created
    in this lab. These groups will be deleted in the next task.

#### Task 2: Delete resource groups

1.  Run the following command to delete the resource groups you created
    in this lab

```sh
az group list --query "[? contains(name,'Lab-12b')]".name --output tsv | xargs -L1 bash -c 'az group delete --name $0 --no-wait --yes'
```

2.  Close the **Cloud Shell** prompt at the bottom of the portal.

> **Result**: In this exercise, you removed the resources used in this lab.
