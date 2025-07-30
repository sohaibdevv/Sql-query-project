-- ========================================
-- SmartShop Inventory System Initialization
-- ========================================

-- 1. Create Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName VARCHAR(100) NOT NULL,
    Category VARCHAR(50),
    Price DECIMAL(10,2) NOT NULL
);

-- 2. Create Inventory Table
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    StoreLocation VARCHAR(100) NOT NULL,
    StockLevel INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 3. Create Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY IDENTITY(1,1),
    SupplierName VARCHAR(100) NOT NULL
);

-- 4. Create Deliveries Table
CREATE TABLE Deliveries (
    DeliveryID INT PRIMARY KEY IDENTITY(1,1),
    SupplierID INT NOT NULL,
    ProductID INT NOT NULL,
    DeliveredDate DATE NOT NULL,
    QuantityDelivered INT NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 5. Create Sales Table
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    SaleDate DATE NOT NULL,
    StoreLocation VARCHAR(100) NOT NULL,
    UnitsSold INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Add indexes to improve join performance (should be after all tables are created)
CREATE INDEX idx_inventory_productid ON Inventory(ProductID);
CREATE INDEX idx_deliveries_productid ON Deliveries(ProductID);
CREATE INDEX idx_deliveries_supplierid ON Deliveries(SupplierID);
CREATE INDEX idx_sales_productid ON Sales(ProductID);

-- ========================================
-- Sample Data Insertion
-- ========================================

-- Suppliers
INSERT INTO Suppliers (SupplierName) VALUES 
('GlobalTech Supplies'),
('EcoSource Distributors'),
('Urban Retail Partners');

-- Products
INSERT INTO Products (ProductName, Category, Price) VALUES 
('Wireless Mouse', 'Electronics', 25.99),
('Bluetooth Speaker', 'Electronics', 49.99),
('Notebook', 'Stationery', 3.49),
('Desk Lamp', 'Home Decor', 19.99);

-- Inventory
INSERT INTO Inventory (ProductID, StoreLocation, StockLevel) VALUES 
(1, 'Downtown Store', 120),
(2, 'Downtown Store', 75),
(3, 'Uptown Store', 200),
(4, 'Uptown Store', 60);

-- Deliveries
INSERT INTO Deliveries (SupplierID, ProductID, DeliveredDate, QuantityDelivered) VALUES 
(1, 1, '2025-07-01', 150),
(2, 2, '2025-07-03', 100),
(3, 3, '2025-07-05', 250),
(1, 4, '2025-07-07', 80);

-- Sales
INSERT INTO Sales (ProductID, SaleDate, StoreLocation, UnitsSold) VALUES 
(1, '2025-07-10', 'Downtown Store', 30),
(2, '2025-07-11', 'Downtown Store', 20),
(3, '2025-07-12', 'Uptown Store', 50),
(4, '2025-07-13', 'Uptown Store', 15);

-- ========================================
-- Queries for Reporting and Analysis
-- ========================================

-- A. Retrieve Product Details with Stock Levels
SELECT 
    P.ProductName,
    P.Category,
    P.Price,
    I.StockLevel
FROM Products P
JOIN Inventory I ON P.ProductID = I.ProductID;

-- B. Track Product Sales by Date and Store
SELECT 
    P.ProductName,
    S.SaleDate,
    S.StoreLocation,
    S.UnitsSold
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID;

-- C. Join Products, Sales, and Suppliers for Performance Analysis
SELECT 
    P.ProductName,
    S.SaleDate,
    S.StoreLocation,
    S.UnitsSold,
    SP.SupplierName
FROM Sales S
JOIN Products P ON S.ProductID = P.ProductID
JOIN Deliveries D ON P.ProductID = D.ProductID
JOIN Suppliers SP ON D.SupplierID = SP.SupplierID
WHERE NOT EXISTS (
    SELECT 1 FROM Deliveries D2
    WHERE D2.ProductID = D.ProductID AND D2.DeliveredDate > D.DeliveredDate
);