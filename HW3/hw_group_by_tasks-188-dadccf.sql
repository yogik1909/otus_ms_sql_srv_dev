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
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

--TODO: напишите здесь свое решение

Select 
	DATEPART(YYYY, InvoiceDate) year
	,DATEPART(mm, InvoiceDate) month
	--, 
	,AVG(InvoiceLines.UnitPrice) avgPrice
	,Sum(InvoiceLines.UnitPrice * InvoiceLines.Quantity) sumCoast
From 
	Sales.Invoices Invoices
	JOIN Sales.InvoiceLines InvoiceLines
	ON 
	Invoices.InvoiceID = InvoiceLines.InvoiceID
Group by 
	DATEPART(YYYY, InvoiceDate)
	,DATEPART(mm, InvoiceDate)
order by 
	year, month

/*
2. Отобразить все месяцы, где общая сумма продаж превысила 10 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

--TODO: напишите здесь свое решение
Select 
	DATEPART(YYYY, InvoiceDate) year,
	DATEPART(mm, InvoiceDate) month
	,Sum(InvoiceLines.UnitPrice * InvoiceLines.Quantity) sumCoast
From 
	Sales.Invoices Invoices
	JOIN Sales.InvoiceLines InvoiceLines
	ON 
	Invoices.InvoiceID = InvoiceLines.InvoiceID
Group by 
	DATEPART(YYYY, InvoiceDate),
	DATEPART(mm, InvoiceDate)
Having Sum(InvoiceLines.UnitPrice * InvoiceLines.Quantity) > 10000
order by 
	year, month


/*
3. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/

Select 
	DATEPART(YYYY, InvoiceDate) year,
	DATEPART(mm, InvoiceDate) month,
	InvoiceLines.Description,
	Sum(InvoiceLines.UnitPrice * InvoiceLines.Quantity) sumCoast,
	MIN(InvoiceDate) firstDate,
	SUM(InvoiceLines.Quantity)

From 
	Sales.Invoices Invoices
	JOIN Sales.InvoiceLines InvoiceLines
	ON 
	Invoices.InvoiceID = InvoiceLines.InvoiceID

Group by 
	DATEPART(YYYY, InvoiceDate),
	DATEPART(mm, InvoiceDate),
	ROLLUP(InvoiceLines.Description)
Having SUM(InvoiceLines.Quantity) > 50
order by 
	year, month
	   
-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 2-3 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
