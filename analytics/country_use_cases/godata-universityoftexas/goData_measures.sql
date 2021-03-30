/* 
TABLE NAME:         GODATA_MEASURES
SOURCE TABLE:       goData TABLES
DESCRIPTION:        THIS TABLE CONTAINS CONTACT TRACING MEASURE CALCULATIONS AND FEEDS THE TABLEAU DASHBOARD

*/

/******************************************************************
-- ###### APPLIED TO ALL MEASURES (unless otherwise stated) ######
-- 
-- EXCLUDE 'Not a case (discarded)' CLASSIFICATON FROM CASES: 
--        [SOURCE_DB].[DBO].[GODATA_CASES].[CLASSIFICATION] != 'Not a case (discarded)'
--
-- EXCLUDE 'SEROLOGY' TEST TYPE FROM LAB DATA:
--        [SOURCE_DB].[dbo].[GODATA_LAB_RESULTS].[testType] != 'SEROLOGY_IG_G'
--
********************************************************************/

USE SOURCE_DB
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DECLARE @TABLE  VARCHAR(100)
DECLARE @SCHEMA VARCHAR(100)
SET @TABLE = 'GODATA_MEASURES'
SET @SCHEMA = 'DBO'


IF NOT EXISTS ( SELECT *
                FROM INFORMATION_SCHEMA.TABLES
                WHERE   TABLE_NAME = @TABLE
                        AND TABLE_SCHEMA = @SCHEMA  )
BEGIN
    --
    PRINT 'CREATING TABLE '+ @TABLE
    --
    CREATE TABLE DBO.GODATA_MEASURES(
     DATE                        DATETIME NULL,
	AGGREGATION                 VARCHAR(500) NULL,
	MEASURE                     VARCHAR(500) NULL,
	VALUE                       FLOAT NULL,
     MEASURE_DESC                VARCHAR(MAX) NULL,
     NUMERATOR_VALUE             FLOAT NULL,
     DENOMINATOR_VALUE           FLOAT NULL,   
     MEASURE_ID                  INT NULL,
     LAST_UPDATED                DATETIME NULL
) 
END

PRINT 'TRUNCATE TABLE '+ @TABLE
--
TRUNCATE TABLE DBO.GODATA_MEASURES

PRINT 'POPULATING TABLE '+ @TABLE
;
--

INSERT INTO 
     SOURCE_DB.DBO.GODATA_MEASURES
SELECT 
     DATE, 
     AGGREGATION, 
     MEASURE, 
     VALUE,
     MEASURE_DESC,
     NUMERATOR_VALUE,
     DENOMINATOR_VALUE,
     MEASURE_ID,
     LAST_UPDATED
