-- Create the Store Database
CREATE DATABASE StoreDapper;
GO

-- Use the Store Database
USE StoreDapper;
GO

-- Create Categories Table
CREATE TABLE Categories (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL
);
GO

-- Create Products Table
CREATE TABLE Products (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Price DECIMAL(18, 2) NOT NULL,
    CategoryId INT,
    FOREIGN KEY (CategoryId) REFERENCES Categories(Id)
);
GO

-- Create Orders Table
CREATE TABLE Orders (
    Id INT PRIMARY KEY IDENTITY,
    ProductId INT,
    Quantity INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (ProductId) REFERENCES Products(Id)
);
GO

-- Insert Sample Data into Categories
INSERT INTO Categories (Name) VALUES ('Electronics');
INSERT INTO Categories (Name) VALUES ('Clothing');
INSERT INTO Categories (Name) VALUES ('Groceries');
INSERT INTO Categories (Name) VALUES ('Books');
INSERT INTO Categories (Name) VALUES ('Home Appliances');

-- Insert Sample Data into Products
INSERT INTO Products (Name, Price, CategoryId) VALUES ('Laptop', 999.99, 1);
INSERT INTO Products (Name, Price, CategoryId) VALUES ('Smartphone', 599.99, 1);
INSERT INTO Products (Name, Price, CategoryId) VALUES ('T-shirt', 19.99, 2);
INSERT INTO Products (Name, Price, CategoryId) VALUES ('Jeans', 39.99, 2);
INSERT INTO Products (Name, Price, CategoryId) VALUES ('Apple', 0.99, 3);
INSERT INTO Products (Name, Price, CategoryId) VALUES ('Milk', 1.49, 3);
INSERT INTO Products (Name, Price, CategoryId) VALUES ('Banana', 0.59, 3);
INSERT INTO Products (Name, Price, CategoryId) VALUES ('Fiction Book', 14.99, 4);
INSERT INTO Products (Name, Price, CategoryId) VALUES ('Blender', 29.99, 5);

-- Insert Sample Data into Orders
INSERT INTO Orders (ProductId, Quantity) VALUES (1, 2);  -- 2 Laptops
INSERT INTO Orders (ProductId, Quantity) VALUES (3, 5);  -- 5 T-shirts
INSERT INTO Orders (ProductId, Quantity) VALUES (5, 10); -- 10 Apples
GO

-- Stored Procedure GetOrderDetailById
CREATE PROCEDURE GetOrderDetailById
    @Id INT
AS
BEGIN
    SELECT 
	o.Id AS OrderId,
	o.Quantity ,
	o.OrderDate,
	p.Id AS ProductId,
	p.Name AS ProductName,
	p.Price AS ProductPrice,
	c.Id AS CategoryId,
	c.Name AS CategoryName

	FROM Orders o
	JOIN Products p ON o.ProductId = p.Id
	JOIN Categories c ON p.CategoryId = c.Id
	WHERE 
	o.Id = @Id;
END
GO

-- Create Customers Table
CREATE TABLE Customers (
    Id INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Phone NVARCHAR(20),
    Address NVARCHAR(255)
);

-- Create Payments Table
CREATE TABLE Payments (
    Id INT PRIMARY KEY IDENTITY,
    OrderId INT,
    PaymentMethod NVARCHAR(50) NOT NULL,
    PaymentDate DATETIME NOT NULL DEFAULT GETDATE(),
    Amount DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (OrderId) REFERENCES Orders(Id)
);

-- Create Shippers Table
CREATE TABLE Shippers (
    Id INT PRIMARY KEY IDENTITY,
    Name NVARCHAR(100) NOT NULL,
    Phone NVARCHAR(20),
    Email NVARCHAR(100),
    Address NVARCHAR(255)
);

-- Create Shipments Table
CREATE TABLE Shipments (
    Id INT PRIMARY KEY IDENTITY,
    OrderId INT,
    ShipperId INT,
    ShipmentDate DATETIME NOT NULL DEFAULT GETDATE(),
    TrackingNumber NVARCHAR(100),
    Status NVARCHAR(50) NOT NULL,
    FOREIGN KEY (OrderId) REFERENCES Orders(Id),
    FOREIGN KEY (ShipperId) REFERENCES Shippers(Id)
);

