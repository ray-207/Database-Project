-- Update stock inventory upon making a transaction
DROP TRIGGER IF EXISTS stock_inventory_update;
DELIMITER $$
CREATE TRIGGER stock_inventory_update
AFTER INSERT ON ItemOrder
FOR EACH ROW
BEGIN
    UPDATE Items
    SET StockAvailable = StockAvailable - NEW.Quantity
    WHERE StockCode = NEW.StockCode
      AND StockAvailable >= NEW.Quantity;s

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Insufficient stock for this order';
    END IF;
END $$
DELIMITER ;

-- Contoh Trigger
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1; -- After ur done
SELECT	* FROM items
WHERE StockCode LIKE '21755';
INSERT INTO itemorder(Quantity, InvoiceID, StockCode) -- 13048
VALUES
 (5, '489434', '21755');

SELECT	* FROM items
WHERE StockCode LIKE '21755';

ROLLBACK;

-- A procedure
DROP PROCEDURE IF EXISTS GetCustomerInvoiceHistory;
DELIMITER $$
CREATE PROCEDURE GetCustomerInvoiceHistory(IN p_CustomerID CHAR(5))
BEGIN
    SELECT
        t1.InvoiceID,
        t1.InvoiceDate,
        SUM(t2.Quantity * t3.Price) AS `Net Total`
    FROM Invoices AS t1
    JOIN ItemOrder AS t2 ON t2.InvoiceID = t1.InvoiceID
    JOIN Items AS t3 ON t3.StockCode = t2.StockCode
    WHERE t1.CustomerID = p_CustomerID
    GROUP BY t1.InvoiceID, t1.InvoiceDate
    ORDER BY t1.InvoiceDate, t1.InvoiceID;
END $$
DELIMITER ;
CALL GetCustomerInvoiceHistory('13085'); -- Example CustomerID