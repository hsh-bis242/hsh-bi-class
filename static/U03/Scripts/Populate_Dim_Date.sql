/*
This script is freely shared by the author, Joseph M. Morgan, Principal Programmer/Analyst I at Amerigroup, a division of Wellpoint. Permission is granted to copy, share, modify and distribute it without restriction except for commercial gain, in which case send me some of the money!
*/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


SET NOCOUNT ON;

IF NOT EXISTS ( SELECT
    *
FROM
    sys.objects
WHERE
                        object_id = OBJECT_ID(N'[vrs_dm].[dim_date]')
    AND type IN (N'U') ) 
   BEGIN


    CREATE TABLE [vrs_dm].[dim_date]
    (
        [date_id] [bigint] IDENTITY(1, 1)
            NOT NULL
        ,[sql_date] [datetime] NOT NULL
        ,[date_iso_id] [int] NOT NULL
        ,[day] [smallint] NOT NULL
        ,[day_of_week] [smallint] NULL
        ,[week] [smallint] NOT NULL
        ,[month] [SMALLINT] NOT NULL
        ,[quarter] [SMALLINT] NOT NULL
        ,[year] [SMALLINT] NOT NULL
        ,[day_of_year] [SMALLINT] NOT NULL
        ,[day_text] [VARCHAR](50) NOT NULL
        ,[month_text] [VARCHAR](50) NOT NULL
        ,[quarter_text] [VARCHAR](50) NOT NULL
        ,[day_text_abbrev] [VARCHAR](3) NULL
        ,[month_text_abbrev] [VARCHAR](3) NULL
        ,[ldm] [BIGINT] NULL
        ,[ldq][BIGINT] NULL
        ,[ldy] [BIGINT] NULL
        ,[is_bus_day] [BIT] NULL
        ,[is_weekday] [BIT] NULL
        ,[is_holiday] [BIT] NULL
        ,[rpt_hdr_long] AS CONVERT(VARCHAR(25), (([month_text] + ' ')
                                                    + CONVERT([VARCHAR](4), [year], (0))))
            PERSISTED
        ,[rpt_hdr_short] AS CONVERT(VARCHAR(25), (([month_text_abbrev]
                                                    + ' ')
                                                    + CONVERT([VARCHAR](4), [year], (0))))
            PERSISTED
        ,CONSTRAINT [PK_Date_dbo] PRIMARY KEY CLUSTERED
            ([date_id] ASC)
    )
    CREATE NONCLUSTERED INDEX [IX_Dates] ON [vrs_dm].[dim_date]
         (
         [sql_date] ASC
         )
    CREATE NONCLUSTERED INDEX [IX_Dates_1] ON [vrs_dm].[dim_date]
         (
         [Year] ASC
         )
    CREATE NONCLUSTERED INDEX [IX_Dates_2] ON [vrs_dm].[dim_date]
         (
         [Month] ASC
         )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85)


    /****** Object:  Index [IX_Dates_3]    Script Date: 11/30/2012 10:20:53 AM ******/
    CREATE NONCLUSTERED INDEX [IX_Dates_3] ON [vrs_dm].[dim_date]
         (
         [Day] ASC
         )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85)


    /****** Object:  Index [IX_Dates_4]    Script Date: 11/30/2012 10:20:53 AM ******/
    CREATE NONCLUSTERED INDEX [IX_Dates_4] ON [vrs_dm].[dim_date]
         (
         [ldm] ASC
         )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85)

    CREATE UNIQUE INDEX [IX_Dates_5] ON [vrs_dm].[dim_date]
         (
         [date_iso_id] ASC
         )
END
ELSE 
   BEGIN
    -- If it already existed, it might have data in it, so we truncate just in case.   
    TRUNCATE TABLE [vrs_dm].dim_date
END
  GO
/* ====================== Create the three functions used in the code. ======================
(We avoided errors by creating the table the functions reference first.)*/

IF OBJECT_ID(N'[vrs_dm].svfn_AMS_LDM') IS NOT NULL 
   DROP FUNCTION [vrs_dm].svfn_AMS_LDM
GO

CREATE FUNCTION [vrs_dm].[svfn_AMS_LDM]
       (
        @MONTH SMALLINT
       ,@YEAR SMALLINT
       )
RETURNS BIGINT
AS 
    BEGIN
    DECLARE @RESULT BIGINT
    SET @RESULT = (SELECT
        MAX(date_id)
    FROM
        [vrs_dm].dim_date
    WHERE
                            [month] = @MONTH
        AND [year] = @YEAR
                      )

    RETURN @RESULT
