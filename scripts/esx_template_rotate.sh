#!/bin/sh
# simple script to rotate ESX templates
export GOVC_INSECURE=true

if [ "$#" != "2" ]; then
  echo "Datacenter and template not provided"
  exit 1
fi

GOVC_DATACENTER="${1}"
ESX_TEMPLATE="${2}"

# extra safety
new_template=$(govc vm.info "/${GOVC_DATACENTER}/vm/Templates/${ESX_TEMPLATE}")
if [ "${new_template}" = "" ]; then
  echo "New template does not exist, we should not be here so hard stop now"
  exit 1
fi

# remove old template if exist
old_template=$(govc vm.info "/${GOVC_DATACENTER}/vm/Templates/${ESX_TEMPLATE}-Stable")
if [ "${old_template}" = "" ]; then
  echo "${ESX_TEMPLATE}-Stable does not exist, not deleting"
else
  govc vm.destroy "/${GOVC_DATACENTER}/vm/Templates/${ESX_TEMPLATE}-Stable"
fi

# new stable template
govc vm.change -vm "/${GOVC_DATACENTER}/vm/Templates/${ESX_TEMPLATE}" -name ${ESX_TEMPLATE}-Stable