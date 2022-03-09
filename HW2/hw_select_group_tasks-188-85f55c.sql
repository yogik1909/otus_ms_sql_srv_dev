/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

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
1. Все товары, в названии которых есть "urgent" или название начинается с "Animal".
Вывести: ИД товара (StockItemID), наименование товара (StockItemName).
Таблицы: Warehouse.StockItems.
*/

--TODO: напишите здесь свое решение
Select 
	StockItemID
	,StockItemName 
From Warehouse.StockItems
Where StockItemName Like N'Animal%' OR StockItemName Like N'%urgent%'

/*
2. Поставщиков (Suppliers), у которых не было сделано ни одного заказа (PurchaseOrders).
Сделать через JOIN, с подзапросом задание принято не будет.
Вывести: ИД поставщика (SupplierID), наименование поставщика (SupplierName).
Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders.
По каким колонкам делать JOIN подумайте самостоятельно.
*/

--TODO: напишите здесь свое решение

Select 
	sup.SupplierID
	, sup.SupplierName
From 
	Purchasing.Suppliers sup
	Left join Purchasing.PurchaseOrders ord
	on sup.SupplierID = ord.ContactPersonID
	Where ord.ContactPersonID IS NULL
		

/*
3. Заказы (Orders) с ценой товара (UnitPrice) более 100$ 
либо количеством единиц (Quantity) товара более 20 штук
и присутствующей датой комплектации всего заказа (PickingCompletedWhen).
Вывести:
* OrderID
* дату заказа (OrderDate) в формате ДД.ММ.ГГГГ
* название месяца, в котором был сделан заказ
* номер квартала, в котором был сделан заказ
* треть года, к которой относится дата заказа (каждая треть по 4 месяца)
* имя заказчика (Customer)
Добавьте вариант этого запроса с постраничной выборкой,
пропустив первую 1000 и отобразив следующие 100 записей.

Сортировка должна быть по номеру квартала, трети года, дате заказа (везде по возрастанию).

Таблицы: Sales.Orders, Sales.OrderLines, Sales.Customers.
*/

--TODO: напишите здесь свое решение
Select
	Ord.OrderID
	, Ord.OrderDate
	, FORMAT( Ord.OrderDate, 'dd.MM.yyyy') DateFormat
	, DATENAME(MONTH, Ord.OrderDate) DateName
	, DATENAME(QQ, Ord.OrderDate) DateQ 
	, DATEPART(mm, Ord.OrderDate) / 4 + 1 DateOfThird
	, cust.CustomerName
From
	Sales.Orders Ord
	Join Sales.OrderLines OrdLi
	on Ord.OrderID = OrdLi.OrderID
	AND (OrdLi.UnitPrice >= 100 Or OrdLi.Quantity > 200) AND OrdLi.PickingCompletedWhen IS NOT NULL
	Left join Sales.Customers cust
	on Ord.CustomerID = Cust.CustomerID
Order By Ord.OrderDate

	

/*
4. Заказы поставщикам (Purchasing.Suppliers),
которые должны быть исполнены (ExpectedDeliveryDate) в январе 2013 года
с доставкой "Air Freight" или "Refrigerated Air Freight" (DeliveryMethodName)
и которые исполнены (IsOrderFinalized).
Вывести:
* способ доставки (DeliveryMethodName)
* дата доставки (ExpectedDeliveryDate)
* имя поставщика
* имя контактного лица принимавшего заказ (ContactPerson)

Таблицы: Purchasing.Suppliers, Purchasing.PurchaseOrders, Application.DeliveryMethods, Application.People.
*/

--TODO: напишите здесь свое решение
Select
 DeliveryMethods.DeliveryMethodName
 ,PurOrd.ExpectedDeliveryDate
 ,SupplierName
 ,People.FullName
From
	Purchasing.PurchaseOrders PurOrd
	Join Application.DeliveryMethods
	ON PurOrd.DeliveryMethodID = DeliveryMethods.DeliveryMethodID
	AND DeliveryMethods.DeliveryMethodID IN (Select DeliveryMethodID From Application.DeliveryMethods Where DeliveryMethodName IN ('Air Freight', 'Refrigerated Air Freight')) 
	Join Purchasing.Suppliers 
	on PurOrd.SupplierID = Suppliers.SupplierID
	Join Application.People 
	On PurOrd.ContactPersonID = People.PersonID
	Where 
		PurOrd.IsOrderFinalized = 0x01 AND PurOrd.ExpectedDeliveryDate between N'2013-01-01' AND N'2013-01-31'  
	


/*
5. Десять последних продаж (по дате продажи) с именем клиента и именем сотрудника,
который оформил заказ (SalespersonPerson).
Сделать без подзапросов.
*/

--TODO: напишите здесь свое решение

Select top 10 

OrderID
,SaslPer.FullName
,CustPer.FullName
From
	Sales.Orders
	Join Application.People SaslPer
	on Orders.SalespersonPersonID = SaslPer.PersonID
	Join Application.People CustPer
	On Orders.ContactPersonID = CustPer.PersonID
order by 
Sales.Orders.OrderDate DESC
/*
6. Все ид и имена клиентов и их контактные телефоны,
которые покупали товар "Chocolate frogs 250g".
Имя товара смотреть в таблице Warehouse.StockItems.
*/

--TODO: напишите здесь свое решение
Select 
	pepl.PersonID
	, pepl.FullName,
	pepl.PhoneNumber
From 
	Application.People pepl
Join Sales.Orders ord
	Join Sales.OrderLines 
		Join Warehouse.StockItems
		ON OrderLines.StockItemID = StockItems.StockItemID
		AND StockItems.StockItemName = 'Chocolate frogs 250g'
	ON ord.OrderID = OrderLines.OrderID
ON pepl.PersonID = ord.CustomerID
