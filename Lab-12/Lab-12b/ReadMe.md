## Simplified Content for AZ-303 Lab-12b


az group list --query "[? contains(name,'Lab-12b')]".name --output tsv | xargs -L1 bash -c 'az group delete --name $0 --no-wait --yes'
