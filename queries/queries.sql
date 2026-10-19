use kodesdb;

-- Query 1
START TRANSACTION;

UPDATE Items
SET Price = Price * 1.08
WHERE Price < 5.00;

COMMIT;

-- Query 2
START TRANSACTION;

UPDATE Invoices
SET InvoiceID = CONCAT('C', InvoiceID)
WHERE InvoiceID = '536365';

UPDATE ItemOrder
SET Quantity = Quantity * -1
WHERE InvoiceID = 'C536365';

COMMIT;

-- Query 3:
SELECT 
    c.CountryOrigin,
    COUNT(DISTINCT i.InvoiceID) AS TotalCompletedInvoices,
    SUM(io.Quantity * t.Price) AS TotalSalesRevenue
FROM Customers c
INNER JOIN Invoices i ON c.CustomerID = i.CustomerID
INNER JOIN ItemOrder io ON i.InvoiceID = io.InvoiceID
INNER JOIN Items t ON io.StockCode = t.StockCode
WHERE i.InvoiceID NOT LIKE 'C%'
GROUP BY c.CountryOrigin
ORDER BY TotalSalesRevenue DESC;

-- Query 4:
SELECT 
    t1.CustomerID, 
    t1.CountryOrigin,
    SUM(t3.Quantity * t4.Price) AS `Total Spent`
FROM Customers t1
INNER JOIN Invoices t2 ON t1.CustomerID = t2.CustomerID
INNER JOIN ItemOrder t3 ON t2.InvoiceID = t3.InvoiceID
INNER JOIN Items t4 ON t4.StockCode = t3.StockCode
WHERE t2.InvoiceID NOT LIKE 'C%'
GROUP BY t1.CustomerID, t1.CountryOrigin
HAVING `Total Spent` > ( 
    SELECT AVG(customer_spending) 
    FROM (
        SELECT SUM(t2_sub.Quantity * t3_sub.Price) AS customer_spending
        FROM Invoices t1_sub
        INNER JOIN ItemOrder t2_sub ON t1_sub.InvoiceID = t2_sub.InvoiceID
        INNER JOIN Items t3_sub ON t2_sub.StockCode = t3_sub.StockCode
        WHERE t1_sub.InvoiceID NOT LIKE 'C%'
        GROUP BY t1_sub.CustomerID
    ) AS avg_table
)
ORDER BY `Total Spent` DESC;

-- Query 5:
SELECT 
    t1.StockCode,
    t5.ItemDescription,
    GROUP_CONCAT(DISTINCT t4.CountryOrigin ORDER BY t4.CountryOrigin SEPARATOR ', ') AS `Countries Sold To`
FROM ItemOrder t1
INNER JOIN Invoices t3 ON t1.InvoiceID = t3.InvoiceID
INNER JOIN Customers t4 ON t3.CustomerID = t4.CustomerID
INNER JOIN Items t5 ON t1.StockCode = t5.StockCode
WHERE t3.InvoiceID NOT LIKE 'C%'
GROUP BY t1.StockCode, t5.ItemDescription
HAVING 
    SUM(CASE WHEN t4.CountryOrigin = 'Germany' THEN 1 ELSE 0 END) = 0
    AND COUNT(DISTINCT t4.CountryOrigin) >= 2;
