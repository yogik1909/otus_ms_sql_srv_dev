/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "10 - Операторы изменения данных".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Довставлять в базу пять записей используя insert в таблицу Customers или Suppliers 
*/
select *  from Sales.Customers 
Where DeliveryPostalCode = N'690069'

INSERT INTO Sales.Customers (
	CustomerName
	,DeliveryPostalCode
	,[BillToCustomerID]
	,CustomerCategoryID
	,PrimaryContactPersonID
	,DeliveryMethodID
	,DeliveryCityID
	,PostalCityID
	,AccountOpenedDate
	,StandardDiscountPercentage
	,IsStatementSent
	,[IsOnCreditHold]
	,[PaymentDays]
    ,[PhoneNumber]
    ,[FaxNumber]
    ,[DeliveryRun]
    ,[RunPosition]
    ,[WebsiteURL]
    ,[DeliveryAddressLine1]
    ,[DeliveryAddressLine2]
    ,[DeliveryLocation]
    ,[PostalAddressLine1]
    ,[PostalAddressLine2]
    ,[PostalPostalCode]
    ,[LastEditedBy]
)
VALUES (N'MyFirstCustomer'  --CustomerName
		,N'690069'  --DeliveryPostalCode
		,1  --[BillToCustomerID]
		,(Select top 1 CustomerCategoryID from Sales.CustomerCategories)  -- CustomerCategoryID
		,(Select top 1 PersonID from Application.People) --PrimaryContactPersonID
		,(Select top 1 DeliveryMethodID From Application.DeliveryMethods) --DeliveryMethodID
		,(Select top 1 CityID from  Application.Cities) --DeliveryCityID
		,(Select top 1 CityID from  Application.Cities) --PostalCityID
		, GetDate(),0.0,0,0,0,'','','','','','','',NULL,'','','',1)
		,(N'MySecondCustomer'  --CustomerName
		,N'690069'  --DeliveryPostalCode
		,1  --[BillToCustomerID]
		,(Select top 1 CustomerCategoryID from Sales.CustomerCategories)  -- CustomerCategoryID
		,(Select top 1 PersonID from Application.People) --PrimaryContactPersonID
		,(Select top 1 DeliveryMethodID From Application.DeliveryMethods) --DeliveryMethodID
		,(Select top 1 CityID from  Application.Cities) --DeliveryCityID
		,(Select top 1 CityID from  Application.Cities) --PostalCityID
		, GetDate(),0.0,0,0,0,'','','','','','','',NULL,'','','',1)
		,(N'MyThirdCustomer'  --CustomerName
		,N'690069'  --DeliveryPostalCode
		,1  --[BillToCustomerID]
		,(Select top 1 CustomerCategoryID from Sales.CustomerCategories)  -- CustomerCategoryID
		,(Select top 1 PersonID from Application.People) --PrimaryContactPersonID
		,(Select top 1 DeliveryMethodID From Application.DeliveryMethods) --DeliveryMethodID
		,(Select top 1 CityID from  Application.Cities) --DeliveryCityID
		,(Select top 1 CityID from  Application.Cities) --PostalCityID
		, GetDate(),0.0,0,0,0,'','','','','','','',NULL,'','','',1)
		,(N'MyFourthCustomer'  --CustomerName
		,N'690069'  --DeliveryPostalCode
		,1  --[BillToCustomerID]
		,(Select top 1 CustomerCategoryID from Sales.CustomerCategories)  -- CustomerCategoryID
		,(Select top 1 PersonID from Application.People) --PrimaryContactPersonID
		,(Select top 1 DeliveryMethodID From Application.DeliveryMethods) --DeliveryMethodID
		,(Select top 1 CityID from  Application.Cities) --DeliveryCityID
		,(Select top 1 CityID from  Application.Cities) --PostalCityID
		, GetDate(),0.0,0,0,0,'','','','','','','',NULL,'','','',1)
		,(N'MyFifthCustomer'  --CustomerName
		,N'690069'  --DeliveryPostalCode
		,1  --[BillToCustomerID]
		,(Select top 1 CustomerCategoryID from Sales.CustomerCategories)  -- CustomerCategoryID
		,(Select top 1 PersonID from Application.People) --PrimaryContactPersonID
		,(Select top 1 DeliveryMethodID From Application.DeliveryMethods) --DeliveryMethodID
		,(Select top 1 CityID from  Application.Cities) --DeliveryCityID
		,(Select top 1 CityID from  Application.Cities) --PostalCityID
		, GetDate(),0.0,0,0,0,'','','','','','','',NULL,'','','',1)

