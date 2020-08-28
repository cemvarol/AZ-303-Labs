[AZ-303 HomePage](https://github.com/cemvarol/AZ-303-Labs)

az group list --query "[? contains(name,'Lab-12b')]".name --output tsv | xargs -L1 bash -c 'az group delete --name $0 --no-wait --yes'
