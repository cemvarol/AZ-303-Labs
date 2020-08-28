a=$(az ad signed-in-user show --query userPrincipalName)
A=$(echo "$a" | sed -e 's/\(.*\)/\L\1/')
B=${A:$(echo `expr index "$A" @`)}
C=${B:: -24}
RG=AZ-303Lab-05
VNet=Lab05-VNet01
Nsg=L05NSG
NsgR=L05Rule1
L=eastus
VM01=L05-VM01
VM02=L05-VM02
OS=Win2019DataCenter
VMSize=standard_B2ms
Pip01=$(echo "$VM01"Pip)
Pip02=$(echo "$VM02"Pip)
APA="10.205.0.0/16"
SNA01="10.205.1.0/24"
SNA02="10.205.2.0/24"
user=QA
pass=1q2w3e4r5t6y*

az group create -n $RG -l $L

az network nsg create -g $RG -n $Nsg
az network nsg rule create -g $RG --nsg-name $Nsg -n $NsgR --priority 100 --destination-port-ranges "*" --direction Inbound


az network vnet create --resource-group $RG --name $VNet  --address-prefixes $APA --subnet-name SNA01 --subnet-prefix $SNA01
az network vnet subnet create -g $RG --vnet-name $VNet -n SNA02 --address-prefixes $SNA02 --network-security-group $Nsg 

export SUBNETID01=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SNA01 --query id -o tsv)
export SUBNETID02=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SNA02 --query id -o tsv)
export SUBNETN01=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SNA01 --query name -o tsv)

az network vnet subnet update -g $RG --vnet-name $VNet -n $SUBNETN01 --network-security-group $Nsg

az vm create --resource-group $RG -n $VM01 -l $L --image $OS --admin-username $user --admin-password $pass --size $VMSize --public-ip-address $Pip01 --public-ip-address-allocation static --subnet $SUBNETID01 --license-type Windows_Server --nsg "" --no-wait
az vm create --resource-group $RG -n $VM02 -l $L --image $OS --admin-username $user --admin-password $pass --size $VMSize --public-ip-address $Pip02 --public-ip-address-allocation static --subnet $SUBNETID02 --license-type Windows_Server --nsg ""