INSERT INTO [Purchasing].[Suppliers] (
	[SupplierName]
           ,[SupplierCategoryID]
           ,[PrimaryContactPersonID]
           ,[AlternateContactPersonID]
           ,[DeliveryMethodID]
           ,[DeliveryCityID]
           ,[PostalCityID]
           ,[PaymentDays]
           ,[PhoneNumber]
           ,[FaxNumber]
           ,[WebsiteURL]
           ,[DeliveryAddressLine1]
           ,[DeliveryPostalCode]
           ,[PostalAddressLine1]
           ,[PostalPostalCode]
           ,[LastEditedBy])

VALUES (N'MyFirstSupplier' --,<SupplierName, nvarchar(100),>
		, (Select top 1 SupplierCategoryID From Purchasing.SupplierCategories) --,<SupplierCategoryID, int,>
        , (Select top 1 PersonID from Application.People) --  ,<PrimaryContactPersonID, int,>  
        , (Select top 1 PersonID from Application.People) --,<AlternateContactPersonID, int,>
        , (Select top 1 DeliveryMethodID From Application.DeliveryMethods) --,<DeliveryMethodID, int,>
		,(Select top 1 CityID from  Application.Cities) --,<DeliveryCityID, int,>
		,(Select top 1 CityID from  Application.Cities) --,<PostalCityID, int,> 
		,'' --<PaymentDays, int,>
        ,'' --,<PhoneNumber, nvarchar(20),>
        ,'' --,<FaxNumber, nvarchar(20),>
        ,'' --<WebsiteURL, nvarchar(256),>
        ,'' --,<DeliveryAddressLine1, nvarchar(60),>
        ,N'690069' --<DeliveryPostalCode, nvarchar(10),>
        ,'' --<PostalAddressLine1, nvarchar(60),>
        ,'' --<PostalPostalCode, nvarchar(10),>
        ,(Select top 1 PersonID from Application.People) --<LastEditedBy, int,>
		) 
		,(N'MySecondSupplier' --,<SupplierName, nvarchar(100),>
		, (Select top 1 SupplierCategoryID From Purchasing.SupplierCategories) --,<SupplierCategoryID, int,>
        , (Select top 1 PersonID from Application.People) --  ,<PrimaryContactPersonID, int,>  
        , (Select top 1 PersonID from Application.People) --,<AlternateContactPersonID, int,>
        , (Select top 1 DeliveryMethodID From Application.DeliveryMethods) --,<DeliveryMethodID, int,>
		,(Select top 1 CityID from  Application.Cities) --,<DeliveryCityID, int,>
		,(Select top 1 CityID from  Application.Cities) --,<PostalCityID, int,> 
		,'' --<PaymentDays, int,>
        ,'' --,<PhoneNumber, nvarchar(20),>
        ,'' --,<FaxNumber, nvarchar(20),>
        ,'' --<WebsiteURL, nvarchar(256),>
        ,'' --,<DeliveryAddressLine1, nvarchar(60),>
        ,N'690069' --<DeliveryPostalCode, nvarchar(10),>
        ,'' --<PostalAddressLine1, nvarchar(60),>
        ,'' --<PostalPostalCode, nvarchar(10),>
        ,(Select top 1 PersonID from Application.People) --<LastEditedBy, int,>
		)
		,(N'MyThirdSupplier' --,<SupplierName, nvarchar(100),>
		, (Select top 1 SupplierCategoryID From Purchasing.SupplierCategories) --,<SupplierCategoryID, int,>
        , (Select top 1 PersonID from Application.People) --  ,<PrimaryContactPersonID, int,>  
        , (Select top 1 PersonID from Application.People) --,<AlternateContactPersonID, int,>
        , (Select top 1 DeliveryMethodID From Application.DeliveryMethods) --,<DeliveryMethodID, int,>
		,(Select top 1 CityID from  Application.Cities) --,<DeliveryCityID, int,>
		,(Select top 1 CityID from  Application.Cities) --,<PostalCityID, int,> 
		,'' --<PaymentDays, int,>
        ,'' --,<PhoneNumber, nvarchar(20),>
        ,'' --,<FaxNumber, nvarchar(20),>
        ,'' --<WebsiteURL, nvarchar(256),>
        ,'' --,<DeliveryAddressLine1, nvarchar(60),>
        ,N'690069' --<DeliveryPostalCode, nvarchar(10),>
        ,'' --<PostalAddressLine1, nvarchar(60),>
        ,'' --<PostalPostalCode, nvarchar(10),>
        ,(Select top 1 PersonID from Application.People) --<LastEditedBy, int,>
		)
		,(N'MyFourthSupplier' --,<SupplierName, nvarchar(100),>
		, (Select top 1 SupplierCategoryID From Purchasing.SupplierCategories) --,<SupplierCategoryID, int,>
        , (Select top 1 PersonID from Application.People) --  ,<PrimaryContactPersonID, int,>  
        , (Select top 1 PersonID from Application.People) --,<AlternateContactPersonID, int,>
        , (Select top 1 DeliveryMethodID From Application.DeliveryMethods) --,<DeliveryMethodID, int,>
		,(Select top 1 CityID from  Application.Cities) --,<DeliveryCityID, int,>
		,(Select top 1 CityID from  Application.Cities) --,<PostalCityID, int,> 
		,'' --<PaymentDays, int,>
        ,'' --,<PhoneNumber, nvarchar(20),>
        ,'' --,<FaxNumber, nvarchar(20),>
        ,'' --<WebsiteURL, nvarchar(256),>
        ,'' --,<DeliveryAddressLine1, nvarchar(60),>
        ,N'690069' --<DeliveryPostalCode, nvarchar(10),>
        ,'' --<PostalAddressLine1, nvarchar(60),>
        ,'' --<PostalPostalCode, nvarchar(10),>
        ,(Select top 1 PersonID from Application.People) --<LastEditedBy, int,>
		)
		,(N'MyFifthSupplier' --,<SupplierName, nvarchar(100),>
		, (Select top 1 SupplierCategoryID From Purchasing.SupplierCategories) --,<SupplierCategoryID, int,>
        , (Select top 1 PersonID from Application.People) --  ,<PrimaryContactPersonID, int,>  
        , (Select top 1 PersonID from Application.People) --,<AlternateContactPersonID, int,>
        , (Select top 1 DeliveryMethodID From Application.DeliveryMethods) --,<DeliveryMethodID, int,>
		,(Select top 1 CityID from  Application.Cities) --,<DeliveryCityID, int,>
		,(Select top 1 CityID from  Application.Cities) --,<PostalCityID, int,> 
		,'' --<PaymentDays, int,>
        ,'' --,<PhoneNumber, nvarchar(20),>
        ,'' --,<FaxNumber, nvarchar(20),>
        ,'' --<WebsiteURL, nvarchar(256),>
        ,'' --,<DeliveryAddressLine1, nvarchar(60),>
        ,N'690069' --<DeliveryPostalCode, nvarchar(10),>
        ,'' --<PostalAddressLine1, nvarchar(60),>
        ,'' --<PostalPostalCode, nvarchar(10),>
        ,(Select top 1 PersonID from Application.People) --<LastEditedBy, int,>
		)
		
