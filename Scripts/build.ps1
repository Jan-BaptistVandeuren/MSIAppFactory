param (
    [Parameter(Mandatory=$true)]
    [string]$AppFolderPath
)

# Parse the JSON file
$jsonFilePath = Join-Path -Path $AppFolderPath -ChildPath "app.json"
$jsonContent = Get-Content -Path $jsonFilePath | ConvertFrom-Json

# Extract the relevant information from the JSON content
$sourceFilesPath = $jsonContent.sourceFilesPath
$msiOutputPath = $jsonContent.msiOutputPath
$msiParameters = $jsonContent.msiParameters
$sourceStorageAccount = $jsonContent.sourceStorageAccount
$destinationStorageAccount = $jsonContent.destinationStorageAccount
$blobName = $jsonContent.blobName
$fileType = $jsonContent.fileType
$containerName = $jsonContent.containerName
$sasToken = $jsonContent.sasToken
$storageAccountBKey = $jsonContent.storageAccountBKey

# Download files from the source Storage Account
& 'az' 'storage' 'blob' 'download-batch' '--source' $sourceFilesPath '--destination' $msiOutputPath '--account-name' $sourceStorageAccount '--sas-token' $sasToken

# Build the MSI
$wxsFilePath = Join-Path -Path $AppFolderPath -ChildPath "app.wxs"
& 'candle.exe' $wxsFilePath -ext WixUIExtension
& 'light.exe' $msiParameters -ext WixUIExtension

# Upload the MSI to the destination Storage Account
& 'az' 'storage' 'blob' 'upload' '--account-name' $destinationStorageAccount '--account-key' $storageAccountBKey '--name' $blobName '--type' 'block' '--file-type' $fileType '--file' $msiOutputPath '--container-name' $containerName