-- Insert Sample Data into Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Elm Street');
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('Jane', 'Smith', 'jane.smith@example.com', '555-555-5555', '456 Oak Avenue');
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('Michael', 'Brown', 'michael.brown@example.com', '789-456-1230', '789 Pine Road');
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('Emily', 'Johnson', 'emily.johnson@example.com', '234-567-8901', '321 Birch Lane');
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('David', 'Lee', 'david.lee@example.com', '987-654-3210', '654 Cedar Boulevard');
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('Sophia', 'Davis', 'sophia.davis@example.com', '345-678-9012', '987 Maple Drive');
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('William', 'Martinez', 'william.martinez@example.com', '567-890-1234', '111 Walnut Street');
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('Olivia', 'Garcia', 'olivia.garcia@example.com', '765-432-1098', '222 Spruce Avenue');
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('James', 'Wilson', 'james.wilson@example.com', '876-543-2109', '333 Redwood Street');
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES ('Isabella', 'Lopez', 'isabella.lopez@example.com', '654-321-0987', '444 Palm Court');

-- Insert Sample Data into Payments
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES (1, 'Credit Card', 1999.98);
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES (2, 'PayPal', 99.95);
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES (3, 'Debit Card', 9.90);
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES (4, 'Credit Card', 14.99);
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES (5, 'Cash', 29.90);
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES (6, 'PayPal', 59.98);
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES (7, 'Credit Card', 29.99);
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES (8, 'Debit Card', 299.99);
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES (9, 'Cash', 499.99);
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES (10, 'Credit Card', 19.99);

-- Insert Sample Data into Shippers
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES ('Fast Delivery', '111-222-3333', 'info@fastdelivery.com', '101 First Avenue');
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES ('Speedy Shipping', '444-555-6666', 'contact@speedyshipping.com', '202 Second Street');
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES ('Express Logistics', '777-888-9999', 'support@expresslogistics.com', '303 Third Boulevard');
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES ('Reliable Couriers', '123-456-7890', 'service@reliablecouriers.com', '404 Fourth Lane');
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES ('Global Shippers', '555-666-7777', 'global@shippers.com', '505 Fifth Road');
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES ('Quick Transport', '888-999-0000', 'quick@transport.com', '606 Sixth Avenue');
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES ('Next Day Shipping', '999-888-7777', 'nextday@shipping.com', '707 Seventh Street');
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES ('Best Freight', '666-555-4444', 'info@bestfreight.com', '808 Eighth Boulevard');
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES ('Prime Shipping', '444-333-2222', 'prime@shipping.com', '909 Ninth Road');
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES ('Safe Cargo', '222-111-0000', 'contact@safecargo.com', '100 First Street');

-- Insert Sample Data into Shipments
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES (1, 1, 'FD12345', 'Shipped');
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES (2, 2, 'SS54321', 'Delivered');
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES (3, 3, 'EL98765', 'In Transit');
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES (4, 4, 'RC87654', 'Pending');
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES (5, 5, 'GS76543', 'Delivered');
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES (6, 6, 'QT65432', 'Shipped');
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES (7, 7, 'ND54321', 'In Transit');
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES (8, 8, 'BF43210', 'Pending');
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES (9, 9, 'PS32109', 'Shipped');
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES (10, 10, 'SC21098', 'Delivered');
GO

--Create Stored Procedure GetShipmentDetail
CREATE PROCEDURE GetShipmentDetail
    @Id INT 
AS
BEGIN 
SELECT 
    sp.Id AS ShipmentId,
    o.Id AS OrderId,
    p.Id AS ProductId,
    p.Name AS ProductName,
    p.Price AS ProductPrice,
    o.Quantity AS OrderQuantity,
    o.OrderDate AS OrderDate,
    s.Id AS ShipperId,
    s.Name AS ShipperName,
    s.Phone AS ShipperPhone,
    s.Email AS ShipperEmail,
    sp.ShipmentDate,
    sp.TrackingNumber,
    sp.Status
    
    FROM Shipments sp
    JOIN Orders o ON sp.OrderId = o.Id
    JOIN Products p ON o.ProductId = p.Id
    JOIN Shippers s ON sp.ShipperId = s.Id
    WHERE 
    sp.Id = @id
END 
GO

