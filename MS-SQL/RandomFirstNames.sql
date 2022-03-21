/*********************************************************************************************************
    
    Data scrubbing tools for PhoneNumbers
    https://www.sqlservercentral.com/articles/random-word-generation-for-data-scrubbing

*********************************************************************************************************/
if exists(Select * from sys.tables where [name] ='DataScrubbingPhoneNumbers')
BEGIN
	print'DROP TABLE [dbo].[DataScrubbingPhoneNumbers]';
    DROP TABLE [dbo].[DataScrubbingPhoneNumbers];
END
GO
    print'CREATE TABLE [dbo].[DataScrubbingPhoneNumbers]';
    CREATE TABLE [dbo].[DataScrubbingPhoneNumbers](
    [PhoneNumber] [varchar](50) COLLATE SQL_Latin1_General_Cp1_CS_AS NOT NULL ,
	[gender]	[varchar](10) Not NULL,
    [PhoneNumberID] [int] IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_DataScrubbingPhoneNumbers] PRIMARY KEY CLUSTERED 
    (
    [PhoneNumber] ASC 
    )
    WITH 
    (
    PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
    , IGNORE_DUP_KEY = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    ) ON [PRIMARY]
    ) ON [PRIMARY]
    ;
    CREATE NONCLUSTERED INDEX [IX_PhoneNumberS_PhoneNumberID] ON [dbo].[DataScrubbingPhoneNumbers]
    (
    [PhoneNumberID] ASC
    )
    INCLUDE 
    ( 
    [PhoneNumber]
    ) 
    WITH 
    (
    PAD_INDEX = OFF
    , STATISTICS_NORECOMPUTE = OFF
    , SORT_IN_TEMPDB = OFF
    , DROP_EXISTING = OFF
    , ONLINE = OFF
    , ALLOW_ROW_LOCKS = ON
    , ALLOW_PAGE_LOCKS = ON
    ) ON [PRIMARY]


GO
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
if exists(Select * from sys.views where [name] ='ds_vwGetRandom')
BEGIN
	print 'DROP VIEW [dbo].[ds_vwGetRandom]'
	DROP VIEW [dbo].[ds_vwGetRandom]
END

GO
    print'  CREATE VIEW [dbo].[ds_vwGetRandom]';
    EXEC('
CREATE VIEW [dbo].[ds_vwGetRandom]
AS
SELECT RAND() AS MyRAND
')   ;
GO


--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF  EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ds_fnRandomPhoneNumberBetween]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))

BEGIN
	 print'DROP FUNCTION [dbo].[ds_fnRandomPhoneNumberBetween]';
	  DROP FUNCTION [dbo].[ds_fnRandomPhoneNumberBetween];
END
GO
    print'  CREATE FUNCTION [dbo].[ds_fnRandomPhoneNumberBetween]';
    EXEC('
CREATE FUNCTION [dbo].[ds_fnRandomPhoneNumberBetween](@LowerBound INT, @UpperBound INT)
RETURNS INT
AS
BEGIN
    DECLARE @TMP FLOAT;
    SELECT @TMP = (SELECT MyRAND FROM ds_vwGetRandom);
    RETURN CAST(@TMP* (@UpperBound - @LowerBound) + @LowerBound AS INT);
END
   ')   ;


--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ds_fnRandomPhoneNumber]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
BEGIN
    print'DROP FUNCTION [dbo].[ds_fnRandomPhoneNumber]';
    DROP FUNCTION [dbo].[ds_fnRandomPhoneNumber]