/*
2. Удалите одну запись из Customers, которая была вами добавлена
*/

Delete top (1)  from Sales.Customers 
Where DeliveryPostalCode = N'690069'


/*
3. Изменить одну запись, из добавленных через UPDATE
*/

;WITH CTE_SeceltRow AS
(Select top (1) * from Sales.Customers 
Where DeliveryPostalCode = N'690069')

UPDATE CTE_SeceltRow
SET DeliveryPostalCode = N'690066'
/*
4. Написать MERGE, который вставит вставит запись в клиенты, если ее там нет, и изменит если она уже есть
*/
;with CTE_SelectValues AS (
Select 
	CustomerName
	,DeliveryPostalCode
	,[BillToCustomerID]
	,CustomerCategoryID
	,PrimaryContactPersonID
	,DeliveryMethodID
	,DeliveryCityID
	,PostalCityID
	,AccountOpenedDate
	,StandardDiscountPercentage
	,IsStatementSent
	,[IsOnCreditHold]
	,[PaymentDays]
    ,[PhoneNumber]
    ,[FaxNumber]
    ,[DeliveryRun]
    ,[RunPosition]
    ,[WebsiteURL]
    ,[DeliveryAddressLine1]
    ,[DeliveryAddressLine2]
    ,[DeliveryLocation]
    ,[PostalAddressLine1]
    ,[PostalAddressLine2]
    ,[PostalPostalCode]
    ,[LastEditedBy]
From (
VALUES (N'MyFirstCustomer'  --CustomerName
		,N'690069'  --DeliveryPostalCode
		,1  --[BillToCustomerID]
		,(Select top 1 CustomerCategoryID from Sales.CustomerCategories)  -- CustomerCategoryID
		,(Select top 1 PersonID from Application.People) --PrimaryContactPersonID
		,(Select top 1 DeliveryMethodID From Application.DeliveryMethods) --DeliveryMethodID
		,(Select top 1 CityID from  Application.Cities) --DeliveryCityID
		,(Select top 1 CityID from  Application.Cities) --PostalCityID
		, GetDate(),0.0,0,0,0,'','','','','','','',NULL,'','','',1)
		,(N'MySecondCustomer'  --CustomerName
		,N'690069'  --DeliveryPostalCode
		,1  --[BillToCustomerID]
		,(Select top 1 CustomerCategoryID from Sales.CustomerCategories)  -- CustomerCategoryID
		,(Select top 1 PersonID from Application.People) --PrimaryContactPersonID
		,(Select top 1 DeliveryMethodID From Application.DeliveryMethods) --DeliveryMethodID
		,(Select top 1 CityID from  Application.Cities) --DeliveryCityID
		,(Select top 1 CityID from  Application.Cities) --PostalCityID
		, GetDate(),0.0,0,0,0,'','','','','','','',NULL,'','','',1)
		,(N'MyThirdCustomer'  --CustomerName
		,N'690069'  --DeliveryPostalCode
		,1  --[BillToCustomerID]
		,(Select top 1 CustomerCategoryID from Sales.CustomerCategories)  -- CustomerCategoryID
		,(Select top 1 PersonID from Application.People) --PrimaryContactPersonID
		,(Select top 1 DeliveryMethodID From Application.DeliveryMethods) --DeliveryMethodID
		,(Select top 1 CityID from  Application.Cities) --DeliveryCityID
		,(Select top 1 CityID from  Application.Cities) --PostalCityID
		, GetDate(),0.0,0,0,0,'','','','','','','',NULL,'','','',1)
		,(N'MyFourthCustomer'  --CustomerName
		,N'690069'  --DeliveryPostalCode
		,1  --[BillToCustomerID]
		,(Select top 1 CustomerCategoryID from Sales.CustomerCategories)  -- CustomerCategoryID
		,(Select top 1 PersonID from Application.People) --PrimaryContactPersonID
		,(Select top 1 DeliveryMethodID From Application.DeliveryMethods) --DeliveryMethodID
		,(Select top 1 CityID from  Application.Cities) --DeliveryCityID
		,(Select top 1 CityID from  Application.Cities) --PostalCityID
		, GetDate(),0.0,0,0,0,'','','','','','','',NULL,'','','',1)
		,(N'MyFifthCustomer'  --CustomerName
		,N'690069'  --DeliveryPostalCode
		,1  --[BillToCustomerID]
		,(Select top 1 CustomerCategoryID from Sales.CustomerCategories)  -- CustomerCategoryID
		,(Select top 1 PersonID from Application.People) --PrimaryContactPersonID
		,(Select top 1 DeliveryMethodID From Application.DeliveryMethods) --DeliveryMethodID
		,(Select top 1 CityID from  Application.Cities) --DeliveryCityID
		,(Select top 1 CityID from  Application.Cities) --PostalCityID
		, GetDate(),0.0,0,0,0,'','','','','','','',NULL,'','','',1)
) as x(CustomerName
	,DeliveryPostalCode
	,[BillToCustomerID]
	,CustomerCategoryID
	,PrimaryContactPersonID
	,DeliveryMethodID
	,DeliveryCityID
	,PostalCityID
	,AccountOpenedDate
	,StandardDiscountPercentage
	,IsStatementSent
	,[IsOnCreditHold]
	,[PaymentDays]
    ,[PhoneNumber]
    ,[FaxNumber]
    ,[DeliveryRun]
    ,[RunPosition]
    ,[WebsiteURL]
    ,[DeliveryAddressLine1]
    ,[DeliveryAddressLine2]
    ,[DeliveryLocation]
    ,[PostalAddressLine1]
    ,[PostalAddressLine2]
    ,[PostalPostalCode]
    ,[LastEditedBy])
)


