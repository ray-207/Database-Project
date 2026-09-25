CREATE DATABASE KoDesDB;
USE kodesdb;

CREATE TABLE Customers(
	CustomerID CHAR(5) PRIMARY KEY,
	CountryOrigin VARCHAR(100) NOT NULL
);

CREATE TABLE Items(
	StockCode CHAR(6) PRIMARY KEY,
	ItemDescription VARCHAR(100) NOT NULL,
	Price INT NOT NULL,
  CONSTRAINT price_check CHECK(Price > 0)
);

CREATE TABLE Invoices(
	InvoiceID CHAR(7) PRIMARY KEY,
	InvoiceDate DATETIME NOT NULL,
  CustomerID CHAR(5),
	FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE ItemOrder(
  ItemOrderID INT AUTO_INCREMENT PRIMARY KEY,
  Quantity INT NOT NULL,
  InvoiceID CHAR(7),
  StockCode CHAR(6),
  FOREIGN KEY (InvoiceID)
    REFERENCES Invoices(InvoiceID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  FOREIGN KEY (StockCode)
    REFERENCES Items(StockCode)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT check_quantity CHECK(Quantity != 0) -- You can't really buy an item with 0 amount, can you?
);