@minLength(3)
@maxLength(11)
param saname string

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'
param location string
param containername string

resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: saname
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    isHnsEnabled: true
  }
  resource service 'blobServices' = {
    name: 'default'
    resource container 'containers' = {
      name: containername
      properties: {
        publicAccess: 'None'
        metadata: {}
      }
    }
  }
}

output storageEndpoint object = stg.properties.primaryEndpoints