--select  s.CustomerName, CTE_SelectValues.Customername from [Sales].[Customers] s Left Join CTE_SelectValues	ON s.CustomerName = s.CustomerName

Merge [Sales].[Customers] t
	Using CTE_SelectValues s
	ON s.CustomerName = t.CustomerName
When Matched
	Then Update 
	Set t.CustomerName	=	s.CustomerName
	,t.DeliveryPostalCode	=	s.DeliveryPostalCode
	,t.[BillToCustomerID]	=	s.[BillToCustomerID]
	,t.CustomerCategoryID	=	s.CustomerCategoryID
	,t.PrimaryContactPersonID	=	s.PrimaryContactPersonID
	,t.DeliveryMethodID	=	s.DeliveryMethodID
	,t.DeliveryCityID	=	s.DeliveryCityID
	,t.PostalCityID	=	s.PostalCityID
	,t.AccountOpenedDate	=	s.AccountOpenedDate
	,t.StandardDiscountPercentage	=	s.StandardDiscountPercentage
	,t.IsStatementSent	=	s.IsStatementSent
	,t.[IsOnCreditHold]	=	s.[IsOnCreditHold]
	,t.[PaymentDays]	=	s.[PaymentDays]
    ,t.[PhoneNumber]	= s.[PhoneNumber]
    ,t.[FaxNumber]	= s.[FaxNumber]
    ,t.[DeliveryRun]	= s.[DeliveryRun]
    ,t.[RunPosition]	= s.[RunPosition]
    ,t.[WebsiteURL]	= s.[WebsiteURL]
    ,t.[DeliveryAddressLine1]	= s.[DeliveryAddressLine1]
    ,t.[DeliveryAddressLine2]	= s.[DeliveryAddressLine2]
    ,t.[DeliveryLocation] = s.[DeliveryLocation]
    ,t.[PostalAddressLine1]	= s.[PostalAddressLine1]
    ,t.[PostalAddressLine2]	= s.[PostalAddressLine2]
    ,t.[PostalPostalCode] = s.[PostalPostalCode]
    ,t.[LastEditedBy] = s.[LastEditedBy]
