param location string = resourceGroup().location
param iteration string

param source_vnet_name string = 'source_vnet'
param destination_vnet_name string = 'destination_vnet'

param bastion_name string = 'bastion'
param bastion_vip_name string = 'bastion_vip'

param vm_admin_username string
@secure()
param vm_admin_password string

param source_vm_name string = 'sourceVM${iteration}'
param source_nic_name string = 'sourceVM_nic'

param destination_vm_name string = 'destinationVM${iteration}'
param destination_nic_name string = 'destinationVM_nic'

param privateendpoint_name string = 'PE'
param privateendpoint_nic_name string = 'PE_nic'

param privatelink_name string = 'PL'
param privatelink_nic_name string = 'PL_nic'

param slb_name string = 'slb'


resource destination_vm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: destination_vm_name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${destination_vm_name}_OsDisk_1'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          //id: resourceId('Microsoft.Compute/disks', '${destination_vm_name}_OsDisk_1_d42911ea18c44a65beb488855faa0e57')
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      // diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: destination_vm_name
      adminUsername: vm_admin_username
      adminPassword: vm_admin_password
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: destination_nic.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource source_vm 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: source_vm_name
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${source_vm_name}_OsDisk_1'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          //id: resourceId('Microsoft.Compute/disks', '${source_vm_name}_OsDisk_1_1367f1ccf4264ee789372a21344c941a')
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      // diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: source_vm_name
      adminUsername: vm_admin_username
      adminPassword: vm_admin_password
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: source_nic.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2021-11-01' = {
  parent: source_vm
  name: 'installcustomscript'
  location: location
  tags: {
    displayName: 'install software for Windows VM'
  }
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.9'
    autoUpgradeMinorVersion: true
    protectedSettings: {
      fileUris: [
        
      ]
      commandToExecute: 'powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server ` '
    }
  }
}

resource privateendpoint_nic 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: privateendpoint_nic_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'privateEndpointIpConfig.4cda819c-1c6a-4168-9615-a21b7c7acc8a'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAllocationMethod: 'Static'
          privateIPAddress: '10.1.0.10'
          subnet: {
            id: source_vnet_subnet_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
  }
}

resource source_nic 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: source_nic_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: source_vnet_subnet_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
  }
}

// resource privateendpoint_connection 'Microsoft.Network/privateLinkServices/privateEndpointConnections@2022-09-01' = {
//   parent: privateLink
//   name: 'PE.8c9ab6fd-e2a7-4b65-88a3-a2aa86705c3a'
//   properties: {
//     privateLinkServiceConnectionState: {
//       status: 'Approved'
//       description: 'Auto Approved'
//       actionsRequired: 'None'
//     }
//   }
// }

resource bastion 'Microsoft.Network/bastionHosts@2022-09-01' = {
  name: bastion_name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    dnsName: 'bst-cb7c59cb-848e-4179-9c97-f32c2325ccac.${bastion_name}.azure.com'
    scaleUnits: 2
    enableTunneling: false
    enableIpConnect: false
    disableCopyPaste: false
    enableShareableLink: false
    ipConfigurations: [
      {
        name: 'IpConf'
        // id: '${resourceId('Microsoft.Network/${bastion_name}Hosts', bastion_name)}/${bastion_name}HostIpConfigurations/IpConf'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: bastion_vip.id
          }
          subnet: {
            id: source_vnet_subnet_bastion.id
          }
        }
      }
    ]
  }
}

