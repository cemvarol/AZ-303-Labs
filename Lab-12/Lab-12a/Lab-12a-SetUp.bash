#Get Azure Account Name 
a=$(az ad signed-in-user show --query userPrincipalName)

# Change to lowercase
A=$(echo "$a" | sed -e 's/\(.*\)/\L\1/')

# Remove the part after the @ sign
B=${A:$(echo `expr index "$A" @`)}

#Remove the unnecessary paret with @outlook.online.microsoft.com
C=${B:: -24}

# Append Lab Name
D=$(echo "$C"lab12a)

#Create a resource group
az group create --location EastUs --name AZ-303Lab-12a

#Create Application Service Plan for the WebApp
az appservice plan create -n EUS-SVC01 --sku S1 -g  AZ-303Lab-12a -l EastUs

#Create the Web App on your App Service Plan
az webapp create -g  AZ-303Lab-12a -p EUS-SVC01 -n $D