END
GO
    print'  CREATE FUNCTION [dbo].[ds_fnRandomPhoneNumber]';
    GO

	exec('
CREATE Function [dbo].[ds_fnRandomPhoneNumber]()
returns VARCHAR(255)
as
BEGIN
return 
(
    select 
top 1 
    UPPER(LEFT(PhoneNumber,1)) +
LOWER(SUBSTRING(PhoneNumber,2,LEN(PhoneNumber))) as PhoneNumber 
from [DataScrubbingPhoneNumbers] 
where PhoneNumberId = dbo.ds_fnRandomPhoneNumberBetween(1,(select max(PhoneNumberid) from [DataScrubbingPhoneNumbers]))
)
END;
');
GO
GO


--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ds_fnRandomPhoneNumbers]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
BEGIN
	Print'DROP FUNCTION [dbo].[ds_fnRandomPhoneNumbers]';
    DROP FUNCTION [dbo].[ds_fnRandomPhoneNumbers]
END
GO
print' CREATE FUNCTION [dbo].[ds_fnRandomPhoneNumbers]';
GO
CREATE Function [dbo].[ds_fnRandomPhoneNumbers](@PhoneNumbersRequired int)
returns VARCHAR(255)
as
BEGIN
    Declare @result nvarchar(4000) =''
    DECLARE @counter INT SET @counter = 0 
		
    WHILE @counter < @PhoneNumbersRequired
    BEGIN 
       set @result= @result+' ' + dbo.ds_fnRandomPhoneNumber()
       SET @counter = @counter + 1
       if(@counter %14 =0)
             set @result= @result+'. '
    END
return 
(
	

select ltrim(rTrim(@result)) as [PhoneNumbers]
)
END;
   

GO

Truncate Table [DataScrubbingPhoneNumbers];
Insert into [DataScrubbingPhoneNumbers](PhoneNumber, Gender)
		  SELECT 'Aidan', 'male'
