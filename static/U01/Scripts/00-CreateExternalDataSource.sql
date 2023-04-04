 CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'ChangeYourAdminPassword1OrStickWithm7eUAFZnD8aF';

 CREATE DATABASE SCOPED CREDENTIAL AzureBlobStorageCredential
 WITH IDENTITY = 'SHARED ACCESS SIGNATURE',
 SECRET = 'sv=2021-12-02&ss=bfqt&srt=sco&sp=rwdlacupiytfx&se=2023-03-28T20:04:19Z&st=2023-03-28T12:04:19Z&spr=https&sig=RSX715rHzTB%2FUiz%2BD4Xe8Sa3%2FmcvYfGUy2QXbRy1uVo%3D';
  
 CREATE EXTERNAL DATA SOURCE azureblobstorageDS
 WITH ( TYPE = BLOB_STORAGE, 
 LOCATION = 'https://videorentalstorageacc.blob.core.windows.net',
 CREDENTIAL= AzureBlobStorageCredential);