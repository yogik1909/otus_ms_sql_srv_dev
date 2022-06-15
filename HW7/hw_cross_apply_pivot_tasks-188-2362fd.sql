/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "05 - Операторы CROSS APPLY, PIVOT, UNPIVOT".

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
1. Требуется написать запрос, который в результате своего выполнения 
формирует сводку по количеству покупок в разрезе клиентов и месяцев.
В строках должны быть месяцы (дата начала месяца), в столбцах - клиенты.

Клиентов взять с ID 2-6, это все подразделение Tailspin Toys.
Имя клиента нужно поменять так чтобы осталось только уточнение.
Например, исходное значение "Tailspin Toys (Gasport, NY)" - вы выводите только "Gasport, NY".
Дата должна иметь формат dd.mm.yyyy, например, 25.12.2019.

Пример, как должны выглядеть результаты:
-------------+--------------------+--------------------+-------------+--------------+------------
InvoiceMonth | Peeples Valley, AZ | Medicine Lodge, KS | Gasport, NY | Sylvanite, MT | Jessie, ND
-------------+--------------------+--------------------+-------------+--------------+------------
01.01.2013   |      3             |        1           |      4      |      2        |     2
01.02.2013   |      7             |        3           |      4      |      2        |     1
-------------+--------------------+--------------------+-------------+--------------+------------
*/
SELECT InvoiceMonth,   
  [Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND]  
FROM  
(
  Select 
	Invoices.InvoiceDate,
	FORMAT( Invoices.InvoiceDate, 'dd.MM.yyyy') InvoiceMonth
	,SUBSTRING(Customers.CustomerName, CHARINDEX('(', Customers.CustomerName)+1, CHARINDEX(')', Customers.CustomerName) - CHARINDEX('(', Customers.CustomerName) - 1) CustomerName
	,Invoices.InvoiceID
From 
Sales.Invoices
left join Sales.Customers
On Invoices.CustomerID = Customers.CustomerID
Where 
Invoices.CustomerID between 2 and 6
) AS SourceTable  
PIVOT  
(  
  COUNT(InvoiceID)  
  FOR CustomerName IN ([Sylvanite, MT], [Peeples Valley, AZ], [Medicine Lodge, KS], [Gasport, NY], [Jessie, ND])  
) AS PivotTable
Order by PivotTable.InvoiceDate;

/*
2. Для всех клиентов с именем, в котором есть "Tailspin Toys"
вывести все адреса, которые есть в таблице, в одной колонке.

Пример результата:
----------------------------+--------------------
CustomerName                | AddressLine
----------------------------+--------------------
Tailspin Toys (Head Office) | Shop 38
Tailspin Toys (Head Office) | 1877 Mittal Road
Tailspin Toys (Head Office) | PO Box 8975
Tailspin Toys (Head Office) | Ribeiroville
----------------------------+--------------------
*/

Select
	CustomerName
	,crossTable.AddressLine
From
	[Sales].[Customers]
	OUTER APPLY (Select DeliveryAddressLine1 AddressLine From
	[Sales].[Customers] inCust Where Customers.CustomerID = inCust.CustomerID
	UNION ALL
	Select DeliveryAddressLine2 From
	[Sales].[Customers] inCust Where Customers.CustomerID = inCust.CustomerID) crossTable
Where
	CustomerName	Like '%Tailspin Toys%' 
Order by CustomerID

/*
3. В таблице стран (Application.Countries) есть поля с цифровым кодом страны и с буквенным.
Сделайте выборку ИД страны, названия и ее кода так, 
чтобы в поле с кодом был либо цифровой либо буквенный код.

Пример результата:
--------------------------------
CountryId | CountryName | Code
----------+-------------+-------
1         | Afghanistan | AFG
1         | Afghanistan | 4
3         | Albania     | ALB
3         | Albania     | 8
----------+-------------+-------
*/

Select
	CountryID
	,CountryName
	,outCode.Code
From 
	Application.Countries
	OUTER APPLY (
	Select
	IsoAlpha3Code Code
From 
	Application.Countries inCoun
	Where 
		Countries.CountryID = inCoun.CountryID 
	UNION ALL 
	Select
	Cast(IsoNumericCode as varchar(5)) Code
From 
	Application.Countries inCoun
	Where 
		Countries.CountryID = inCoun.CountryID) outCode
-- Тоже самое, что и в прошлом задании? или я не правильно понял задание?

/*
4. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/

Select 
	CustomerID
	,CustomerName
	,OrderLines.*

From 
	Sales.Customers
	OUTER APPLY (
		Select TOP 2
			MAX(OrderDate) OrderDate 
			,StockItemID
			,UnitPrice
		From
			Sales.Orders
				join Sales.OrderLines
				ON Orders.OrderID = OrderLines.OrderLineID
				Where CustomerID = Customers.CustomerID
		Group BY StockItemID
			,UnitPrice 
		Order BY UnitPrice DESC
				
	) OrderLines
Order BY CustomerID, OrderLines.UnitPrice DESC