--Create Stored Procedure GetStatusShipmentDetail
CREATE PROCEDURE GetStatusShipmentDetail
    @Status NVARCHAR(15)
AS 
BEGIN
SELECT 
    *,
    sp.Id AS ShipmentId,
    o.Id AS OrderId,
    p.Id AS ProductId,
    p.Name AS ProductName,
    p.Price AS ProductPrice,
    o.Quantity AS OrderQuantity,
    o.OrderDate AS OrderDate,
    s.Id AS ShipperId,
    s.Name AS ShipperName,
    s.Phone AS ShipperPhone,
    s.Email AS ShipperEmail,
    sp.ShipmentDate,
    sp.TrackingNumber,
    sp.Status
    
    FROM Shipments sp
    JOIN Orders o ON sp.OrderId = o.Id
    JOIN Products p ON o.ProductId = p.Id
    JOIN Shippers s ON sp.ShipperId = s.Id
    WHERE 
    sp.Status = @Status
END
GO
    
--Create Stored Procedure SearchShipmentByDate
CREATE PROCEDURE SearchShipmentsByDate
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        sp.Id AS ShipmentId,
        o.Id AS OrderId,
        p.Name AS ProductName,
        s.Name AS ShipperName,
        sp.ShipmentDate,
        sp.Status
    FROM Shipments sp
    JOIN Orders o ON sp.OrderId = o.Id
    JOIN Products p ON o.ProductId = p.Id
    JOIN Shippers s ON sp.ShipperId = s.Id
    WHERE sp.ShipmentDate BETWEEN @StartDate AND @EndDate
    ORDER BY sp.ShipmentDate DESC;
END
GO

--DeletePendingShipment
CREATE PROCEDURE DeletePendingShipment
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM Shipments WHERE Id = @Id AND Status = 'Pending')
    BEGIN
        DELETE FROM Shipments WHERE Id = @Id;
    END
END
GO

--GetShipmentWithPagination
CREATE PROCEDURE GetShipmentWithPagination
    @PageNumber INT,
    @PageSize INT
AS
BEGIN
    SET NOCOUNT ON;
    
    --Generate Offset
    DECLARE @Offset INT  = (@PageNumber - 1) * @PageSize;

    SELECT 
        sp.Id AS ShipmentId,
        o.Id AS OrderId,
        p.Id AS ProductId,
        p.Name AS ProductName,
        p.Price AS ProductPrice,
        o.Quantity AS OrderQuantity,
        o.OrderDate AS OrderDate,
        s.Id AS ShipperId,
        s.Name AS ShipperName,
        s.Phone AS ShipperPhone,
        sp.ShipmentDate,
        sp.TrackingNumber,
        sp.Status
    FROM Shipments sp
    JOIN Orders o ON sp.OrderId = o.Id
    JOIN Products p ON o.ProductId = p.Id
    JOIN Shippers s ON sp.ShipperId = s.Id
    ORDER BY sp.ShipmentDate DESC

    --Pagination
    OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
END
GO

--GetTotalSalesByDateRange
CREATE PROCEDURE GetTotalSalesByDateRange
    @Startdate DATE,
    @Enddate DATE
AS
BEGIN
    SELECT SUM( o.Quantity * p.Price ) AS TotalSales
    FROM Orders o
    JOIN Products p ON o.ProductId = p.Id
    WHERE 
    o.OrderDate BETWEEN @Startdate AND @Enddate;
END
GO

--GetTopSellingProduct
CREATE PROCEDURE GetTopSellingProduct
    @TopNumber INT
AS
BEGIN
    SELECT TOP(@TopNumber)
    p.Name AS ProductName,
    SUM(o.Quantity) AS TotalQuantitySold
    FROM Orders o
    JOIN Products p ON o.ProductId = p.Id
    GROUP BY p.Name
    ORDER BY TotalQuantitySold DESC;
END
GO

--GetShipperOrderDetails
CREATE PROCEDURE GetShipperOrderDetails
    @Id INT
AS
BEGIN
    SELECT
        o.Id AS OrderId,
        o.OrderDate,
        p.Name AS ProductName,
        o.Quantity,
        s.ShipmentDate,
        s.Status
    FROM Orders o
    JOIN Shipments s ON o.Id = s.Id
    JOIN Products p ON o.ProductId = p.Id
    WHERE s.ShipperId = @Id;
END
GO
    