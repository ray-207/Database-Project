USE kodesdb;

-- The line below is to enable local import. 
-- However, there may be additional settings you need to do at MySQL Workbench 8.0.* 
SET GLOBAL local_infile = ON; 

LOAD DATA LOCAL INFILE 'C:/your/path/to/customers.csv/here'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(CustomerID, CountryOrigin);


LOAD DATA LOCAL INFILE 'C:/your/path/to/invoice.csv/here'
INTO TABLE invoices
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(InvoiceID, InvoiceDate, CustomerID);

LOAD DATA LOCAL INFILE 'C:/your/path/to/items.csv/here'
INTO TABLE items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(StockCode, ItemDescription, Price);

LOAD DATA LOCAL INFILE 'C:/your/path/to/itemOrder.csv/here'
INTO TABLE itemorder
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Quantity, InvoiceID, StockCode);