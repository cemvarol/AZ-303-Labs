---
lab:
    title: '12A: Implementing an Azure App Service Web App with a Staging Slot'
    module: 'Module 12: Implement an Application Infrastructure'
---

# Lab: Implementing an Azure App Service Web App with a Staging Slot
# Student lab manual

## Lab scenario

Adatum Corporation has a number of web apps that are updated on relatively frequent basis. While Adatum has not yet fully embraced DevOps principles, it relies on Git as its version control and is exploring the options to streamline the app updates. As Adatum is transitioning some of its workloads to Azure, the Adatum Enterprise Architecture team decided to evaluate the use of Azure App Service and its deployment slots to accomplish this objective. 

Deployment slots are live apps with their own host names. App content and configurations elements can be swapped between two deployment slots, including the production slot. Deploying apps to a non-production slot has the following benefits:

- It is possible to validate app changes in a staging deployment slot before swapping it with the production slot.

- Deploying an app to a slot first and swapping it into production makes sure that all instances of the slot are warmed up before being swapped into production. This eliminates downtime when during app deployment. The traffic redirection is seamless, and no requests are dropped because of swap operations. This workflow can be automated by configuring auto swap when pre-swap validation is not needed.

- After a swap, the slot with previously staged app has the previous production app. If the changes swapped into the production slot need to be reversed, this simply involves another swap immediately to return to the last known good state.

Deployment slots facilitate two common deployment patterns: blue/green and A/B testing. Blue-green deployment involves deploying an update into a production environment that is separate from the live application. After the deployment is validated, traffic routing is switched to the updated version. A/B testing involves gradually routing some of the traffic to a staging site in order to test a new version of an app.

The Adatum Architecture team wants to use Azure App Service web apps with deployment slots in order to test these two deployment patterns:

-  Blue/Green deployments 

-  A/B testing 


## Objectives
  
After completing this lab, you will be able to:

-  Implement Blue/Green deployment pattern by using deployment slots of Azure App Service web apps

-  Perform A/B testing by using deployment slots of Azure App Service web apps


## Lab Environment
  
Estimated Time: 15 minutes

## Instructions

### Exercise 1: Deploy and Update an Azure App Service WebApp

1. Deploy an Azure App Service web app

1. Update the web page content

#### Task 1: Deploy an Azure App Service WebApp

1. From your lab computer, start a web browser, navigate to the [Azure portal](https://portal.azure.com), and sign in. 

1. In the Azure portal, open **Cloud Shell** select **Bash**. 

  1. From the Cloud Shell pane, run the following to create 
 - a Resource Group Named  **AZ-303Lab-12a**
 - an Application Service Plan Named **EUS-SVC01**
 - a WebApp, with the label **lab12a** appended to your login name. 

   ```sh
   curl -O https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-12a/Lab-12a-SetUp.bash
   ls -la Lab-12a-SetUp.bash
   chmod +x Lab-12a-SetUp.bash
   ./Lab-12a-SetUp.bash
   #
   ```
4. Verify that the deployment user was created successfully. 

    >**Note**: Wait for the deployment to complete. This won't take more than 2 minutes.


#### Task 2: Update The Content

1. In the Azure portal, navigate to **App Services** and  select the newly created WebApp.

1. On the App Service web app blade, under **Development Tools** section, select **Console** and then run the command below on the console to update the content.

>**Note**: If you can not paste the command with right click option, use the key combination **Shift+Insert** to paste into the console

 ```sh
 echo "<html><body><h1> Hello World ! This is the Real Page </h1></body></html>">"hostingstart.html"
```
3. Under **overview** click **Browse**, observe that the page, it should show like below 

> **Hello World ! This is the Real Page**

### Exercise 2: Create and Update the second slot
  
The main tasks for this exercise are as follows:

1. Create the Second slot and Deploy the web content 

1. Swap App Service web app staging slots

1. Configure A/B testing

1. Remove Azure resources deployed in the lab


#### Task 1: Create the Second slot and Deploy the web content

1. In the Azure portal, navigate to **App Services** and  select your WebApp..

1. On the App Service web app blade, under **Deployment** section, select **Deployment Slots** and click **+ Add Slot**


3. Provide a neme for the second slot E.g. **2nd**

2. **Clone Settngs from:** Select your WebApp and Click **Add**
3. Click **Close** when slot is created.
4. Click the newly created slot.

5. Under **Development Tools** section, select **Console** and then run the command below on the console to update the content.
>**Note**: If you can not paste the command with right click option, use the key combination **Shift+Insert** to paste into the console

```sh
echo "<html><body><h1> This is the Second Slot </h1></body></html>">"hostingstart.html"
```
8. Under **overview** click **Browse**, observe that the page, it should show like below 

> **This is the Second Slot**
  
  
#### Task 2: Swap App Service web app staging slots

1. In the Azure portal, navigate back to the App Service and select **Deployment slots**.

1. On the deployment slots blade, click **Swap**.and then click **Close** after swapping completed. 

1. Refresh the previously opened pages, confirm that the content shows vise-versa.
2. Real Page should show  **This is the Second Slot**
3. 2nd Slot should show  **Hello World ! This is the Real Page**

#### Task 3: Configure A/B testing

1. In the Azure portal, navigate back to the blade displaying the deployment slots of the App Service web app.

1. Under **Deployment Slots**.  Set the value in the **TRAFFIC %** column to 50. This will automatically set the value of **TRAFFIC %** in the row representing the production slot to 50 and  select **Save**.
>**Note**: You may need to set this option under the master app under **App Services**. 

2. To test the result, please visit the main URL via different browsers on your computer.  


#### Task 4: Remove Azure resources deployed in the lab

1. From the Cloud Shell pane, run the following to list the resource group you created in this exercise:

   ```sh
   az group list --query "[?contains(name,'Lab-12a')]".name --output tsv
   ```

    > **Note**: Verify that the output contains only the resource group you created in this lab. This group will be deleted in this task.

1. From the Cloud Shell pane, run the following to delete the resource group you created in this lab

   ```sh
   az group list --query "[?contains(name,'Lab-12a')]".name --output tsv | xargs -L1 bash -c 'az group delete --name $0 --no-wait --yes'
   ```