resource bastion_vip 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: bastion_vip_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource slb 'Microsoft.Network/loadBalancers@2022-09-01' = {
  name: slb_name
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'fip'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: destination_vnet_subnet_default.id
          }
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    backendAddressPools: [
      {
        name: 'bep'
        // properties: {
        //   loadBalancerBackendAddresses: [
        //     {
        //       name: 'VFPReproRG_destinationvm724ipconfig1'
        //       properties: {}
        //     }
        //   ]
        // }
      }
    ]
    loadBalancingRules: [
      {
        name: 'forwardAll'
        properties: {
          frontendIPConfiguration: {
            //id: '${slb.id}/frontendIPConfigurations/fip'
            id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', slb_name, 'fip')
            
          }
          frontendPort: 0
          backendPort: 0
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          protocol: 'All'
          enableTcpReset: false
          loadDistribution: 'Default'
          disableOutboundSnat: true
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', slb_name, 'bep')
          }
          // backendAddressPools: [
          //   {
          //     id: slb_frontendip.id
          //   }
          // ]
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', slb_name, 'probe10001')
          }
        }
      }
    ]
    probes: [
      {
        name: 'probe10001'
        properties: {
          protocol: 'Tcp'
          port: 10001
          intervalInSeconds: 5
          numberOfProbes: 1
          probeThreshold: 1
        }
      }
    ]
    inboundNatRules: []
    outboundRules: []
    inboundNatPools: []
  }
}



resource destination_nic 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: destination_nic_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: destination_vnet_subnet_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          loadBalancerBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', slb_name, 'bep')
            }
          ]
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
  }
  dependsOn: [
    slb
  ]
}

resource privateendpoint 'Microsoft.Network/privateEndpoints@2022-09-01' = {
  name: privateendpoint_name
  location: location
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateendpoint_name
        properties: {
          privateLinkServiceId: privateLink.id
          // groupIds: []
          // privateLinkServiceConnectionState: {
          //   description: 'Auto Approved'
          //   actionsRequired: 'None'
          // }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    customNetworkInterfaceName: '${privateendpoint_name}-nic'
    subnet: {
      id: source_vnet_subnet_default.id
    }
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: '10.1.0.10'
      
        }
      }
    ]
    customDnsConfigs: []
  }
}

resource privateLink 'Microsoft.Network/privateLinkServices@2022-09-01' = {
  name: privatelink_name
  location: location
  properties: {
    fqdns: []
    visibility: {
      subscriptions: []
    }
    autoApproval: {
      subscriptions: []
    }
    enableProxyProtocol: false
    loadBalancerFrontendIpConfigurations: [
      {
        id: '${slb.id}/frontendIPConfigurations/fip'
      }
    ]
    ipConfigurations: [
      {
        name: 'default-1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: destination_vnet_subnet_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
  }
}

resource privatelink_nic 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  name: privatelink_nic_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'default-1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: destination_vnet_subnet_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    privateLinkService: {
      id: privateLink.id
    }
    nicType: 'Standard'
  }
}

resource vnet_peering_src_to_dst 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-09-01' = {
  parent: source_vnet
  name: 'todst'
  properties: {
    remoteVirtualNetwork: {
      id: destination_vnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    
  }
  dependsOn: [
    bastion
  ]
}

resource source_vnet 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: source_vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    enableDdosProtection: false
  }
}

resource source_vnet_subnet_default 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' = {
  parent: source_vnet
  name: 'default'
  properties: {
    addressPrefix: '10.1.0.0/24'
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource source_vnet_subnet_bastion 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' = {
  parent: source_vnet
  name: 'AzureBastionSubnet'
  properties: {
    addressPrefix: '10.1.1.0/24'
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource destination_vnet 'Microsoft.Network/virtualNetworks@2022-09-01' = {
  name: destination_vnet_name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    enableDdosProtection: false
  }
}

resource destination_vnet_subnet_default 'Microsoft.Network/virtualNetworks/subnets@2022-09-01' = {
  parent: destination_vnet
  name: 'default'
  properties: {
    addressPrefix: '10.2.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
  }
}

resource vnet_peering_dst_to_src 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-09-01' = {
  parent: destination_vnet
  name: 'tosrc'
  properties: {
    remoteVirtualNetwork: {
      id: source_vnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
  }
  dependsOn: [
    bastion
  ]
}
