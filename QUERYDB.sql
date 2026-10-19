
USE kodesdb;

LOAD DATA LOCAL INFILE 'C:/AOL DB/Database-Project/itemOrder.csv'
INTO TABLE itemorder
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(Quantity, InvoiceID, StockCode);

select COUNT(*) FROM itemorder;