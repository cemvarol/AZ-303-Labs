# Get Login Name
a=$(az ad signed-in-user show --query userPrincipalName)
# Get change Login Name to lower-case
A=$(echo "$a" | sed -e 's/\(.*\)/\L\1/')
B=${A:$(echo `expr index "$A" @`)}
# Create Variables
C=${B:: -24}
D=$(echo "$C"db01)
E=$(echo "$C"wa01)
RG=AZ-303Lab-07
L=EastUS
user=sysadmin
pass=1q2w3e4r5t6y*
startip=0.0.0.0
endip=255.255.255.255
VNet=Lab07-VNet
Nsg=L7NSG
NsgR=L7Rule1
VM=Lab07-VM01
OS=Win2019DataCenter
Pip=$(echo "$VM"Pip)
AP="10.205.0.0/16"
SN01="10.205.1.0/24"
VMSize=standard_B2ms

# Create Resource Group
az group create --name $RG --location $L

# Create DB Server
az sql server create -l $L -g $RG -n $D -u $user -p $pass

# Create DB 
az sql db create -g $RG -s $D -n partsunlimited --service-objective S0

az sql server firewall-rule create \
    --resource-group $RG \
    --server $D \
    --name AllowYourIp \
    --start-ip-address $startip \
    --end-ip-address $endip

# Create Service Plan for webapp
az appservice plan create -n PU-SVC01 --sku S1 -g $RG -l $L

# Create WebApp
az webapp create -g $RG -p PU-SVC01 -n $E

# Create Storage Account
az storage account create -n $D -g $RG --kind Storage -l $L --sku Standard_LRS

# Create Network Security Group
az network nsg create -g $RG -n $Nsg
az network nsg rule create -g $RG --nsg-name $Nsg -n $NsgR --priority 100 --destination-port-ranges "*" --direction Inbound

# Create VNet&Subnet
az network vnet create --resource-group $RG --name $VNet  --address-prefixes $AP --subnet-name SN01 --subnet-prefix $SN01

# Export VNet Values
export SUBNETID=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SN01 --query id -o tsv)
export SUBNETN=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SN01 --query name -o tsv)

# Assign NSG to Subnet
az network vnet subnet update -g $RG --vnet-name $VNet -n $SUBNETN --network-security-group $Nsg

# Create VM
az vm create --resource-group $RG -n $VM -l $L --image $OS --admin-username $user --admin-password $pass --size $VMSize --public-ip-address $Pip --public-ip-address-allocation static --subnet $SUBNETID --boot-diagnostics-storage $D --license-type Windows_Server --nsg ""

