/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "03 - Подзапросы, CTE, временные таблицы".

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
-- Для всех заданий, где возможно, сделайте два варианта запросов:
--  1) через вложенный запрос
--  2) через WITH (для производных таблиц)
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Выберите сотрудников (Application.People), которые являются продажниками (IsSalesPerson), 
и не сделали ни одной продажи 04 июля 2015 года. 
Вывести ИД сотрудника и его полное имя. 
Продажи смотреть в таблице Sales.Invoices.
*/

--TODO: напишите здесь свое решение

--Tape 1
Select 
ppl.PersonID
,ppl.FullName
From 
	Application.People ppl
	Left join (
		Select DISTINCT 
			SalespersonPersonID
		From
			Sales.Invoices
		Where 
			InvoiceDate = N'2015-07-04') LastDaySale
	On
		ppl.PersonID = LastDaySale.SalespersonPersonID
Where 
	ppl.IsSalesperson = 1
	AND LastDaySale.SalespersonPersonID IS NULL

--Tape 2
Select 
ppl.PersonID
,ppl.FullName
From 
	Application.People ppl
Where 
	ppl.IsSalesperson = 1
	AND (Select DISTINCT
		InvoiceDate
	from
		Sales.Invoices
	where ppl.PersonID = Invoices.SalespersonPersonID
	AND InvoiceDate = N'2015-07-04'
	) is Null

--Tape 3
Select 
ppl.PersonID
,ppl.FullName
From 
	Application.People ppl
Where
	ppl.IsSalesperson = 1
	AND NOT Exists (Select DISTINCT
			InvoiceDate
		from
			Sales.Invoices
		where ppl.PersonID = Invoices.SalespersonPersonID
			AND InvoiceDate = N'2015-07-04')


/*
2. Выберите товары с минимальной ценой (подзапросом). Сделайте два варианта подзапроса. 
Вывести: ИД товара, наименование товара, цена.
*/

--TODO: напишите здесь свое решение
--Tape 1
Select 
StockItemID
,StockItemName
,UnitPrice
From
	Warehouse.StockItems
	Join (
		Select
			min(UnitPrice) minUnitPrice
		From 
			Warehouse.StockItems
		) minPrice
		ON StockItems.UnitPrice = minPrice.minUnitPrice
--Tape 2
Select 
StockItemID
,StockItemName
,UnitPrice
From
	Warehouse.StockItems
	Where UnitPrice IN (
		Select
			min(UnitPrice) minUnitPrice
		From 
			Warehouse.StockItems
		)

/*
3. Выберите информацию по клиентам, которые перевели компании пять максимальных платежей 
из Sales.CustomerTransactions. 
Представьте несколько способов (в том числе с CTE). 
*/

--TODO: напишите здесь свое решение

--!!! В задании говорится прот топ пять максимальных плателей, мне кажется для такой постоновки вопроса правильно будт собрать выборку таким запросом
--Select Top 5 
--	CustomerID
--From
--	Sales.CustomerTransactions
--Order By TransactionAmount DESC

--Но тогда она компания 2 раза войдет в этот топ!
-- Думаю что выборка подразумевает имено топ 5 компаний по их максимальным платежам. 

--Tape 1
;WITH topCustomerTrans AS
(Select Top 5 
	CustomerID
From
	Sales.CustomerTransactions
Group By
	CustomerID
Order By Max(TransactionAmount) DESC)

Select * 
From 
	Sales.Customers
Join topCustomerTrans
On Customers.CustomerID = topCustomerTrans.CustomerID

--Tape 2
Select * 
From 
	Sales.Customers
	Where CustomerID IN (
		Select Top 5 
			CustomerID
		From
			Sales.CustomerTransactions
		Group By
			CustomerID
		Order By Max(TransactionAmount) DESC)
/*
4. Выберите города (ид и название), в которые были доставлены товары, 
входящие в тройку самых дорогих товаров, а также имя сотрудника, 
который осуществлял упаковку заказов (PackedByPersonID).
*/

--TODO: напишите здесь свое решение
;WITH StockItemsCTE AS 
(Select Top 3
	StockItemID
	,UnitPrice
From 
	Warehouse.StockItems
Order by UnitPrice DESC)
, InvoceInfoCTE AS
(Select 
	Invoices.PackedByPersonID
	,Orders.CustomerID
From 
Sales.OrderLines
	Join Sales.Orders
		Join Sales.Invoices
		On Orders.OrderID = Invoices.OrderID
	On OrderLines.OrderID = Orders.OrderID
Where 
	OrderLines.StockItemID IN (Select StockItemID From StockItemsCTE)
)

Select distinct
	Cities.CityName
	,People.FullName
From 
	InvoceInfoCTE 
	join Sales.Customers 
	on InvoceInfoCTE.CustomerID = Customers.CustomerID
	join Application.Cities
	on Customers.DeliveryCityID = Cities.CityID
	Join Application.People
	On InvoceInfoCTE.PackedByPersonID = People.PersonID
Order by Cities.CityName



-- ---------------------------------------------------------------------------
-- Опциональное задание
-- ---------------------------------------------------------------------------
-- Можно двигаться как в сторону улучшения читабельности запроса, 
-- так и в сторону упрощения плана\ускорения. 
-- Сравнить производительность запросов можно через SET STATISTICS IO, TIME ON. 
-- Если знакомы с планами запросов, то используйте их (тогда к решению также приложите планы). 
-- Напишите ваши рассуждения по поводу оптимизации. 

-- 5. Объясните, что делает и оптимизируйте запрос

SELECT 
	Invoices.InvoiceID, 
	Invoices.InvoiceDate,
	(SELECT People.FullName
		FROM Application.People
		WHERE People.PersonID = Invoices.SalespersonPersonID
	) AS SalesPersonName,
	SalesTotals.TotalSumm AS TotalSummByInvoice, 
	(SELECT SUM(OrderLines.PickedQuantity*OrderLines.UnitPrice)
		FROM Sales.OrderLines
		WHERE OrderLines.OrderId = (SELECT Orders.OrderId 
			FROM Sales.Orders
			WHERE Orders.PickingCompletedWhen IS NOT NULL	
				AND Orders.OrderId = Invoices.OrderId)	
	) AS TotalSummForPickedItems
FROM Sales.Invoices 
	JOIN
	(SELECT InvoiceId, SUM(Quantity*UnitPrice) AS TotalSumm
	FROM Sales.InvoiceLines
	GROUP BY InvoiceId
	HAVING SUM(Quantity*UnitPrice) > 27000) AS SalesTotals
		ON Invoices.InvoiceID = SalesTotals.InvoiceID
ORDER BY TotalSumm DESC

-- --

TODO: напишите здесь свое решение
