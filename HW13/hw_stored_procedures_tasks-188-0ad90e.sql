/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.

Занятие "12 - Хранимые процедуры, функции, триггеры, курсоры".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

USE WideWorldImporters

/*
Во всех заданиях написать хранимую процедуру / функцию и продемонстрировать ее использование.
*/

/*
1) Написать функцию возвращающую Клиента с наибольшей суммой покупки.
*/

Create proc Website.GetTopOneCustomersPerson

AS
--Создадим временную таблицу с выборкой нужной информации, максимальная ссумма уплаченная клиентом
;WITH topCustomerTrans AS
(Select Top 1 
	CustomerID
From
	Sales.CustomerTransactions
Group By
	CustomerID
Order By Max(TransactionAmount) DESC)

--Выборка интересующих данных по клиенту
Select * 
From 
	Sales.Customers
Join topCustomerTrans
On Customers.CustomerID = topCustomerTrans.CustomerID

GO  

--Вызов созданной процедуры
EXECUTE Website.GetTopOneCustomersPerson

/*
2) Написать хранимую процедуру с входящим параметром СustomerID, выводящую сумму покупки по этому клиенту.
Использовать таблицы :
Sales.Customers
Sales.Invoices
Sales.InvoiceLines
*/

Create OR ALTER proc Website.GetAmountOnCustmer 
	@CustomerID int
	AS 
	Select Sum([InvoiceLines].Quantity * [InvoiceLines].UnitPrice) TotalAmoutPerCustomer
	FROM [Sales].[Invoices]
	JOIN [Sales].[InvoiceLines]
	ON [Invoices].InvoiceID = [InvoiceLines].InvoiceID
	Where CustomerID=@CustomerID
	GO 
Exec Website.GetAmountOnCustmer @CustomerID=834

/*
3) Создать одинаковую функцию и хранимую процедуру, посмотреть в чем разница в производительности и почему.
*/

Create function Website.GetAmountOnCustmerfn( 
	@CustomerID int)
	RETURNS int
	AS 
	begin
	--DECLARE @TotalAmoutPerCustomerRet int;
	return (Select Sum([InvoiceLines].Quantity * [InvoiceLines].UnitPrice)
	FROM [Sales].[Invoices]
	JOIN [Sales].[InvoiceLines]
	ON [Invoices].InvoiceID = [InvoiceLines].InvoiceID
	Where CustomerID=@CustomerID)
	
end

Declare @CustomerIDZ int
Set @CustomerIDZ = 595
Exec Website.GetAmountOnCustmer @CustomerID=@CustomerIDZ
Select Website.GetAmountOnCustmerfn(@CustomerIDZ)
--У меня нет ответа на вопрос кто производительнее и почему
/*
4) Создайте табличную функцию покажите как ее можно вызвать для каждой строки result set'а без использования цикла. 
*/
Create function Website.GetAmountOnCustmerTbl( 
	@CustomerID int)
	RETURNS TABLE
	AS 
	
	--DECLARE @TotalAmoutPerCustomerRet int;
	return (Select Sum([InvoiceLines].Quantity * [InvoiceLines].UnitPrice) AmountOnCustmer
	FROM [Sales].[Invoices]
	JOIN [Sales].[InvoiceLines]
	ON [Invoices].InvoiceID = [InvoiceLines].InvoiceID
	Where CustomerID=@CustomerID)
	
GO


SELECT CustomerID, CustomerSum.AmountOnCustmer

FROM [Sales].[Customers]

CROSS APPLY  Website.GetAmountOnCustmerTbl(Customers.CustomerID) AS CustomerSum
Where CustomerID IN (595, 864)

/*
5) Опционально. Во всех процедурах укажите какой уровень изоляции транзакций вы бы использовали и почему. 
*/
