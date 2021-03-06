/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "08 - Выборки из XML и JSON полей".

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
Примечания к заданиям 1, 2:
* Если с выгрузкой в файл будут проблемы, то можно сделать просто SELECT c результатом в виде XML. 
* Если у вас в проекте предусмотрен экспорт/импорт в XML, то можете взять свой XML и свои таблицы.
* Если с этим XML вам будет скучно, то можете взять любые открытые данные и импортировать их в таблицы (например, с https://data.gov.ru).
* Пример экспорта/импорта в файл https://docs.microsoft.com/en-us/sql/relational-databases/import-export/examples-of-bulk-import-and-export-of-xml-documents-sql-server
*/


/*
1. В личном кабинете есть файл StockItems.xml.
Это данные из таблицы Warehouse.StockItems.
Преобразовать эти данные в плоскую таблицу с полями, аналогичными Warehouse.StockItems.
Поля: StockItemName, SupplierID, UnitPackageID, OuterPackageID, QuantityPerOuter, TypicalWeightPerUnit, LeadTimeDays, IsChillerStock, TaxRate, UnitPrice 

Загрузить эти данные в таблицу Warehouse.StockItems: 
существующие записи в таблице обновить, отсутствующие добавить (сопоставлять записи по полю StockItemName). 
*/

DECLARE @xmlDocument  xml

SELECT @xmlDocument = BulkColumn
FROM OPENROWSET
(BULK '/storage/public/StockItems-188-1fb5df.xml', 
 SINGLE_CLOB)
as data 

DECLARE @docHandle int
EXEC sp_xml_preparedocument @docHandle OUTPUT, @xmlDocument

DROP table IF EXISTS #tt115973246__ 

SELECT *
INTO #tt115973246__
FROM OPENXML(@docHandle, N'/StockItems/Item')
WITH ( 
	[StockItemName] nvarchar(100)  '@Name',
	[SupplierID] int 'SupplierID',
	[UnitPackageID] int 'Package/UnitPackageID',
	[OuterPackageID] int 'Package/OuterPackageID',
	[QuantityPerOuter] int 'Package/QuantityPerOuter',
	[TypicalWeightPerUnit] decimal(18,3) 'Package/TypicalWeightPerUnit',
	[LeadTimeDays] int 'LeadTimeDays',
	[IsChillerStock] bit 'IsChillerStock',
	[TaxRate] decimal(18, 3) 'TaxRate',
	[UnitPrice] decimal(19,3) 'UnitPrice')

Select * From #tt115973246__ as s
	full join [Warehouse].[StockItems] as t
	ON s.[StockItemName] = t.StockItemName



BEGIN TRANSACTION megreXMLFile

MERGE
	[Warehouse].[StockItems] as t
	using 
	#tt115973246__ as s
	
	ON t.[StockItemName] = s.[StockItemName]
When Matched
	then update 
	SET t.[StockItemName] = s.[StockItemName]
	,t.[SupplierID] = s.[SupplierID]
	,t.[UnitPackageID] = s.[UnitPackageID]
	,t.[OuterPackageID] = s.[OuterPackageID]
	,t.[QuantityPerOuter] = s.[QuantityPerOuter]
	,t.[TypicalWeightPerUnit] = s.[TypicalWeightPerUnit]
	,t.[LeadTimeDays] = s.[LeadTimeDays]
	,t.[IsChillerStock] = s.[IsChillerStock]
	,t.[TaxRate] = s.[TaxRate]
	,t.[UnitPrice] = s.[UnitPrice]
	When not matched
	then insert ([StockItemName]
			,[SupplierID]
           ,[UnitPackageID]
           ,[OuterPackageID]
           ,[QuantityPerOuter]
           ,[IsChillerStock]
           ,[TaxRate]
           ,[UnitPrice]
           ,[TypicalWeightPerUnit]
		   ,[LeadTimeDays],
		   [LastEditedBy])
     VALUES
           (s.[StockItemName]
           ,s.SupplierID
           ,s.UnitPackageID
           ,s.OuterPackageID
           ,s.QuantityPerOuter
           ,s.IsChillerStock
           ,s.TaxRate
           ,s.UnitPrice
           ,s.TypicalWeightPerUnit
		   ,s.LeadTimeDays
		   ,1)


	output $action, inserted.*, deleted.*;

ROLLBACK TRANSACTION megreXMLFile


/*
2. Выгрузить данные из таблицы StockItems в такой же xml-файл, как StockItems.xml
Сделать два варианта: с помощью OPENXML и через XQuery.
*/

Select 
StockItemName as "@Name"
,SupplierID
,(SELECT UnitPackageID 
,OuterPackageID 
,QuantityPerOuter
,TypicalWeightPerUnit 
From Warehouse.StockItems inq where StockItems.StockItemID = inq.StockItemID FOR XML PATH (''), type) as "Package"

,LeadTimeDays
,IsChillerStock
,TaxRate
,UnitPrice
From Warehouse.StockItems
where StockItemID IN (11, 12)
FOR XML PATH('Item'), TYPE, ROOT ('StockItems')

Select 
StockItemName as "@Name"
,SupplierID 
,UnitPackageID "Package/UnitPackageID"
,OuterPackageID "Package/OuterPackageID"
,QuantityPerOuter "Package/QuantityPerOuter"
,TypicalWeightPerUnit "Package/TypicalWeightPerUnit"
,LeadTimeDays
,IsChillerStock
,TaxRate
,UnitPrice
From Warehouse.StockItems
where StockItemID IN (11, 12)
FOR XML PATH('Item'), TYPE, ROOT ('StockItems')
-- Первый вариант мне нравится больше, так как нужно мешь писать или может можно задать какой то шаблон "Package/*" что бы не дублирвоать имя корневого элемемнта Package

-- Что то не понял, что хначит два варианта с помощью с помощью OPENXML и через XQuery


/*
3. В таблице Warehouse.StockItems в колонке CustomFields есть данные в JSON.
Написать SELECT для вывода:
- StockItemID
- StockItemName
- CountryOfManufacture (из CustomFields)
- FirstTag (из поля CustomFields, первое значение из массива Tags)
*/

Select 
StockItemID
,StockItemName
,CustomFields
, (SELECT * FROM OPENJSON(CustomFields)
        WITH (  CountryOfManufacture VARCHAR(10) '$.CountryOfManufacture')) as CountryOfManufacture
, (SELECT * FROM OPENJSON(CustomFields)
        WITH (  CountryOfManufacture VARCHAR(10) '$.Tags[0]')) as FirstValueTags

From 
	Warehouse.StockItems 



/*
4. Найти в StockItems строки, где есть тэг "Vintage".
Вывести: 
- StockItemID
- StockItemName
- (опционально) все теги (из CustomFields) через запятую в одном поле

Тэги искать в поле CustomFields, а не в Tags.
Запрос написать через функции работы с JSON.
Для поиска использовать равенство, использовать LIKE запрещено.

Должно быть в таком виде:
... where ... = 'Vintage'

Так принято не будет:
... where ... Tags like '%Vintage%'
... where ... CustomFields like '%Vintage%' 
*/

Select StockItemID
,StockItemName
,STRING_AGG ( Tags.Value, ', ') AllTags
From 
	 (Select 
		StockItemID
		,StockItemName
		,CustomFields
		From 
			Warehouse.StockItems 
			CROSS APPLY OPENJSON(CustomFields, '$.Tags') Tags
		Where Tags.Value = 'Vintage') _vq
		CROSS APPLY OPENJSON(CustomFields, '$.Tags') Tags
	Group by StockItemID
			,StockItemName
--Моя реализация задания под звездочкой кажется мне не крутой, думаю должне быть более элегатный способ.
