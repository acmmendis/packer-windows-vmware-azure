# Packer Windows Image Deployments

## Windows

Tools and  capabilities requirments:

* Hashicorp Packer (for building the image)
* Hashicorp Vault (to manage secrets)
* pwsh + VMware.PowerCLI module installed (to manage the templates in Vsphere)
* jq package

### Get started

Nothing fancy, we use the standard process.

* Do your changes in the code 
* Create a pull request
* Everything can be changed in parameter json files (var-*-win201#-??.json) without touching the main configurations


### Platforms

#### Vsphere

We generate Windows images as follow:

* Distribution: Windows Server DC Std 2016/Windows Server DC Std 2019
* Standard account: packer-admin
* Password: changes at every build, see Vault: automation/packer/windows-esx
* Location: Templates
* Imageges: Windows-Srv-2016-Stable/Windows-Srv-2019-Stable
  