UNION ALL SELECT 'Alba', 'female'
UNION ALL SELECT 'Albert', 'female'
UNION ALL SELECT 'Albertina', 'female'
UNION ALL SELECT 'Alexander', 'male'
UNION ALL SELECT 'Alice', 'female'
UNION ALL SELECT 'Alverda', 'female'
UNION ALL SELECT 'Alwine', 'female'
UNION ALL SELECT 'Amma', 'female'
UNION ALL SELECT 'Amos', 'male'
UNION ALL SELECT 'Andrea', 'female'
UNION ALL SELECT 'Andrew', 'male'
UNION ALL SELECT 'Angel', 'male'
UNION ALL SELECT 'Angelita', 'female'
UNION ALL SELECT 'Anna', 'female'
UNION ALL SELECT 'Anner', 'female'
UNION ALL SELECT 'Annie', 'female'
UNION ALL SELECT 'Anthony', 'male'
UNION ALL SELECT 'Antonette', 'female'
UNION ALL SELECT 'Arabella', 'female'
UNION ALL SELECT 'Arnav', 'male'
UNION ALL SELECT 'Atha', 'female'
UNION ALL SELECT 'Augustine', 'female'
UNION ALL SELECT 'Austen', 'male'
UNION ALL SELECT 'Austin', 'male'
UNION ALL SELECT 'Beaulah', 'female'
UNION ALL SELECT 'Becky', 'female'
UNION ALL SELECT 'Beda', 'female'
UNION ALL SELECT 'Bena', 'female'
UNION ALL SELECT 'Benito', 'male'
UNION ALL SELECT 'Benjamin', 'male'
UNION ALL SELECT 'Benny', 'male'
UNION ALL SELECT 'Bernardo', 'male'
UNION ALL SELECT 'Bertha', 'female'
UNION ALL SELECT 'Bessie', 'female'
UNION ALL SELECT 'Beula', 'female'
UNION ALL SELECT 'Biddie', 'female'
UNION ALL SELECT 'Billie', 'female'
UNION ALL SELECT 'Birtha', 'female'
UNION ALL SELECT 'Brandon', 'male'
UNION ALL SELECT 'Bret', 'male'
UNION ALL SELECT 'Bridger', 'male'
UNION ALL SELECT 'Caddie', 'female'
UNION ALL SELECT 'Caleb', 'male'
UNION ALL SELECT 'Campbell', 'male'
UNION ALL SELECT 'Canyon', 'male'
UNION ALL SELECT 'Carl', 'female'
UNION ALL SELECT 'Carmelita', 'female'
UNION ALL SELECT 'Cash', 'male'
UNION ALL SELECT 'Celesta', 'female'
UNION ALL SELECT 'Celestine', 'female'
UNION ALL SELECT 'Celie', 'female'
UNION ALL SELECT 'Christian', 'male'
UNION ALL SELECT 'Christopher', 'male'
UNION ALL SELECT 'Clara', 'female'
UNION ALL SELECT 'Clemma', 'female'
UNION ALL SELECT 'Clora', 'female'
UNION ALL SELECT 'Connor', 'male'
UNION ALL SELECT 'Coy', 'male'
UNION ALL SELECT 'Cristobal', 'male'
UNION ALL SELECT 'Cristofer', 'male'
UNION ALL SELECT 'Daisie', 'female'
UNION ALL SELECT 'Dale', 'female'
UNION ALL SELECT 'Daniel', 'male'
UNION ALL SELECT 'Daryl', 'male'
UNION ALL SELECT 'David', 'male'
UNION ALL SELECT 'Delma', 'female'
UNION ALL SELECT 'Deshaun', 'male'
UNION ALL SELECT 'Dessa', 'female'
UNION ALL SELECT 'Destin', 'male'
UNION ALL SELECT 'Dontae', 'male'
UNION ALL SELECT 'Dosha', 'female'
UNION ALL SELECT 'Dylan', 'male'
UNION ALL SELECT 'Elena', 'female'
UNION ALL SELECT 'Eleonora', 'female'
UNION ALL SELECT 'Elia', 'female'
UNION ALL SELECT 'Eliezer', 'male'
UNION ALL SELECT 'Elijah', 'male'
UNION ALL SELECT 'Elizabeth', 'female'
UNION ALL SELECT 'Ella', 'female'
UNION ALL SELECT 'Eloisa', 'female'
UNION ALL SELECT 'Elvin', 'male'
UNION ALL SELECT 'Emma', 'female'
UNION ALL SELECT 'Emmaline', 'female'
UNION ALL SELECT 'Eppie', 'female'
UNION ALL SELECT 'Ernest', 'female'
UNION ALL SELECT 'Ethan', 'male'
UNION ALL SELECT 'Ethel', 'female'
UNION ALL SELECT 'Evan', 'male'
UNION ALL SELECT 'Exie', 'female'
UNION ALL SELECT 'Ferne', 'female'
UNION ALL SELECT 'Fidel', 'male'
UNION ALL SELECT 'Fleta', 'female'
UNION ALL SELECT 'Fletcher', 'male'
UNION ALL SELECT 'Florance', 'female'
UNION ALL SELECT 'Florence', 'female'
UNION ALL SELECT 'Freddie', 'male'
UNION ALL SELECT 'Gabriel', 'male'
UNION ALL SELECT 'Gene', 'female'
UNION ALL SELECT 'Gina', 'female'
UNION ALL SELECT 'Giovani', 'male'
UNION ALL SELECT 'Glen', 'male'
UNION ALL SELECT 'Grace', 'female'
UNION ALL SELECT 'Gretta', 'female'
UNION ALL SELECT 'Gustie', 'female'
UNION ALL SELECT 'Hazle', 'female'
UNION ALL SELECT 'Helen', 'female'
UNION ALL SELECT 'Ida', 'female'
UNION ALL SELECT 'Isaac', 'male'
UNION ALL SELECT 'Isaiah', 'male'
UNION ALL SELECT 'Ivory', 'female'
UNION ALL SELECT 'Izora', 'female'
UNION ALL SELECT 'Jack', 'male'
UNION ALL SELECT 'Jackson', 'male'
UNION ALL SELECT 'Jacob', 'male'
UNION ALL SELECT 'James', 'male'
UNION ALL SELECT 'Jamil', 'male'
UNION ALL SELECT 'Jase', 'male'
UNION ALL SELECT 'Jason', 'male'
UNION ALL SELECT 'John', 'male'
UNION ALL SELECT 'Jonathan', 'male'
UNION ALL SELECT 'Jordan', 'male'
UNION ALL SELECT 'Jose', 'male'
UNION ALL SELECT 'Joseph', 'male'
UNION ALL SELECT 'Joshua', 'male'
UNION ALL SELECT 'Joy', 'female'
UNION ALL SELECT 'Joyce', 'female'
UNION ALL SELECT 'Junie', 'female'
UNION ALL SELECT 'Justin', 'male'
UNION ALL SELECT 'Justina', 'female'
UNION ALL SELECT 'Justyn', 'male'
UNION ALL SELECT 'Kasey', 'male'
UNION ALL SELECT 'Kennedy', 'male'
UNION ALL SELECT 'Kevin', 'male'
UNION ALL SELECT 'Kory', 'male'
UNION ALL SELECT 'Kurtis', 'male'
UNION ALL SELECT 'Kyree', 'male'
UNION ALL SELECT 'Lillia', 'female'
UNION ALL SELECT 'Lissie', 'female'
UNION ALL SELECT 'Logan', 'male'
UNION ALL SELECT 'Loma', 'female'
UNION ALL SELECT 'Louis', 'female'
UNION ALL SELECT 'Lu', 'female'
UNION ALL SELECT 'Luke', 'male'
UNION ALL SELECT 'Lulie', 'female'
UNION ALL SELECT 'Mabel', 'female'
UNION ALL SELECT 'Mabell', 'female'
UNION ALL SELECT 'Macy', 'female'
UNION ALL SELECT 'Margaret', 'female'
UNION ALL SELECT 'Marion', 'male'
UNION ALL SELECT 'Martha', 'female'
UNION ALL SELECT 'Mary', 'female'
UNION ALL SELECT 'Matthew', 'male'
UNION ALL SELECT 'Matthias', 'male'
UNION ALL SELECT 'Menachem', 'male'
UNION ALL SELECT 'Michael', 'male'
UNION ALL SELECT 'Mikel', 'male'
UNION ALL SELECT 'Minnie', 'female'
UNION ALL SELECT 'Mordechai', 'male'
UNION ALL SELECT 'Nash', 'male'
UNION ALL SELECT 'Nathan', 'male'
UNION ALL SELECT 'Nicholas', 'male'
UNION ALL SELECT 'Noah', 'male'
UNION ALL SELECT 'Rahul', 'male'
UNION ALL SELECT 'Robert', 'male'
UNION ALL SELECT 'Rocky', 'male'
UNION ALL SELECT 'Ryan', 'male'
UNION ALL SELECT 'Ryker', 'male'
UNION ALL SELECT 'Ryland', 'male'
UNION ALL SELECT 'Samson', 'male'
UNION ALL SELECT 'Samuel', 'male'
UNION ALL SELECT 'Soren', 'male'
UNION ALL SELECT 'Stephon', 'male'
UNION ALL SELECT 'Stuart', 'male'
UNION ALL SELECT 'Sullivan', 'male'
UNION ALL SELECT 'Thomas', 'male'
UNION ALL SELECT 'Trevion', 'male'
UNION ALL SELECT 'Trystan', 'male'
UNION ALL SELECT 'Tyler', 'male'
UNION ALL SELECT 'Vernon', 'male'
UNION ALL SELECT 'William', 'male'
UNION ALL SELECT 'Yusuf', 'male'
UNION ALL SELECT 'Zachary', 'male'
UNION ALL SELECT 'Zaid', 'male'
UNION ALL SELECT 'Zavier', 'male'
UNION ALL SELECT 'Zayne', 'male'
                  GO

select
    dbo.ds_fnRandomPhoneNumber() as [PhoneNumber]
    ,dbo.ds_fnRandomPhoneNumbers(10) as [Sentence]
    ,dbo.ds_fnRandomPhoneNumber() + dbo.ds_fnRandomPhoneNumber() +'@' + dbo.ds_fnRandomPhoneNumber() +'.nothing' as [Email Address]
from master..sysobjects

GO

