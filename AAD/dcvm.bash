a=$(az ad signed-in-user show --query userPrincipalName)
A=$(echo "$a" | sed -e 's/\(.*\)/\L\1/')
B=${A:$(echo `expr index "$A" @`)}
C=${B:: -24}
D=$(echo "$C"dc01)
E=$(echo "$C"dc02)
RG=AADLab
VNet=DC-VNet
Nsg=DCNSG
NsgR=DCRule1
L=Eastus2
VM=US-DC01
VMSize=standard_D4s_v3
Pip=$(echo "$VM"Pip)
AP="10.207.0.0/16"
SN01="10.207.1.0/24"
user=Acuutech
pass=1q2w3e4r5t6y*

az group create -n $RG -l $L

az storage account create -n $D -g $RG --kind Storage -l $L --sku Standard_LRS


az network nsg create -g $RG -n $Nsg
az network nsg rule create -g $RG --nsg-name $Nsg -n $NsgR --priority 100 --destination-port-ranges "*" --direction Inbound


az network vnet create --resource-group $RG --name $VNet  --address-prefixes $AP --subnet-name SN01 --subnet-prefix $SN01

export SUBNETID=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SN01 --query id -o tsv)
export SUBNETN=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SN01 --query name -o tsv)

az network vnet subnet update -g $RG --vnet-name $VNet -n $SUBNETN --network-security-group $Nsg

az vm create --resource-group $RG -n $VM -l $L --image Win2019DataCenter --admin-username $user --admin-password $pass --size $VMSize --public-ip-address $Pip --subnet $SUBNETID --boot-diagnostics-storage $D --license-type Windows_Server --nsg "" --public-ip-address-allocation static





#
