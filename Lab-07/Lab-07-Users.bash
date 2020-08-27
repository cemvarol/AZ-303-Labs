A=$(az ad signed-in-user show --query userPrincipalName)
B=${A:$(echo `expr index "$A" @`)}
C=${B:: -1}
az ad user create --display-name "StorageAccount Contributor" --user-principal-name sacc.cont@$C --password 1q2w3e4r5t6y*
az ad user create --display-name "Network Contributor" --user-principal-name nw.cont@$C --password 1q2w3e4r5t6y*
az ad user create --display-name "VM Contributor" --user-principal-name vm.cont@$C --password 1q2w3e4r5t6y*
az ad user create --display-name "Reader" --user-principal-name reader@$C --password 1q2w3e4r5t6y*
az ad user create --display-name "Contributor" --user-principal-name contr@$C --password 1q2w3e4r5t6y*
az ad user create --display-name "Owner" --user-principal-name owner@$C --password 1q2w3e4r5t6y*

