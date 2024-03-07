/*********************************************************************************************************
    
    Data scrubbing tools for LastNames
    https://www.sqlservercentral.com/articles/random-word-generation-for-data-scrubbing

*********************************************************************************************************/
if exists(Select * from sys.tables where [name] ='DataScrubbingLastNames')
BEGIN
	print'DROP TABLE [dbo].[DataScrubbingLastNames]';
    DROP TABLE [dbo].[DataScrubbingLastNames];
END
GO
    print'CREATE TABLE [dbo].[DataScrubbingLastNames]';
    CREATE TABLE [dbo].[DataScrubbingLastNames](
    [LastName] [varchar](50) COLLATE SQL_Latin1_General_Cp1_CS_AS NOT NULL ,
    [LastNameID] [int] IDENTITY(1,1) NOT NULL,
    CONSTRAINT [PK_DataScrubbingLastNames] PRIMARY KEY CLUSTERED 
    (
    [LastName] ASC 
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
    CREATE NONCLUSTERED INDEX [IX_LastNameS_LastNameID] ON [dbo].[DataScrubbingLastNames]
    (
    [LastNameID] ASC
    )
    INCLUDE 
    ( 
    [LastName]
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
GO
CREATE VIEW [dbo].[ds_vwGetRandom]
AS
SELECT RAND() AS MyRAND
 ;
GO


--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF  EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ds_fnRandomLastNameBetween]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))

BEGIN
	 print'DROP FUNCTION [dbo].[ds_fnRandomLastNameBetween]';
	  DROP FUNCTION [dbo].[ds_fnRandomLastNameBetween];
END
GO
    print'  CREATE FUNCTION [dbo].[ds_fnRandomLastNameBetween]';
GO
CREATE FUNCTION [dbo].[ds_fnRandomLastNameBetween](@LowerBound INT, @UpperBound INT)
RETURNS INT
AS
BEGIN
    DECLARE @TMP FLOAT;
    SELECT @TMP = (SELECT MyRAND FROM ds_vwGetRandom);
    RETURN CAST(@TMP* (@UpperBound - @LowerBound) + @LowerBound AS INT);
END   ;

GO
--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ds_fnRandomLastName]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
BEGIN
    print'DROP FUNCTION [dbo].[ds_fnRandomLastName]';
    DROP FUNCTION [dbo].[ds_fnRandomLastName]
END
GO
    print'  CREATE FUNCTION [dbo].[ds_fnRandomLastName]';
    GO

CREATE Function [dbo].[ds_fnRandomLastName]()
returns VARCHAR(255)
as
BEGIN
return 
(
    select 
top 1 
    UPPER(LEFT(LastName,1)) +
LOWER(SUBSTRING(LastName,2,LEN(LastName))) as LastName 
from [DataScrubbingLastNames] 
where LastNameId = dbo.ds_fnRandomLastNameBetween(1,(select max(LastNameid) from [DataScrubbingLastNames]))
)
END;
GO
GO


--////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id = OBJECT_ID(N'[dbo].[ds_fnRandomLastNames]')
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
BEGIN
	Print'DROP FUNCTION [dbo].[ds_fnRandomLastNames]';
    DROP FUNCTION [dbo].[ds_fnRandomLastNames]
END
GO
print' CREATE FUNCTION [dbo].[ds_fnRandomLastNames]';
GO
CREATE Function [dbo].[ds_fnRandomLastNames](@LastNamesRequired int)
returns VARCHAR(255)
as
BEGIN
    Declare @result nvarchar(4000) =''
    DECLARE @counter INT SET @counter = 0 
		
    WHILE @counter < @LastNamesRequired
    BEGIN 
       set @result= @result+' ' + dbo.ds_fnRandomLastName()
       SET @counter = @counter + 1
       if(@counter %14 =0)
             set @result= @result+'. '
    END
return 
(
	

select ltrim(rTrim(@result)) as [LastNames]
)
END;
   

GO

Truncate Table [DataScrubbingLastNames];
Insert into [DataScrubbingLastNames](LastName)
		            SELECT 'Ahmad'
