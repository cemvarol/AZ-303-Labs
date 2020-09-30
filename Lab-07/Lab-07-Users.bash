# Get Login Name
a=$(az ad signed-in-user show --query userPrincipalName)
# Set change Login Name to lower-case
A=$(echo "$a" | sed -e 's/\(.*\)/\L\1/')
# Remove the part after @ sign
B=${A:$(echo `expr index "$A" @`)}
# Remove quotaion marks
C=${B:: -1}

az ad user create --display-name "StorageAccount Contributor" --user-principal-name sacc.cont@$C --password 1q2w3e4r5t6y*
az ad user create --display-name "Network Contributor" --user-principal-name nw.cont@$C --password 1q2w3e4r5t6y*
az ad user create --display-name "VM Contributor" --user-principal-name vm.cont@$C --password 1q2w3e4r5t6y*
az ad user create --display-name "Reader" --user-principal-name reader@$C --password 1q2w3e4r5t6y*
az ad user create --display-name "Contributor" --user-principal-name contr@$C --password 1q2w3e4r5t6y*
az ad user create --display-name "Owner" --user-principal-name owner@$C --password 1q2w3e4r5t6y*

