CREATE DATABASE KoDesDB;
USE kodesdb;

CREATE TABLE Customers(
	CustomerID CHAR(5) PRIMARY KEY,
	CountryOrigin VARCHAR(100) NOT NULL
);

CREATE TABLE Items(
	StockCode CHAR(5) PRIMARY KEY,
	ItemDescription VARCHAR(100) NOT NULL,
	Price INT NOT NULL,
  CONSTRAINT price_check CHECK(Price > 0)
);

CREATE TABLE Invoices(
	InvoiceID CHAR(6) PRIMARY KEY,
	InvoiceDate DATETIME NOT NULL,
  CustomerID CHAR(5),
	FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)
);

CREATE TABLE ItemOrder(
  ItemOrderID INT AUTO_INCREMENT PRIMARY KEY,
  Quantity INT NOT NULL,
  InvoiceID CHAR(6),
  StockCode CHAR(5),
  FOREIGN KEY (InvoiceID)
    REFERENCES Invoices(InvoiceID),
  FOREIGN KEY (StockCode)
    REFERENCES Items(StockCode),
  CONSTRAINT check_quantity CHECK(Quantity > 0)
);