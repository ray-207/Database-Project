-- Update stock inventory upon making a transaction or returning an item
DROP TRIGGER IF EXISTS stock_inventory_update;
DELIMITER $$
CREATE TRIGGER stock_inventory_update
AFTER INSERT ON ItemOrder
FOR EACH ROW
BEGIN
    IF LEFT(NEW.InvoiceID, 1) = 'C' THEN
        IF NEW.Quantity >= 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Return invoice quantity must be negative';
        END IF;

        UPDATE Items
        SET StockAvailable = StockAvailable + ABS(NEW.Quantity)
        WHERE StockCode = NEW.StockCode;
    ELSE
        IF NEW.Quantity <= 0  THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Sales invoice quantity must be positive';
        END IF;

        UPDATE Items
        SET StockAvailable = StockAvailable - NEW.Quantity
        WHERE StockCode = NEW.StockCode
          AND StockAvailable >= NEW.Quantity;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Insufficient stock for this order';
        END IF;
    END IF;
END $$
DELIMITER ;

-- Contoh Trigger (Purchase & Return)
START TRANSACTION;
SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1; -- After ur done

-- Simulating a purchase transaction
SELECT	* FROM items
WHERE StockCode LIKE '21755'; -- 13048 (StockAvailable before)
INSERT INTO itemorder(Quantity, InvoiceID, StockCode) 
VALUES
(5, '489434', '21755');

SELECT * FROM itemorder
WHERE `InvoiceID` LIKE '%489434';

SELECT	* FROM items
WHERE StockCode LIKE '21755'; -- 13043 (StockAvailabe offer)

-- Simulating a return of an item
INSERT INTO invoices(`InvoiceID`, `InvoiceDate`, `CustomerID`)
VALUES
('C489434', NOW(), '13085');
INSERT INTO itemorder(Quantity, InvoiceID, StockCode) 
VALUES
(-5, 'C489434', '21755');

SELECT	* FROM items
WHERE StockCode LIKE '21755'; -- 13048 (StockAvailable after return)
SELECT * FROM itemorder
WHERE InvoiceID LIKE '%489434';

-- COMMIT;
-- ROLLBACK;

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