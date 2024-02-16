$resourceGroupName = "rgBI"
$storageAccountName = "bixx" # edit XX
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName "$resourceGroupName" -Name "$storageAccountName")[0].Value
$containerName = "bixx" # edit XX
$uri = "https://$storageAccountName.blob.core.windows.net/$containerName"

$serverName="bixx" # edit xx
$databaseName="WillibaldXX" # edit XX
$username="bixx" # edit xx
$password="ryDZo5*~71[Q-" # edit password
$passwordSecureString = ConvertTo-SecureString -String $password -AsPlainText -Force

$context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
$blobs = Get-AzStorageBlob -Container $containerName -Context $context

foreach ($blob in $blobs) {
    $blobName = $blob.Name
    New-AzSqlDatabaseImport -ResourceGroupName "$resourceGroupName" -ServerName "$serverName" -DatabaseName "$databaseName" -StorageKeyType "StorageAccessKey" -StorageKey "$storageAccountKey" -StorageUri "$uri/$blobName" -AdministratorLogin "$username" -AdministratorLoginPassword $passwordSecureString -Edition Standard -ServiceObjectiveName S0 -DatabaseMaxSizeBytes 1GB
}
