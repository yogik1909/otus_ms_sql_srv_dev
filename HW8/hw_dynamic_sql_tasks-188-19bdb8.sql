/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "07 - Динамический SQL".

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

Это задание из занятия "Операторы CROSS APPLY, PIVOT, UNPIVOT."
Нужно для него написать динамический PIVOT, отображающий результаты по всем клиентам.
Имя клиента указывать полностью из поля CustomerName.

Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+----------------+----------------------
InvoiceMonth | Aakriti Byrraju    | Abel Spirlea       | Abel Tatarescu | ... (другие клиенты)
-------------+--------------------+--------------------+----------------+----------------------
01.01.2013   |      3             |        1           |      4         | ...
01.02.2013   |      7             |        3           |      4         | ...
-------------+--------------------+--------------------+----------------+----------------------
*/
DECLARE @rngCustIdOf INT, @rngCustIdTo INT, @query NVARCHAR(4000)
DECLARE @CustName AS NVARCHAR(MAX)
DROP TABLE IF EXISTS ##SourceTable
SET @rngCustIdOf = 2;
SET @rngCustIdTo = 8;
Set @query =N'Select 
	Invoices.InvoiceDate,
	FORMAT( Invoices.InvoiceDate, ''dd.MM.yyyy'') InvoiceMonth
	,SUBSTRING(Customers.CustomerName, CHARINDEX(''('', Customers.CustomerName)+1, CHARINDEX('')'', Customers.CustomerName) - CHARINDEX(''('', Customers.CustomerName) - 1) CustomerName
	,Invoices.InvoiceID
INTO ##SourceTable
From 
Sales.Invoices
left join Sales.Customers
On Invoices.CustomerID = Customers.CustomerID
Where 
Invoices.CustomerID between @rngCustIdOf and @rngCustIdTo;'
EXEC sp_executesql @query, N'@rngCustIdOf INT, @rngCustIdTo INT', @rngCustIdOf = @rngCustIdOf, @rngCustIdTo = @rngCustIdTo; 

-- Select * From ##SourceTable

SELECT @CustName = STRING_AGG(CustomerName, ', ')  
FROM 
	(
	Select DISTINCT QUOTENAME(CustomerName) CustomerName
	FROM ##SourceTable
	) CustomerNameTable
--Select @CustName

SET @query = N'SELECT InvoiceMonth,   
  ' + @CustName + '  
FROM  
##SourceTable AS SourceTable  
PIVOT  
(  
  COUNT(InvoiceID)  
  FOR CustomerName IN (' + @CustName + ')  
) AS PivotTable
Order by PivotTable.InvoiceDate;
DROP TABLE IF EXISTS ##SourceTable'

EXEC sp_executesql @query