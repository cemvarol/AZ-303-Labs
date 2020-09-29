az provider register --namespace 'Microsoft.Insights'
a=$(az ad signed-in-user show --query userPrincipalName)
A=$(echo "$a" | sed -e 's/\(.*\)/\L\1/')
B=${A:$(echo `expr index "$A" @`)}
C=${B:: -24}
RG=AZ-303Lab-04b
VNet=Lab04b-VNet01
Nsg=L04bNSG
NsgR=L04bRule1
L=westus
LB=Lab04b-LB
LBFEip=Lab04b-FEip
BEndPool=Lab04b-BEpool
VM01=L04b-VM01
VM02=L04b-VM02
Nic01=$(echo "$VM01"VMNic)
Nic02=$(echo "$VM02"VMNic)
OS=Win2019DataCenter
VMSize=standard_B2ms
APA="10.205.0.0/16"
SNA01="10.205.1.0/24"
user=QA
pass=1q2w3e4r5t6y*

az group create -n $RG -l $L

az network nsg create -g $RG -n $Nsg
az network nsg rule create -g $RG --nsg-name $Nsg -n $NsgR --priority 100 --destination-port-ranges "*" --direction Inbound

az network vnet create --resource-group $RG --name $VNet  --address-prefixes $APA --subnet-name SNA01 --subnet-prefix $SNA01

export SUBNETID01=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SNA01 --query id -o tsv)
export SUBNETN01=$(az network vnet subnet show --resource-group $RG --vnet-name $VNet --name SNA01 --query name -o tsv)

az network vnet subnet update -g $RG --vnet-name $VNet -n $SUBNETN01 --network-security-group $Nsg

#Load Balancer Create
az network lb create -g $RG -n $LB -l $L --sku Basic --public-ip-address Lab04b-NLBpip --frontend-ip-name $LBFEip --backend-pool-name $BEndPool

#Load Balancer Health Probe Create
az network lb probe create -g $RG --lb-name $LB --name Web --protocol tcp --port 80

#Load Balancer Rule Create
az network lb rule create -g $RG --lb-name $LB --name http --protocol tcp --frontend-port 80 --backend-port 80 --frontend-ip-name $LBFEip --backend-pool-name $BEndPool --probe-name Web --disable-outbound-snat true

#Create NICs
az network nic create --resource-group $RG --name $Nic01 --vnet-name $VNet --subnet $SUBNETN01 --lb-name $LB --lb-address-pools $BEndPool --no-wait
az network nic create --resource-group $RG --name $Nic02 --vnet-name $VNet --subnet $SUBNETN01 --lb-name $LB --lb-address-pools $BEndPool

#VM Create
az vm create --resource-group $RG -n $VM01 -l $L --image $OS --admin-username $user --admin-password $pass --size $VMSize --nics $Nic01 --license-type Windows_Server --nsg "" --zone 1 --no-wait
az vm create --resource-group $RG -n $VM02 -l $L --image $OS --admin-username $user --admin-password $pass --size $VMSize --nics $Nic02 --license-type Windows_Server --nsg "" --zone 2

z1=$(az network public-ip show -g $RG -n Lab04b-NLBpip --query ipAddress)
z2=${z1:$(echo `expr index "$z1" '"'`)}
NLBip=${z2:: -1}