FROM
(

/******************************************************************
--                  ###### MEASURES ######
********************************************************************/

/******************************************************************
-- MEASURE 1:       Proportion of cases that were contacts identified by tracing	
--
-- PURPOSE:         Success of reactive surveillance/contact tracing	
-- CALCULATION:     Quotient of 
--                       (Distinct Count of UUID where [result] = 'POSITIVE' & [WAS_A_CONTACT] = TRUE and 
                         ([DATE_OF_BECOMING_CASE] - DATE_OF_LAST_CONTACT(exposure date)) <= 14))) 
--                            and (Distinct Count of UUID)	
-- TABLES:          GODATA_LAB_RESULT, GODATA_CASES
-- AGGREGATION:     Week		
-- DATE:            Close Date	
********************************************************************/

SELECT 
     DENOM.DATE
    ,'Week' AS AGGREGATION
    ,'Proportion of cases that were contacts identified by tracing' AS MEASURE
    ,ROUND(ISNULL(NUM.VALUE,0)*1.0 / DENOM.VALUE,2) AS VALUE
    ,'Quotient of (Distinct Count of Case ID where [result] = POSITIVE & [WAS_A_CONTACT] = TRUE and ([DATE_OF_BECOMING_CASE] - DATE_OF_LAST_CONTACT(exposure date)) <= 14)) and (Distinct Count of Case ID)' AS MEASURE_DESC
    ,ISNULL(NUM.VALUE,0)*1.0 AS NUMERATOR_VALUE 
    ,DENOM.VALUE AS DENOMINATOR_VALUE
    ,1 AS MEASURE_ID
    ,CAST(GETDATE()-1 AS DATE) AS LAST_UPDATED
FROM (
        SELECT 
            DIMDATE.[WEEK_ENDING] AS DATE
           ,COUNT(DISTINCT CASES.[ID]) AS VALUE 
        FROM [SOURCE_DB].[DBO].[GODATA_CASES] CASES
             INNER JOIN ( SELECT * FROM [SOURCE_DB].[DBO].[GODATA_LAB_RESULTS] WHERE [testType] != 'SEROLOGY_IG_G' ) LABS ON CASES.[ID] = LABS.[PERSONID]
             INNER JOIN ( SELECT * FROM [SOURCE_DB].[DBO].[GODATA_RELATIONSHIPS]) RELATIONSHIPS ON RELATIONSHIPS.TARGET_UID=CASES.[ID]
             INNER JOIN [SOURCE_DB].[DBO].[DIM_DATE] DIMDATE ON DIMDATE.[FULL_DATE]=CASES.[QUESTIONNAIRE_ANSWERS_DATE_OF_CASE_INVESTIGATION_CLOSURE_0_VALUE]
        WHERE CASES.[CLASSIFICATION] != 'Not a case (discarded)' 
              AND LABS.[RESULT] = 'POSITIVE'
              AND CASES.[WAS_A_CONTACT] = 'TRUE'
              AND DATEDIFF(DAY, CASES.[DATE_OF_BECOMING_CASE], RELATIONSHIPS.DATE_OF_LAST_CONTACT) < 15
        GROUP BY DIMDATE.[WEEK_ENDING]
) NUM
RIGHT JOIN (
        SELECT 
            DIMDATE.[WEEK_ENDING] AS DATE
           ,COUNT(DISTINCT CASES.[ID]) AS VALUE 
        FROM [SOURCE_DB].[DBO].[GODATA_CASES] CASES
             INNER JOIN ( SELECT * FROM [SOURCE_DB].[DBO].[GODATA_LAB_RESULTS] WHERE [testType] != 'SEROLOGY_IG_G' ) LABS ON CASES.[ID] = LABS.[PERSONID]
             INNER JOIN [SOURCE_DB].[DBO].[DIM_DATE] DIMDATE ON DIMDATE.[FULL_DATE]=CASES.[QUESTIONNAIRE_ANSWERS_DATE_OF_CASE_INVESTIGATION_CLOSURE_0_VALUE]
        WHERE CASES.[CLASSIFICATION] != 'Not a case (discarded)' 
              AND LABS.[RESULT] = 'POSITIVE'
              
        GROUP BY DIMDATE.[WEEK_ENDING]
) DENOM ON NUM.DATE = DENOM.DATE

UNION ALL


/******************************************************************
-- MEASURE 2:       Proportion of contacts by context exposure site
--	
-- PURPOSE:         Where to target prevention and control measures	
-- CALCULATION:     Quotient of
--                       Distinct Count of ID by [CONTEXT_OF_EXPOSURE] 
--                       / Distinct Count of ID
-- TABLES:          GODATA_RELATIONSHIPS, DIM_DATE	
-- AGGREGATION:	Context of Exposure
-- DATE:            Date of Last Contact	
********************************************************************/

SELECT DENOM.DATE AS DATE
     ,NUM.AGGREGATION AS AGGREGATION
     ,'Proportion of contacts by context exposure site' AS MEASURE
     ,NUM.VALUE / DENOM.VALUE AS VALUE
     ,'Distinct Count of ID by [CONTEXT_OF_EXPOSURE]' AS MEASURE_DESC
     ,NUM.VALUE AS NUMERATOR_VALUE 
     ,DENOM.VALUE AS DENOMINATOR_VALUE
     ,2 AS MEASURE_ID
     , CAST(GETDATE()-1 AS DATE) AS LAST_UPDATED
FROM (
    SELECT
        DT.[WEEK_ENDING] AS DATE 
        ,CASE 
            WHEN RELATIONSHIPS.[CONTEXT_OF_EXPOSURE] = 'Other (please specify in comment field)' THEN 'Other'
            ELSE COALESCE(RELATIONSHIPS.[CONTEXT_OF_EXPOSURE],'Unknown') 
        END AS AGGREGATION
        ,CAST( (COUNT(DISTINCT RELATIONSHIPS.ID) ) AS FLOAT) AS VALUE
    FROM
        [SOURCE_DB].[DBO].[GODATA_RELATIONSHIPS] RELATIONSHIPS
        LEFT OUTER JOIN [SOURCE_DB].[dbo].[DIM_DATE] DT ON CAST(RELATIONSHIPS.[DATE_OF_LAST_CONTACT] AS DATE)=DT.FULL_DATE
    GROUP BY
        DT.[WEEK_ENDING]
        ,CASE 
            WHEN RELATIONSHIPS.[CONTEXT_OF_EXPOSURE] = 'Other (please specify in comment field)' THEN 'Other'
            ELSE COALESCE(RELATIONSHIPS.[CONTEXT_OF_EXPOSURE],'Unknown') 
        END
    )  NUM
RIGHT JOIN (
    SELECT
        DT.[WEEK_ENDING] AS DATE 
        ,CAST( (COUNT(DISTINCT RELATIONSHIPS.ID) ) AS FLOAT) AS VALUE
     FROM
        [SOURCE_DB].[DBO].[GODATA_RELATIONSHIPS] RELATIONSHIPS
        LEFT OUTER JOIN [SOURCE_DB].[dbo].[DIM_DATE] DT ON CAST(RELATIONSHIPS.[DATE_OF_LAST_CONTACT] AS DATE)=DT.FULL_DATE
     GROUP BY
        DT.[WEEK_ENDING]
    ) DENOM ON NUM.DATE=DENOM.DATE


) complete
GO