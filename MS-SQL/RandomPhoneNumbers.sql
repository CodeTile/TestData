/*********************************************************************************************************
    
    Data scrubbing tools for PhoneNumbers
    https://www.sqlservercentral.com/articles/random-word-generation-for-data-scrubbing


	Phone numbers are fake phone numbers used for the UK TV and film productions.
	https://www.ofcom.org.uk/phones-telecoms-and-internet/information-for-industry/numbering/numbers-for-drama

*********************************************************************************************************/
if exists(Select * from sys.tables where [name] ='DataScrubbingPhoneNumbers')
BEGIN
	print'DROP TABLE [dbo].[DataScrubbingPhoneNumbers]';
    DROP TABLE [dbo].[DataScrubbingPhoneNumbers];
END
GO
    print'CREATE TABLE [dbo].[DataScrubbingPhoneNumbers]';
    CREATE TABLE [dbo].[DataScrubbingPhoneNumbers](
    [PhoneNumber]				[varchar](50) ,
	[PhoneType]					[varchar](20),
	[Country]					[varchar](20),
	[InternationalDialingCode]	[varchar](20),
    [PhoneNumberID]			[int] IDENTITY(1,1) NOT NULL,
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
Insert into [DataScrubbingPhoneNumbers](PhoneNumber,[PhoneType],[Country],[InternationalDialingCode])
		  SELECT '07700900000', 'Mobile', 'UK', '44'
UNION ALL SELECT '07711900023', 'Mobile', 'UK', '44'
UNION ALL SELECT '07722900046', 'Mobile', 'UK', '44'
UNION ALL SELECT '07733900069', 'Mobile', 'UK', '44'
UNION ALL SELECT '07744900092', 'Mobile', 'UK', '44'
UNION ALL SELECT '07755900115', 'Mobile', 'UK', '44'
UNION ALL SELECT '07766900138', 'Mobile', 'UK', '44'
UNION ALL SELECT '07777900161', 'Mobile', 'UK', '44'
UNION ALL SELECT '07788900184', 'Mobile', 'UK', '44'
UNION ALL SELECT '07799900207', 'Mobile', 'UK', '44'
UNION ALL SELECT '07810900230', 'Mobile', 'UK', '44'
UNION ALL SELECT '07821900253', 'Mobile', 'UK', '44'
UNION ALL SELECT '07832900276', 'Mobile', 'UK', '44'
UNION ALL SELECT '07843900299', 'Mobile', 'UK', '44'
UNION ALL SELECT '07854900322', 'Mobile', 'UK', '44'
UNION ALL SELECT '07865900345', 'Mobile', 'UK', '44'
UNION ALL SELECT '07876900368', 'Mobile', 'UK', '44'
UNION ALL SELECT '07887900391', 'Mobile', 'UK', '44'
UNION ALL SELECT '07898900414', 'Mobile', 'UK', '44'
UNION ALL SELECT '07909900437', 'Mobile', 'UK', '44'
UNION ALL SELECT '07920900460', 'Mobile', 'UK', '44'
UNION ALL SELECT '07931900483', 'Mobile', 'UK', '44'
UNION ALL SELECT '07942900506', 'Mobile', 'UK', '44'
UNION ALL SELECT '07953900529', 'Mobile', 'UK', '44'
UNION ALL SELECT '07964900552', 'Mobile', 'UK', '44'
UNION ALL SELECT '07975900575', 'Mobile', 'UK', '44'
UNION ALL SELECT '07986900598', 'Mobile', 'UK', '44'
UNION ALL SELECT '07997900621', 'Mobile', 'UK', '44'
UNION ALL SELECT '08008900644', 'Mobile', 'UK', '44'
UNION ALL SELECT '08019900667', 'Mobile', 'UK', '44'
UNION ALL SELECT '08030900690', 'Mobile', 'UK', '44'
UNION ALL SELECT '08041900713', 'Mobile', 'UK', '44'
UNION ALL SELECT '08052900736', 'Mobile', 'UK', '44'
UNION ALL SELECT '08063900759', 'Mobile', 'UK', '44'
UNION ALL SELECT '08074900782', 'Mobile', 'UK', '44'
UNION ALL SELECT '08085900805', 'Mobile', 'UK', '44'
UNION ALL SELECT '08096900828', 'Mobile', 'UK', '44'
UNION ALL SELECT '08107900851', 'Mobile', 'UK', '44'
UNION ALL SELECT '08118900874', 'Mobile', 'UK', '44'
UNION ALL SELECT '08129900897', 'Mobile', 'UK', '44'
UNION ALL SELECT '08140900920', 'Mobile', 'UK', '44'
UNION ALL SELECT '08151900943', 'Mobile', 'UK', '44'
UNION ALL SELECT '08162900966', 'Mobile', 'UK', '44'
UNION ALL SELECT '08173900989', 'Mobile', 'UK', '44'
UNION ALL SELECT '08184901012', 'Mobile', 'UK', '44'
UNION ALL SELECT '08195901035', 'Mobile', 'UK', '44'
UNION ALL SELECT '08206901058', 'Mobile', 'UK', '44'
UNION ALL SELECT '08217901081', 'Mobile', 'UK', '44'
UNION ALL SELECT '08228901104', 'Mobile', 'UK', '44'
UNION ALL SELECT '08239901127', 'Mobile', 'UK', '44'
UNION ALL SELECT '08250901150', 'Mobile', 'UK', '44'
UNION ALL SELECT '08261901173', 'Mobile', 'UK', '44'
UNION ALL SELECT '08272901196', 'Mobile', 'UK', '44'
UNION ALL SELECT '08283901219', 'Mobile', 'UK', '44'
UNION ALL SELECT '08294901242', 'Mobile', 'UK', '44'
UNION ALL SELECT '08305901265', 'Mobile', 'UK', '44'
UNION ALL SELECT '08316901288', 'Mobile', 'UK', '44'
UNION ALL SELECT '08327901311', 'Mobile', 'UK', '44'
UNION ALL SELECT '08338901334', 'Mobile', 'UK', '44'
UNION ALL SELECT '08349901357', 'Mobile', 'UK', '44'
UNION ALL SELECT '08360901380', 'Mobile', 'UK', '44'
UNION ALL SELECT '08371901403', 'Mobile', 'UK', '44'
UNION ALL SELECT '08382901426', 'Mobile', 'UK', '44'
UNION ALL SELECT '08393901449', 'Mobile', 'UK', '44'
UNION ALL SELECT '08404901472', 'Mobile', 'UK', '44'
UNION ALL SELECT '08415901495', 'Mobile', 'UK', '44'
UNION ALL SELECT '08426901518', 'Mobile', 'UK', '44'
UNION ALL SELECT '08437901541', 'Mobile', 'UK', '44'
UNION ALL SELECT '08448901564', 'Mobile', 'UK', '44'
UNION ALL SELECT '08459901587', 'Mobile', 'UK', '44'
UNION ALL SELECT '08470901610', 'Mobile', 'UK', '44'
UNION ALL SELECT '08481901633', 'Mobile', 'UK', '44'
UNION ALL SELECT '08492901656', 'Mobile', 'UK', '44'
UNION ALL SELECT '08503901679', 'Mobile', 'UK', '44'
UNION ALL SELECT '08514901702', 'Mobile', 'UK', '44'
UNION ALL SELECT '08525901725', 'Mobile', 'UK', '44'
UNION ALL SELECT '08536901748', 'Mobile', 'UK', '44'
UNION ALL SELECT '08547901771', 'Mobile', 'UK', '44'
UNION ALL SELECT '08558901794', 'Mobile', 'UK', '44'
UNION ALL SELECT '08569901817', 'Mobile', 'UK', '44'
UNION ALL SELECT '08580901840', 'Mobile', 'UK', '44'
UNION ALL SELECT '08591901863', 'Mobile', 'UK', '44'
UNION ALL SELECT '08602901886', 'Mobile', 'UK', '44'
UNION ALL SELECT '08613901909', 'Mobile', 'UK', '44'
UNION ALL SELECT '08624901932', 'Mobile', 'UK', '44'
UNION ALL SELECT '08635901955', 'Mobile', 'UK', '44'
UNION ALL SELECT '08646901978', 'Mobile', 'UK', '44'
UNION ALL SELECT '08657902001', 'Mobile', 'UK', '44'
UNION ALL SELECT '08668902024', 'Mobile', 'UK', '44'
UNION ALL SELECT '08679902047', 'Mobile', 'UK', '44'
UNION ALL SELECT '08690902070', 'Mobile', 'UK', '44'
UNION ALL SELECT '08701902093', 'Mobile', 'UK', '44'
UNION ALL SELECT '08712902116', 'Mobile', 'UK', '44'
UNION ALL SELECT '08723902139', 'Mobile', 'UK', '44'
UNION ALL SELECT '08734902162', 'Mobile', 'UK', '44'
UNION ALL SELECT '08745902185', 'Mobile', 'UK', '44'
UNION ALL SELECT '08756902208', 'Mobile', 'UK', '44'
UNION ALL SELECT '08767902231', 'Mobile', 'UK', '44'
UNION ALL SELECT '08778902254', 'Mobile', 'UK', '44'
UNION ALL SELECT '08789902277', 'Mobile', 'UK', '44'
UNION ALL SELECT '08800902300', 'Mobile', 'UK', '44'
UNION ALL SELECT '08811902323', 'Mobile', 'UK', '44'
UNION ALL SELECT '08822902346', 'Mobile', 'UK', '44'
UNION ALL SELECT '08833902369', 'Mobile', 'UK', '44'
UNION ALL SELECT '08844902392', 'Mobile', 'UK', '44'
UNION ALL SELECT '08855902415', 'Mobile', 'UK', '44'
UNION ALL SELECT '08866902438', 'Mobile', 'UK', '44'
UNION ALL SELECT '08877902461', 'Mobile', 'UK', '44'
UNION ALL SELECT '08888902484', 'Mobile', 'UK', '44'
UNION ALL SELECT '08899902507', 'Mobile', 'UK', '44'
UNION ALL SELECT '08910902530', 'Mobile', 'UK', '44'
UNION ALL SELECT '08921902553', 'Mobile', 'UK', '44'
UNION ALL SELECT '08932902576', 'Mobile', 'UK', '44'
UNION ALL SELECT '08943902599', 'Mobile', 'UK', '44'
UNION ALL SELECT '08954902622', 'Mobile', 'UK', '44'
UNION ALL SELECT '08965902645', 'Mobile', 'UK', '44'
UNION ALL SELECT '08976902668', 'Mobile', 'UK', '44'
UNION ALL SELECT '08987902691', 'Mobile', 'UK', '44'
UNION ALL SELECT '08998902714', 'Mobile', 'UK', '44'
UNION ALL SELECT '09009902737', 'Mobile', 'UK', '44'
UNION ALL SELECT '09020902760', 'Mobile', 'UK', '44'
UNION ALL SELECT '09031902783', 'Mobile', 'UK', '44'
UNION ALL SELECT '09042902806', 'Mobile', 'UK', '44'
UNION ALL SELECT '09053902829', 'Mobile', 'UK', '44'
UNION ALL SELECT '09064902852', 'Mobile', 'UK', '44'
UNION ALL SELECT '09075902875', 'Mobile', 'UK', '44'
UNION ALL SELECT '09086902898', 'Mobile', 'UK', '44'
UNION ALL SELECT '09097902921', 'Mobile', 'UK', '44'
UNION ALL SELECT '09108902944', 'Mobile', 'UK', '44'
UNION ALL SELECT '09119902967', 'Mobile', 'UK', '44'
UNION ALL SELECT '09130902990', 'Mobile', 'UK', '44'
UNION ALL SELECT '09141903013', 'Mobile', 'UK', '44'
UNION ALL SELECT '09152903036', 'Mobile', 'UK', '44'
UNION ALL SELECT '09163903059', 'Mobile', 'UK', '44'
UNION ALL SELECT '09174903082', 'Mobile', 'UK', '44'
UNION ALL SELECT '09185903105', 'Mobile', 'UK', '44'
UNION ALL SELECT '09196903128', 'Mobile', 'UK', '44'
UNION ALL SELECT '09207903151', 'Mobile', 'UK', '44'
UNION ALL SELECT '09218903174', 'Mobile', 'UK', '44'
UNION ALL SELECT '09229903197', 'Mobile', 'UK', '44'
UNION ALL SELECT '09240903220', 'Mobile', 'UK', '44'
UNION ALL SELECT '09251903243', 'Mobile', 'UK', '44'
UNION ALL SELECT '09262903266', 'Mobile', 'UK', '44'
UNION ALL SELECT '09273903289', 'Mobile', 'UK', '44'
UNION ALL SELECT '09284903312', 'Mobile', 'UK', '44'
UNION ALL SELECT '09295903335', 'Mobile', 'UK', '44'
UNION ALL SELECT '09306903358', 'Mobile', 'UK', '44'
UNION ALL SELECT '09317903381', 'Mobile', 'UK', '44'
UNION ALL SELECT '09328903404', 'Mobile', 'UK', '44'
UNION ALL SELECT '09339903427', 'Mobile', 'UK', '44'
UNION ALL SELECT '09350903450', 'Mobile', 'UK', '44'
UNION ALL SELECT '09361903473', 'Mobile', 'UK', '44'
UNION ALL SELECT '09372903496', 'Mobile', 'UK', '44'
UNION ALL SELECT '09383903519', 'Mobile', 'UK', '44'
UNION ALL SELECT '09394903542', 'Mobile', 'UK', '44'
UNION ALL SELECT '09405903565', 'Mobile', 'UK', '44'
UNION ALL SELECT '09416903588', 'Mobile', 'UK', '44'
UNION ALL SELECT '09427903611', 'Mobile', 'UK', '44'
UNION ALL SELECT '09438903634', 'Mobile', 'UK', '44'
UNION ALL SELECT '09449903657', 'Mobile', 'UK', '44'
UNION ALL SELECT '09460903680', 'Mobile', 'UK', '44'
UNION ALL SELECT '09471903703', 'Mobile', 'UK', '44'
UNION ALL SELECT '09482903726', 'Mobile', 'UK', '44'
UNION ALL SELECT '09493903749', 'Mobile', 'UK', '44'
UNION ALL SELECT '09504903772', 'Mobile', 'UK', '44'
UNION ALL SELECT '09515903795', 'Mobile', 'UK', '44'
UNION ALL SELECT '09526903818', 'Mobile', 'UK', '44'
UNION ALL SELECT '09537903841', 'Mobile', 'UK', '44'
UNION ALL SELECT '09548903864', 'Mobile', 'UK', '44'
UNION ALL SELECT '09559903887', 'Mobile', 'UK', '44'
UNION ALL SELECT '09570903910', 'Mobile', 'UK', '44'
UNION ALL SELECT '09581903933', 'Mobile', 'UK', '44'
UNION ALL SELECT '09592903956', 'Mobile', 'UK', '44'
UNION ALL SELECT '09603903979', 'Mobile', 'UK', '44'
UNION ALL SELECT '09614904002', 'Mobile', 'UK', '44'
UNION ALL SELECT '09625904025', 'Mobile', 'UK', '44'
UNION ALL SELECT '09636904048', 'Mobile', 'UK', '44'
UNION ALL SELECT '09647904071', 'Mobile', 'UK', '44'
UNION ALL SELECT '09658904094', 'Mobile', 'UK', '44'
UNION ALL SELECT '09669904117', 'Mobile', 'UK', '44'
UNION ALL SELECT '09680904140', 'Mobile', 'UK', '44'
UNION ALL SELECT '09691904163', 'Mobile', 'UK', '44'
UNION ALL SELECT '09702904186', 'Mobile', 'UK', '44'
UNION ALL SELECT '09713904209', 'Mobile', 'UK', '44'
UNION ALL SELECT '09724904232', 'Mobile', 'UK', '44'
UNION ALL SELECT '09735904255', 'Mobile', 'UK', '44'
UNION ALL SELECT '09746904278', 'Mobile', 'UK', '44'
UNION ALL SELECT '09757904301', 'Mobile', 'UK', '44'
UNION ALL SELECT '09768904324', 'Mobile', 'UK', '44'
UNION ALL SELECT '09779904347', 'Mobile', 'UK', '44'
UNION ALL SELECT '09790904370', 'Mobile', 'UK', '44'
UNION ALL SELECT '09801904393', 'Mobile', 'UK', '44'
UNION ALL SELECT '09812904416', 'Mobile', 'UK', '44'
UNION ALL SELECT '09823904439', 'Mobile', 'UK', '44'
UNION ALL SELECT '09834904462', 'Mobile', 'UK', '44'
UNION ALL SELECT '09845904485', 'Mobile', 'UK', '44'
UNION ALL SELECT '09856904508', 'Mobile', 'UK', '44'
UNION ALL SELECT '09867904531', 'Mobile', 'UK', '44'
UNION ALL SELECT '09878904554', 'Mobile', 'UK', '44'
UNION ALL SELECT '09889904577', 'Mobile', 'UK', '44'
UNION ALL SELECT '09900904600', 'Mobile', 'UK', '44'
UNION ALL SELECT '09911904623', 'Mobile', 'UK', '44'
UNION ALL SELECT '09922904646', 'Mobile', 'UK', '44'
UNION ALL SELECT '09933904669', 'Mobile', 'UK', '44'
UNION ALL SELECT '09944904692', 'Mobile', 'UK', '44'
UNION ALL SELECT '02079460000', 'London', 'UK', '44'
UNION ALL SELECT '02079460015', 'London', 'UK', '44'
UNION ALL SELECT '02079460030', 'London', 'UK', '44'
UNION ALL SELECT '02079460045', 'London', 'UK', '44'
UNION ALL SELECT '02079460060', 'London', 'UK', '44'
UNION ALL SELECT '02079460075', 'London', 'UK', '44'
UNION ALL SELECT '02079460090', 'London', 'UK', '44'
UNION ALL SELECT '02079460105', 'London', 'UK', '44'
UNION ALL SELECT '02079460120', 'London', 'UK', '44'
UNION ALL SELECT '02079460135', 'London', 'UK', '44'
UNION ALL SELECT '02079460150', 'London', 'UK', '44'
UNION ALL SELECT '02079460165', 'London', 'UK', '44'
UNION ALL SELECT '02079460180', 'London', 'UK', '44'
UNION ALL SELECT '02079460195', 'London', 'UK', '44'
UNION ALL SELECT '02079460210', 'London', 'UK', '44'
UNION ALL SELECT '02079460225', 'London', 'UK', '44'
UNION ALL SELECT '02079460240', 'London', 'UK', '44'
UNION ALL SELECT '02079460255', 'London', 'UK', '44'
UNION ALL SELECT '02079460270', 'London', 'UK', '44'
UNION ALL SELECT '02079460285', 'London', 'UK', '44'
UNION ALL SELECT '02079460300', 'London', 'UK', '44'
UNION ALL SELECT '02079460315', 'London', 'UK', '44'
UNION ALL SELECT '02079460330', 'London', 'UK', '44'
UNION ALL SELECT '02079460345', 'London', 'UK', '44'
UNION ALL SELECT '02079460360', 'London', 'UK', '44'
UNION ALL SELECT '02079460375', 'London', 'UK', '44'
UNION ALL SELECT '02079460390', 'London', 'UK', '44'
UNION ALL SELECT '02079460405', 'London', 'UK', '44'
UNION ALL SELECT '02079460420', 'London', 'UK', '44'
UNION ALL SELECT '02079460435', 'London', 'UK', '44'
UNION ALL SELECT '02079460450', 'London', 'UK', '44'
UNION ALL SELECT '02079460465', 'London', 'UK', '44'
UNION ALL SELECT '02079460480', 'London', 'UK', '44'
UNION ALL SELECT '02079460495', 'London', 'UK', '44'
UNION ALL SELECT '02079460510', 'London', 'UK', '44'
UNION ALL SELECT '02079460525', 'London', 'UK', '44'
UNION ALL SELECT '02079460540', 'London', 'UK', '44'
UNION ALL SELECT '02079460555', 'London', 'UK', '44'
UNION ALL SELECT '02079460570', 'London', 'UK', '44'
UNION ALL SELECT '02079460585', 'London', 'UK', '44'
UNION ALL SELECT '02079460600', 'London', 'UK', '44'
UNION ALL SELECT '02079460615', 'London', 'UK', '44'
UNION ALL SELECT '02079460630', 'London', 'UK', '44'
UNION ALL SELECT '02079460645', 'London', 'UK', '44'
UNION ALL SELECT '02079460660', 'London', 'UK', '44'
UNION ALL SELECT '02079460675', 'London', 'UK', '44'
UNION ALL SELECT '02079460690', 'London', 'UK', '44'
UNION ALL SELECT '02079460705', 'London', 'UK', '44'
UNION ALL SELECT '02079460720', 'London', 'UK', '44'
UNION ALL SELECT '02079460735', 'London', 'UK', '44'
UNION ALL SELECT '02079460750', 'London', 'UK', '44'
UNION ALL SELECT '02079460765', 'London', 'UK', '44'
UNION ALL SELECT '02079460780', 'London', 'UK', '44'
UNION ALL SELECT '02079460795', 'London', 'UK', '44'
UNION ALL SELECT '02079460810', 'London', 'UK', '44'
UNION ALL SELECT '02079460825', 'London', 'UK', '44'
UNION ALL SELECT '02079460840', 'London', 'UK', '44'
UNION ALL SELECT '02079460855', 'London', 'UK', '44'
UNION ALL SELECT '02079460870', 'London', 'UK', '44'
UNION ALL SELECT '02079460885', 'London', 'UK', '44'
UNION ALL SELECT '02079460900', 'London', 'UK', '44'
UNION ALL SELECT '02079460915', 'London', 'UK', '44'
UNION ALL SELECT '02079460930', 'London', 'UK', '44'
UNION ALL SELECT '02079460945', 'London', 'UK', '44'
UNION ALL SELECT '02079460960', 'London', 'UK', '44'
UNION ALL SELECT '013179460975', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179460990', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461005', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461020', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461035', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461050', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461065', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461080', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461095', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461110', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461125', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461140', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461155', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461170', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461185', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461200', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461215', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461230', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461245', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461260', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461275', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461290', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461305', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461320', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461335', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461350', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461365', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461380', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461395', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461410', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461425', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461440', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461455', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461470', 'Edinburgh', 'UK', '44'
UNION ALL SELECT '013179461485', 'Edinburgh', 'UK', '44'
                  GO

select
    dbo.ds_fnRandomPhoneNumber() as [PhoneNumber]
    ,dbo.ds_fnRandomPhoneNumbers(10) as [Sentence]
    ,dbo.ds_fnRandomPhoneNumber() + dbo.ds_fnRandomPhoneNumber() +'@' + dbo.ds_fnRandomPhoneNumber() +'.nothing' as [Email Address]
from master..sysobjects

GO

