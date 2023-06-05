SELECT movement.*
  INTO dbo.movements
  FROM OPENROWSET (
        BULK 'csvcontainer/google_takeout.json',
        DATA_SOURCE = 'azureblobstorageDS',
        SINGLE_CLOB
    ) AS j
 CROSS APPLY OPENJSON(BulkColumn, '$.locations')
  WITH (
        timestampMs BIGINT,
        latitudeE7 BIGINT,
        longitudeE7 BIGINT,
        accuracy int
    ) AS movement;

ALTER TABLE dbo.movements
	ALTER COLUMN timestampMs BIGINT NOT NULL;

ALTER TABLE dbo.movements
	ADD recording_time DATETIME2 NULL,
		latitude DECIMAL(10,7) NULL,
		longitude DECIMAL(10,7) NULL,
		location_point GEOGRAPHY NULL,
		CONSTRAINT PK_movements PRIMARY KEY CLUSTERED (timestampMs);

UPDATE dbo.movements
	SET recording_time = DATEADD(SECOND, timestampMs / 1000, '1970-1-1'),
		latitude = CAST(CAST(latitudeE7 AS DECIMAL(10,0)) / POWER(10,7) AS decimal(10,7)),
		longitude = CAST(CAST(longitudeE7 AS DECIMAL(10,0)) / POWER(10,7) AS decimal(10,7));

UPDATE dbo.movements
	SET location_point = geography::Point(latitude, longitude , 4326);