When NOT Matched THEN
INSERT 
	(CustomerName
	,DeliveryPostalCode
	,[BillToCustomerID]
	,CustomerCategoryID
	,PrimaryContactPersonID
	,DeliveryMethodID
	,DeliveryCityID
	,PostalCityID
	,AccountOpenedDate
	,StandardDiscountPercentage
	,IsStatementSent
	,[IsOnCreditHold]
	,[PaymentDays]
    ,[PhoneNumber]
    ,[FaxNumber]
    ,[DeliveryRun]
    ,[RunPosition]
    ,[WebsiteURL]
    ,[DeliveryAddressLine1]
    ,[DeliveryAddressLine2]
    ,[DeliveryLocation]
    ,[PostalAddressLine1]
    ,[PostalAddressLine2]
    ,[PostalPostalCode]
    ,[LastEditedBy])
	VALUES (s.CustomerName
	,s.DeliveryPostalCode
	,s.[BillToCustomerID]
	,s.CustomerCategoryID
	,s.PrimaryContactPersonID
	,s.DeliveryMethodID
	,s.DeliveryCityID
	,s.PostalCityID
	,s.AccountOpenedDate
	,s.StandardDiscountPercentage
	,s.IsStatementSent
	,s.[IsOnCreditHold]
	,s.[PaymentDays]
    ,s.[PhoneNumber]
    ,s.[FaxNumber]
    ,s.[DeliveryRun]
    ,s.[RunPosition]
    ,s.[WebsiteURL]
    ,s.[DeliveryAddressLine1]
    ,s.[DeliveryAddressLine2]
    ,s.[DeliveryLocation]
    ,s.[PostalAddressLine1]
    ,s.[PostalAddressLine2]
    ,s.[PostalPostalCode]
    ,s.[LastEditedBy]
)
output deleted.*, $action, inserted.*;


/*
5. Напишите запрос, который выгрузит данные через bcp out и загрузить через bulk insert
*/

