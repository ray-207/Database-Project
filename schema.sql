CREATE DATABASE KoDesDB;
USE kodesdb;

CREATE TABLE Customers(
	CustomerID CHAR(5) PRIMARY KEY,
	CountryOrigin VARCHAR(100) NOT NULL
);

CREATE TABLE Items(
	StockCode CHAR(7) PRIMARY KEY,
	ItemDescription VARCHAR(100) NOT NULL,
	CurrentPrice DECIMAL(10,2) NOT NULL,
  StockAvailable INT NOT NULL
  CONSTRAINT stock_available_check CHECK (StockAvailable >= 0),
  CONSTRAINT price_check CHECK(Price > 0)
);

CREATE TABLE ItemHistory(
  ItemHistoryID INT AUTO_INCREMENT PRIMARY KEY,
  StockCode CHAR(7) NOT NULL,
  PreviousPrice DECIMAL(10,2) NOT NULL,
  DateChanged DATETIME NOT NULL,
  FOREIGN KEY (StockCode)
    REFERENCES Items(StockCode)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE Invoices(
	InvoiceID CHAR(7) PRIMARY KEY,
	InvoiceDate DATETIME NOT NULL,
  CustomerID CHAR(5) NOT NULL,
	FOREIGN KEY (CustomerID)
    REFERENCES Customers(CustomerID)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE ItemOrder(
  InvoiceID CHAR(7) NOT NULL,
  StockCode CHAR(7) NOT NULL,
  Quantity INT NOT NULL,
  BoughtPrice DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (InvoiceID, StockCode), -- Composite key
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