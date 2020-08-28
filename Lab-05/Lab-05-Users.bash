  
A=$(az ad signed-in-user show --query userPrincipalName)
B=${A:$(echo `expr index "$A" @`)}
C=${B:: -1}
az ad user create --display-name "StorageAccount Tester" --user-principal-name satester@$C --password 1q2w3e4r5t6y*