UNION ALL SELECT 'Aldridge'
UNION ALL SELECT 'Allen'
UNION ALL SELECT 'Allison'
UNION ALL SELECT 'Anderson'
UNION ALL SELECT 'Baines'
UNION ALL SELECT 'Baird'
UNION ALL SELECT 'Baker'
UNION ALL SELECT 'Beale'
UNION ALL SELECT 'Beattie'
UNION ALL SELECT 'Bedford'
UNION ALL SELECT 'Bell'
UNION ALL SELECT 'Bellamy'
UNION ALL SELECT 'Benson'
UNION ALL SELECT 'Blackburn'
UNION ALL SELECT 'Blair'
UNION ALL SELECT 'Bloomfield'
UNION ALL SELECT 'Boardman'
UNION ALL SELECT 'Bonner'
UNION ALL SELECT 'Bowers'
UNION ALL SELECT 'Brett'
UNION ALL SELECT 'Brown'
UNION ALL SELECT 'Browne'
UNION ALL SELECT 'Burnett'
UNION ALL SELECT 'Bush'
UNION ALL SELECT 'Butt'
UNION ALL SELECT 'Cairns'
UNION ALL SELECT 'Campbell'
UNION ALL SELECT 'Carmichael'
UNION ALL SELECT 'Carruthers'
UNION ALL SELECT 'Chadwick'
UNION ALL SELECT 'Chan'
UNION ALL SELECT 'Chandler'
UNION ALL SELECT 'Chaplin'
UNION ALL SELECT 'Christie'
UNION ALL SELECT 'Clark'
UNION ALL SELECT 'Clarke'
UNION ALL SELECT 'Colley'
UNION ALL SELECT 'Collier'
UNION ALL SELECT 'Conroy'
UNION ALL SELECT 'Cooper'
UNION ALL SELECT 'Cope'
UNION ALL SELECT 'Copeland'
UNION ALL SELECT 'Corbyn'
UNION ALL SELECT 'Cotton'
UNION ALL SELECT 'Cowie'
UNION ALL SELECT 'Crane'
UNION ALL SELECT 'Croft'
UNION ALL SELECT 'Crouch'
UNION ALL SELECT 'Cullen'
UNION ALL SELECT 'Currie'
UNION ALL SELECT 'Daly'
UNION ALL SELECT 'Davies'
UNION ALL SELECT 'Dempsey'
UNION ALL SELECT 'Dennis'
UNION ALL SELECT 'Devine'
UNION ALL SELECT 'Donaldson'
UNION ALL SELECT 'Dutton'
UNION ALL SELECT 'East'
UNION ALL SELECT 'Edwards'
UNION ALL SELECT 'Emery'
UNION ALL SELECT 'England'
UNION ALL SELECT 'English'
UNION ALL SELECT 'Evans'
UNION ALL SELECT 'Farmer'
UNION ALL SELECT 'Faulkner'
UNION ALL SELECT 'Fenton'
UNION ALL SELECT 'Findlay'
UNION ALL SELECT 'Finlay'
UNION ALL SELECT 'Fish'
UNION ALL SELECT 'Fitzpatrick'
UNION ALL SELECT 'Foley'
UNION ALL SELECT 'Forbes'
UNION ALL SELECT 'Gates'
UNION ALL SELECT 'Gibb'
UNION ALL SELECT 'Godfrey'
UNION ALL SELECT 'Goodall'
UNION ALL SELECT 'Gosling'
UNION ALL SELECT 'Gough'
UNION ALL SELECT 'Grainger'
UNION ALL SELECT 'Green'
UNION ALL SELECT 'Griffith'
UNION ALL SELECT 'Gunn'
UNION ALL SELECT 'Hall'
UNION ALL SELECT 'Halliday'
UNION ALL SELECT 'Hampton'
UNION ALL SELECT 'Hannah'
UNION ALL SELECT 'Hanson'
UNION ALL SELECT 'Hardwick'
UNION ALL SELECT 'Harris'
UNION ALL SELECT 'Harrison'
UNION ALL SELECT 'Hassan'
UNION ALL SELECT 'Hawes'
UNION ALL SELECT 'Hill'
UNION ALL SELECT 'Hilton'
UNION ALL SELECT 'Hinton'
UNION ALL SELECT 'Hodge'
UNION ALL SELECT 'Holliday'
UNION ALL SELECT 'Hook'
UNION ALL SELECT 'Hope'
UNION ALL SELECT 'Howarth'
UNION ALL SELECT 'Hughes'
UNION ALL SELECT 'Hurst'
UNION ALL SELECT 'Inglis'
UNION ALL SELECT 'Ingram'
UNION ALL SELECT 'Jackson'
UNION ALL SELECT 'James'
UNION ALL SELECT 'Johnson'
UNION ALL SELECT 'Jones'
UNION ALL SELECT 'Kearney'
UNION ALL SELECT 'Keenan'
UNION ALL SELECT 'Kidd'
UNION ALL SELECT 'King'
UNION ALL SELECT 'Lake'
UNION ALL SELECT 'Lang'
UNION ALL SELECT 'Larkin'
UNION ALL SELECT 'Lee'
UNION ALL SELECT 'Lees'
UNION ALL SELECT 'Lewis'
UNION ALL SELECT 'Livingstone'
UNION ALL SELECT 'Lovell'
UNION ALL SELECT 'Lyons'
UNION ALL SELECT 'MacLean'
UNION ALL SELECT 'Maguire'
UNION ALL SELECT 'Mahmood'
UNION ALL SELECT 'Mahoney'
UNION ALL SELECT 'Martin'
UNION ALL SELECT 'Maxwell'
UNION ALL SELECT 'McCormack'
UNION ALL SELECT 'McKeown'
UNION ALL SELECT 'McNamara'
UNION ALL SELECT 'Mead'
UNION ALL SELECT 'Milner'
UNION ALL SELECT 'Mitchell'
UNION ALL SELECT 'Moore'
UNION ALL SELECT 'Morgan'
UNION ALL SELECT 'Morris'
UNION ALL SELECT 'Mortimer'
UNION ALL SELECT 'Muir'
UNION ALL SELECT 'Mullen'
UNION ALL SELECT 'Newell'
UNION ALL SELECT 'Nixon'
UNION ALL SELECT 'Norton'
UNION ALL SELECT 'Oldfield'
UNION ALL SELECT 'Parkin'
UNION ALL SELECT 'Patel'
UNION ALL SELECT 'Paton'
UNION ALL SELECT 'Pepper'
UNION ALL SELECT 'Phillips'
UNION ALL SELECT 'Pollard'
UNION ALL SELECT 'Pope'
UNION ALL SELECT 'Potts'
UNION ALL SELECT 'Pullen'
UNION ALL SELECT 'Pye'
UNION ALL SELECT 'Ramsden'
UNION ALL SELECT 'Roberts'
UNION ALL SELECT 'Robinson'
UNION ALL SELECT 'Roche'
UNION ALL SELECT 'Rodgers'
UNION ALL SELECT 'Rowley'
UNION ALL SELECT 'Scott'
UNION ALL SELECT 'Shannon'
UNION ALL SELECT 'Sharman'
UNION ALL SELECT 'Sims'
UNION ALL SELECT 'Smith'
UNION ALL SELECT 'Spooner'
UNION ALL SELECT 'Stafford'
UNION ALL SELECT 'Stanton'
UNION ALL SELECT 'Storey'
UNION ALL SELECT 'Stott'
UNION ALL SELECT 'Street'
UNION ALL SELECT 'Strong'
UNION ALL SELECT 'Summers'
UNION ALL SELECT 'Swann'
UNION ALL SELECT 'Sweeney'
UNION ALL SELECT 'Swift'
UNION ALL SELECT 'Tate'
UNION ALL SELECT 'Taylor'
UNION ALL SELECT 'Thomas'
UNION ALL SELECT 'Thompson'
UNION ALL SELECT 'Tilley'
UNION ALL SELECT 'Turner'
UNION ALL SELECT 'Valentine'
UNION ALL SELECT 'Vincent'
UNION ALL SELECT 'Walker'
UNION ALL SELECT 'Wallis'
UNION ALL SELECT 'Ward'
UNION ALL SELECT 'Ware'
UNION ALL SELECT 'Watson'
UNION ALL SELECT 'Welch'
UNION ALL SELECT 'White'
UNION ALL SELECT 'Whitfield'
UNION ALL SELECT 'Whittle'
UNION ALL SELECT 'Wilcox'
UNION ALL SELECT 'Williams'
UNION ALL SELECT 'Wilson'
UNION ALL SELECT 'Wong'
UNION ALL SELECT 'Wood'
UNION ALL SELECT 'Wright'
UNION ALL SELECT 'Young'
                  GO

select TOp 10
    dbo.ds_fnRandomLastNames(1) as [LastName]
    ,dbo.ds_fnRandomLastNames(10) as [Sentence]
    ,replace(dbo.ds_fnRandomLastNames(2),' ','.') +'@' + dbo.ds_fnRandomLastNames(1) +'.nothing' as [Email Address]
from master..sysobjects

GO

