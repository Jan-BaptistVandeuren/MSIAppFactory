# MSIAppFactory
Takes files from a pipeline/storage account, builds it into an msi and shoots everything to a storage account so that i can be linked further with IntuneAppFactory
The whole idea is that the dev give you the program not the installer and the infra team must install it so the creation if the simple MSI is a shared responsibility and therefore takes a simple input from dev and gives a simple output in infra.

Mainly a rebuild of the existing project IntuneAppFactory by MSEndpointMgr