END


GO

IF OBJECT_ID(N'[vrs_dm].svfn_AMS_LDQ') IS NOT NULL 
   DROP FUNCTION [vrs_dm].svfn_AMS_LDQ
GO

CREATE FUNCTION [vrs_dm].[svfn_AMS_LDQ]
       (
        @QUARTER SMALLINT
       ,@YEAR SMALLINT
       )
RETURNS BIGINT
AS 
    BEGIN
    DECLARE @RESULT BIGINT
    SET @RESULT = (SELECT
        MAX(date_id)
    FROM
        dim_date
    WHERE
                            [quarter] = @QUARTER
        AND [year] = @YEAR
                      )

    RETURN @RESULT
END
GO

IF OBJECT_ID(N'[vrs_dm].svfn_AMS_LDY') IS NOT NULL 
   DROP FUNCTION [vrs_dm].svfn_AMS_LDY
GO

CREATE FUNCTION [vrs_dm].[svfn_AMS_LDY] (@YEAR SMALLINT)
RETURNS BIGINT
AS 
    BEGIN
    DECLARE @RESULT BIGINT
    SET @RESULT = (SELECT
        MAX(date_id)
    FROM
        dim_date
    WHERE
                            [year] = @YEAR
                      )

    RETURN @RESULT
END

GO

/*====================== Now populate the table =============================== */
BEGIN TRY
-- Declare and set the date, which is the starting date that will be incremented, and the end date desired
     
      DECLARE @Date DATETIME
      DECLARE @EndDate DATETIME
      SET @Date = CONVERT(DATETIME, '01-01-2000')
      SET @EndDate = CONVERT(DATETIME, '12-31-2025')
      WHILE @Date <= @EndDate 
            BEGIN
    INSERT INTO [vrs_dm].[dim_date]
        ([sql_date]
        ,[date_iso_id]
        ,[day]
        ,[day_of_week]
        ,[week]
        ,[month]
        ,[quarter]
        ,[year]
        ,[day_of_year]
        ,[day_text]
        ,[month_text]
        ,[quarter_text]
        ,[day_text_abbrev]
        ,[month_text_abbrev]
        ,[is_bus_day]
        ,[is_weekday]
        ,[is_holiday]

        )
    SELECT
        @DATE AS SQLDATE
                               , CAST(CONVERT(CHAR(8), @DATE, 112) AS INT) AS [date_iso_id]
                               , DATEPART(D, @DATE) AS [day]
                               , DATEPART(DW, @DATE) AS [day_of_week]
                               , DATEPART(WK, @DATE) AS [week]
                               , DATEPART(M, @DATE) AS [month]
                               , DATEPART(Q, @DATE) AS [quarter]
                               , DATEPART(YYYY, @DATE) AS [year]
                               , DATEPART(DY, @DATE) AS [day_of_year]
                               , DATENAME(DW, @DATE) AS day_text
                               , DATENAME(M, @DATE) AS month_text
                               , 'Q' + CONVERT(CHAR(1), DATENAME(QQ, @DATE)) AS QUARTERTEXT
                               , SUBSTRING(DATENAME(DW, @DATE), 1, 3) AS day_textABBREVIATION
                               , SUBSTRING(DATENAME(M, @DATE), 1, 3) AS month_textABBREVIATION
                               , IS_BUS_DAY = CASE DATEPART(DW, @DATE)
                                               WHEN 7 THEN 0
                                               WHEN 1 THEN 0
                                               ELSE 1
                                             END
                               , ISWEEKDAY = CASE DATEPART(DW, @DATE)
                                              WHEN 7 THEN 0
                                              WHEN 1 THEN 0
                                              ELSE 1
                                            END
                               , 0 AS IS_HOLIDAY
    SET @DATE = DATEADD(D, 1, @DATE)
