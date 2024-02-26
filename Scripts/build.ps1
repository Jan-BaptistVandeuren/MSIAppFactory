param (
    [Parameter(Mandatory=$true)]
    [string]$JsonFilePath
)

blob_name = ""
file_type = ""
container_name = ""

# Parse the JSON file
$jsonContent = Get-Content -Path $JsonFilePath | ConvertFrom-Json

# Extract the relevant information from the JSON content
$sourceFilesPath = $jsonContent.sourceFilesPath
$msiOutputPath = $jsonContent.msiOutputPath
$msiParameters = $jsonContent.msiParameters
$sourceStorageAccount = $jsonContent.sourceStorageAccount
$destinationStorageAccount = $jsonContent.destinationStorageAccount

# Download files from the source Storage Account
& 'az' 'storage' 'blob' 'download-batch' '--source' $sourceFilesPath '--destination' $msiOutputPath '--account-name' $sourceStorageAccount '--sas-token' $(sasToken)

# Build the MSI
& 'path\to\candle.exe' $sourceFilesPath -ext WixUIExtension
& 'path\to\light.exe' $msiParameters -ext WixUIExtension

# Upload the MSI to the destination Storage Account
& 'az' 'storage' 'blob' 'upload' '--account-name' $destinationStorageAccount '--account-key' $(storageAccountBKey) '--name' blob-name '--type' 'block' '--file-type' file-type '--file' $msiOutputPath '--container-name' container-name
