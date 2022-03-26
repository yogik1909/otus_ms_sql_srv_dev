/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "06 - Оконные функции".

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
1. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года 
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки).
Выведите: id продажи, название клиента, дату продажи, сумму продажи, сумму нарастающим итогом

Пример:
-------------+----------------------------
Дата продажи | Нарастающий итог по месяцу
-------------+----------------------------
 2015-01-29   | 4801725.31
 2015-01-30	 | 4801725.31
 2015-01-31	 | 4801725.31
 2015-02-01	 | 9626342.98
 2015-02-02	 | 9626342.98
 2015-02-03	 | 9626342.98
Продажи можно взять из таблицы Invoices.
Нарастающий итог должен быть без оконной функции.
*/

--напишите здесь свое решение
;WITH TransactionAmountOnMonth_cte
(InvoiceDate
,TransactionAmount)
AS (Select 
Invoices.InvoiceDate
,Sum(CustomerTransactions.TransactionAmount) TransactionAmount
From 
	Sales.Invoices
	Join Sales.CustomerTransactions
	On Invoices.InvoiceID = CustomerTransactions.InvoiceID
Where Invoices.InvoiceDate > N'2015-01-01'
Group by Invoices.InvoiceDate)

, AccSumTrOnMonth_cte
AS (Select 
TransactionAmountOnMonth_cte.InvoiceDate
,SUM(TransactionAmountOnMonth_cte_.TransactionAmount) SumTrasaction
From 
	TransactionAmountOnMonth_cte
	Left Join TransactionAmountOnMonth_cte TransactionAmountOnMonth_cte_
	ON 	TransactionAmountOnMonth_cte.InvoiceDate >= TransactionAmountOnMonth_cte_.InvoiceDate
Group BY TransactionAmountOnMonth_cte.InvoiceDate
) 

Select
Invoices.InvoiceID
, Customers.CustomerName
, Invoices.InvoiceDate
,CustomerTransactions.TransactionAmount
, TransactionAmountOnMonth_cte.TransactionAmount TrnOnMoth
, AccSumTrOnMonth_cte.SumTrasaction SumTrnOnMouth
From 
	Sales.Invoices
	Join Sales.Customers
	on Invoices.CustomerID = Customers.CustomerID
	Join Sales.CustomerTransactions
	On Invoices.InvoiceID = CustomerTransactions.InvoiceID
	Join TransactionAmountOnMonth_cte
	On Invoices.InvoiceDate = TransactionAmountOnMonth_cte.InvoiceDate
	Join AccSumTrOnMonth_cte
	On Invoices.InvoiceDate = AccSumTrOnMonth_cte.InvoiceDate
Where Invoices.InvoiceDate > N'2015-01-01'

Order by InvoiceDate, OrderID

GO 




/*
2. Сделайте расчет суммы нарастающим итогом в предыдущем запросе с помощью оконной функции.
   Сравните производительность запросов 1 и 2 с помощью set statistics time, io on
*/

--напишите здесь свое решение
--Выглядит круто, но понимается струдом!
Select
Invoices.InvoiceID
, Customers.CustomerName
, Invoices.InvoiceDate
,CustomerTransactions.TransactionAmount
,SUM(CustomerTransactions.TransactionAmount) OVER (PARTITION BY Invoices.InvoiceDate ) TrnOnMoth
,SUM(CustomerTransactions.TransactionAmount) OVER (ORDER BY Invoices.InvoiceDate) SumTrnOnMouth
From 
	Sales.Invoices
	Join Sales.Customers
	on Invoices.CustomerID = Customers.CustomerID
	Join Sales.CustomerTransactions
	On Invoices.InvoiceID = CustomerTransactions.InvoiceID
Where Invoices.InvoiceDate > N'2015-01-01'
Order by InvoiceDate, OrderID


/*
3. Вывести список 2х самых популярных продуктов (по количеству проданных) 
в каждом месяце за 2016 год (по 2 самых популярных продукта в каждом месяце).
*/

--напишите здесь свое решение


	Select 
		Invoices.InvoiceDate
		,InvoiceLines.stockItemID
		,Sum(InvoiceLines.Quantity)
		,ROW_NUMBER() Over (partition by Invoices.InvoiceDate order by Sum(InvoiceLines.Quantity) Desc) Top_

	From
		Sales.InvoiceLines
		Join Sales.Invoices
		On InvoiceLines.InvoiceID = Invoices.InvoiceID
	Where Invoices.InvoiceDate between N'2016-01-01' and N'2016-12-31'
	Group by Invoices.InvoiceDate, InvoiceLines.stockItemID
	Order by Invoices.InvoiceDate, ROW_NUMBER() Over (partition by Invoices.InvoiceDate order by Sum(InvoiceLines.Quantity) Desc)




/*
4. Функции одним запросом
Посчитайте по таблице товаров (в вывод также должен попасть ид товара, название, брэнд и цена):
* пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
* посчитайте общее количество товаров и выведете полем в этом же запросе
* посчитайте общее количество товаров в зависимости от первой буквы названия товара
* отобразите следующий id товара исходя из того, что порядок отображения товаров по имени 
* предыдущий ид товара с тем же порядком отображения (по имени)
* названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
* сформируйте 30 групп товаров по полю вес товара на 1 шт

Для этой задачи НЕ нужно писать аналог без аналитических функций.
*/

--напишите здесь свое решение

/*
5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал.
   В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки.
*/

--напишите здесь свое решение


/*
6. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
*/

--напишите здесь свое решение

--Опционально можете для каждого запроса без оконных функций сделать вариант запросов с оконными функциями и сравнить их производительность. 