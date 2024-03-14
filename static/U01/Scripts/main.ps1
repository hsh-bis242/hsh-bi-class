param(
    [Int32]$groupnumber=0,
    [String]$sqlpassword="ryDZo5*~71[Q-"
)

$groupname = "bi{0:d2}" -f $groupnumber

$resourceGroupName = "rgBI"
$storageAccountName = $groupname
$storageAccountKey = (Get-AzStorageAccountKey -ResourceGroupName "$resourceGroupName" -Name "$storageAccountName")[0].Value
$containerName = $groupname
$uri = "https://$storageAccountName.blob.core.windows.net/$containerName"

$serverName=$groupname
$databaseName="Willibald{0:d2}" -f $groupnumber
$username=$groupname
$password=$sqlpassword
$passwordSecureString = ConvertTo-SecureString -String $password -AsPlainText -Force

$context = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
$blobs = Get-AzStorageBlob -Container $containerName -Context $context

foreach ($blob in $blobs) {
    $blobName = $blob.Name
    New-AzSqlDatabaseImport -ResourceGroupName "$resourceGroupName" -ServerName "$serverName" -DatabaseName "$databaseName" -StorageKeyType "StorageAccessKey" -StorageKey "$storageAccountKey" -StorageUri "$uri/$blobName" -AdministratorLogin "$username" -AdministratorLoginPassword $passwordSecureString -Edition Standard -ServiceObjectiveName S0 -DatabaseMaxSizeBytes 1GB
}
