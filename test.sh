#!/bin/bash

subscription_id={enter subscription id here}
storageaccount_name={enter azure files storage account name here}
resourcegroup_name={enter resource group name here}

capacityQuota=$(az monitor metrics list --resource /subscriptions/${subscription_id}/resourceGroups/${resourcegroup_name}/providers/Microsoft.Storage/storageAccounts/${storageaccount_name}/fileServices/default --metric "FileShareCapacityQuota" --interval 1h --query value[0].timeseries[0].data[0].average)

currentSize=$(az monitor metrics list --resource /subscriptions/${subscription_id}/resourceGroups/${resourcegroup_name}/providers/Microsoft.Storage/storageAccounts/${storageaccount_name}/fileServices/default --metric "FileCapacity" --interval 1h --query value[0].timeseries[0].data[0].average)

let "usage = ${currentSize%.*} * 100 / ${capacityQuota%.*}"

echo "capacity quota is $capacityQuota"
echo "current size is $currentSize"
echo "current usage is $usage percent"

if [ $usage -ge 80 ]; then
  echo "send alert"
fi

