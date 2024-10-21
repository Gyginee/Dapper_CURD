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