END
/* ======================  Add holidays to the table ========================

 First set the default U.S. Federal Holidays to be holidays, not business days. 
 In some cases the dates are fixed, in some they are changeable. If your company treats
 any of these as business days, just comment out the relevant section(s) */
      UPDATE
            [vrs_dm].[dim_date]
        SET 
            IS_BUS_DAY = 0
           ,IS_HOLIDAY = 1
        WHERE
            (
--New [Year]'s Day (Jan 1)
             [Month] = 1
    AND DAY = 1
    OR
    --Christmas Day (Dec 25)
    [Month] = 12
    AND DAY = 25
    OR
    --Independence Day (Jul 4)
    [Month] = 7
    AND DAY = 4
    OR
    --Veteran's Day (Nov 11)
    [Month] = 11
    AND Day = 11
    OR
    --Thanksgiving (4th Thursday)
    ([Month] = 11
    AND [day_of_week] = 5
    AND date_id IN (SELECT
        MIN(date_id) + 21
    FROM
        [vrs_dm].[dim_date]
    WHERE
                                    [Month] = 11
        AND [day_of_week] = 5
    GROUP BY
                                    [Year])
             )
    OR
    --Memorial Day (last Monday)
    ([Month] = 5
    AND [day_of_week] = 2
    AND date_id IN (SELECT
        MAX(date_id)
    FROM
        [vrs_dm].[dim_date]
    WHERE
                                    [Month] = 5
        AND [day_of_week] = 2
    GROUP BY
                                    [Year])
             )
    OR
    -- Labor Day (1st Monday)
    ([Month] = 9
    AND [day_of_week] = 2
    AND date_id IN (SELECT
        MIN(date_id)
    FROM
        [vrs_dm].[dim_date]
    WHERE
                                    [Month] = 9
        AND [day_of_week] = 2
    GROUP BY
                                    [Year])
             )
    OR
    --Martin Luther King Day (3rd Monday)
    ([Month] = 1
    AND [day_of_week] = 2
    AND date_id IN (SELECT
        MIN(date_id) + 14
    FROM
        [vrs_dm].[dim_date]
    WHERE
                                    [Month] = 1
        AND [day_of_week] = 2
    GROUP BY
                                    [Year])
             )
    -- Columbus Day
    OR ([Month] = 10
    AND [day_of_week] = 2
    AND date_id IN (SELECT
        MIN(date_id) + 7
    FROM
        [vrs_dm].[dim_date]
    WHERE
                                        [Month] = 10
        AND [day_of_week] = 2
    GROUP BY
                                        [Year])
                )
            )

/* ====== Now adjust for the days when the holiday is not a "Monday Holiday", and falls on a weekend.  ======
In most companies, Saturday holidays are observed the Friday before and Sunday holidays the Monday after, 
but you can adjust this as needed */
--Set Saturday holidays to Friday
      UPDATE
            [vrs_dm].[dim_date]
        SET 
            IS_HOLIDAY = 1
           ,IS_BUS_DAY = 0
        WHERE
            date_id IN (SELECT
    date_id - 1
FROM
    [vrs_dm].[dim_date]
WHERE
                                IS_HOLIDAY = 1
    AND [day_of_week] = 7)

--Set Sunday holidays to Monday
      UPDATE
            [vrs_dm].[dim_date]
        SET 
            IS_HOLIDAY = 1
           ,IS_BUS_DAY = 0
        WHERE
            date_id IN (SELECT
    date_id + 1
FROM
    [vrs_dm].[dim_date]
WHERE
                                IS_HOLIDAY = 1
    AND [day_of_week] = 1)

/* ========================== Add in the end-of-period values ==================== 
These are especially useful for aggregation and sorting, since you can order by LDM,
for example, and have the order be in the correct calendar order, even across multiple years instead of running datepart calculations for this purpose
*/      UPDATE
            [vrs_dm].[dim_date]
        SET 
            LDM = ld.LDM
           ,LDQ = ld.LDQ
           ,LDY = ld.LDY
        FROM
    (SELECT
        date_id
                   , [vrs_dm].svfn_AMS_LDM(Month, Year) AS LDM
                   , [vrs_dm].svfn_AMS_LDQ(Quarter, Year) AS LDQ
                   , [vrs_dm].svfn_AMS_LDY(Year) AS LDY
                   , dates_1.month_text
                   , dates_1.[month_text_abbrev]
                   , dates_1.Year
    FROM
        [vrs_dm].[dim_date] AS Dates_1
            ) AS ld
    INNER JOIN [vrs_dm].[dim_date]
    ON ld.date_id = [vrs_dm].[dim_date].date_id

      
      SELECT
    RESULT = 'Success'
END TRY
BEGIN CATCH

      SELECT
    RESULT = 'Error ' + CONVERT(VARCHAR(2000), @@ERROR) + ' on line '
            + ERROR_LINE() + ': ' + ERROR_MESSAGE()
      RETURN       
END CATCH                   

GO