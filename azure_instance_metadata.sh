#!/bin/bash

metadata_json=$(curl -s -H "Metadata: true" "http://169.254.169.254/metadata/instance?api-version=2021-02-01")
vm_size=$(echo "$metadata_json" | jq -r '.compute.vmSize')
 
echo "Virtual Machine Size: $vm_size"

