---
lab:
    title: '7: Managing Azure Role-Based Access Control'
    module: 'Module 7: Implement and Manage Azure Governance'
---

# Lab: Managing Azure Role-Based Access Control
# Student lab manual

## Lab scenario

With Azure Active Directory (Azure AD) becoming integral part of its
identity management environment, the Adatum Enterprise Architecture team
must also determine the optimal authorization approach. In the context
of controlling access to Azure resources, such approach must involve the
use of Azure Role-Based Access Control (RBAC). Azure RBAC is an
authorization system built on Azure Resource Manager that provides
fine-grained access management of Azure resources.

The key concept of Azure RBAC is role assignment. A role assignment
consists of three elements: security principal, role definition, and
scope. A security principal is an object that represents a user, group,
service principal, or managed identity that is requesting access to
Azure resources. A role definition is a collection of the operations
that the role assignments will grant, such as read, write, or delete.
Roles can be generic or resource specific. Azure includes four built-in
generic roles (Owner, Contributor, Reader, and User Access
Administrator) and a fairly large number of built-in resource-specific
roles (such as, for example, Virtual Machine Contributor, which includes
permissions to create and manage Azure virtual machines). It is also
possible to define custom roles. A scope is the set of resources that
the access applies to. A scope can be set at multiple levels: management
group, subscription, resource group, or resource. Scopes are structured
in a parent-child relationship.

The Adatum Enterprise Architecture team wants to test delegation of
Azure management by using custom Role-Based Access Control roles. To
start its evaluation, the team intends to create a custom role that
provides restricted access to Azure virtual machines.

## Objectives

After completing this lab, you will be able to:

-   Assign a custom RBAC role

## Lab Environment

Estimated Time: 45 minutes

## Instructions

### Exercise 0: Prepare the lab environment

The main tasks for this exercise are as follows:

1.  Deploy Azure Resources

2.  Create Azure Active Directory users

#### Task 1: Create Azure Active Directory users

1.  Open a new tab on your browser and visit <https://shell.azure.com>
    choose **Bash**.

2.  Run the command down below to create users on Azure Active
    Directory.

   ```sh
curl -O https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-07/Lab-07-Users.bash
ls -la Lab-07-Users.bash
chmod +x Lab-07-Users.bash
./Lab-07-Users.bash
   ```
#### Task 2: Deploy Azure Resources**

1.  In the Azure portal, open **Cloud Shell** pane by selecting on the
    toolbar icon directly to the right of the search textbox, OR visit
    <https://shell.azure.com> for full screen experience on a different
    session.

2.  If prompted to select either Bash or PowerShell, select **Bash**.

3.  Run the following command to create resources on azure

```sh
curl -O https://raw.githubusercontent.com/cemvarol/AZ-303-Labs/master/Lab-07/Lab-07-Resources.bash
ls -la Lab-12a-SetUp.bash
chmod +x Lab-07-Resources.bash
./Lab-07-Resources.bash
#


```

> **Note**: After finishing this exercise, you will have these resources
> and users created. Check the list down BELOW. Resources.
>
> You do not need to wait for the deployment to complete. Proceed to the
> next task. The deployment should take approximately 5-7 minutes.

### Exercise 1: Assign and test RBAC roles

The main tasks for this exercise are as follows:

1.  Create an RBAC role assignment

2.  Test the RBAC role assignment

#### Task 1: Create an RBAC role assignment

1.  In the Azure portal, navigate to the **AZ-303Lab-07** Resource
    Group.

2.  On the **AZ-303Lab-07** blade, select **Access Control (IAM)**.

3.  On the **Access Control (IAM)** blade, select **+ Add** and select
    the **Add role assignment** option.

4.  On the **Add role assignment** blade, specify the following 6
    settings (leave others with their existing values) and
    select **Save**:

5.  Check for the table BELOW for Roles

#### Task 2: Test the RBAC role assignment

1.  Start a new incognito web browser session, navigate to the [[Azure
    portal]{.ul}](https://portal.azure.com/), and sign in by using
    the user accounts with the **1q2w3e4r5t6y** password.

2.  Observe that. BELOW Tasks

> **Note**: This part is a self-drive exercise, please complete the
> tasks above.

3.  If you had assigned those Roles onto subscription instead of a
    single Resource Group. The actions would be Subscription wide.

#### Task 3: Remove Azure resources deployed in the lab

1.  From the Cloud Shell pane, run the following to list the resource
    group you created in this exercise:

> az group list \--query \"\[?contains(name,\'Lab-07\')\]\".name
> \--output tsv
>
> **Note**: Verify that the output contains only the resource group you
> created in this lab. This group will be deleted in this task.

2.  From the Cloud Shell pane, run the following to delete the resource
    group you created in this lab

> az group list \--query \"\[?contains(name,\'Lab-07\')\]\".name
> \--output tsv \| xargs -L1 bash -c \'az group delete \--name \$0
> \--no-wait \--yes\'
