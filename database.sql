-- Create the Store Database
CREATE DATABASE StoreDapper;
GO

-- Use the Store Database
USE StoreDapper;
GO

--=======================TABLE

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

-- Create OrderDetails Table
CREATE TABLE OrderDetails (
    Id INT PRIMARY KEY IDENTITY, -- Khóa chính
    OrderId INT NOT NULL, -- ID của đơn hàng
    ProductId INT NOT NULL, -- ID của sản phẩm
    Quantity INT NOT NULL, -- Số lượng sản phẩm
    Price DECIMAL(18, 2) NOT NULL, -- Giá của sản phẩm tại thời điểm đặt hàng
    FOREIGN KEY (OrderId) REFERENCES Orders(Id), -- Khóa ngoại liên kết với bảng Orders
    FOREIGN KEY (ProductId) REFERENCES Products(Id) -- Khóa ngoại liên kết với bảng Products
);
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
GO

-- Create Discounts Table
CREATE TABLE Discounts (
    Id INT PRIMARY KEY IDENTITY,
    ProductId INT,
    DiscountPercentage DECIMAL(5, 2) NOT NULL,
    StartDate DATETIME NOT NULL,
    EndDate DATETIME NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(Id)
);
GO

-- Create Ratings Table
CREATE TABLE Ratings (
    Id INT PRIMARY KEY IDENTITY,
    ProductId INT,
    UserId INT, -- Assuming you have a Users table
    Rating DECIMAL(3, 2) CHECK (Rating >= 0 AND Rating <= 5),
    Review NVARCHAR(255), -- Optional review text
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (ProductId) REFERENCES Products(Id)
);
GO

--=======================END TABLE

--=======================STORED PROCEDURE

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

--GetCustomerByPhone
CREATE PROCEDURE GetCustomerByPhone
    @Phone NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
    Id,
    FirstName + ' ' + LastName AS FullName,
    Email,
    Phone,
    Address
    FROM Customers WHERE Phone = @Phone;
END
GO

--GetTotalPaymentMethod
CREATE PROCEDURE GetTotalPaymentMethod
    @PaymentMethod NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT COUNT(*) AS TotalPaymentMethod
    FROM Payments
    WHERE PaymentMethod = @PaymentMethod;
END
GO

--GetProductByTrackingNumber
CREATE PROCEDURE GetProductByTrackingNumber
    @TrackingNumber NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
    p.Name AS ProductName,
    o.Quantity AS OrderQuantity,
    o.OrderDate AS OrderDate,
    sh.Name AS ShipperName,
    sh.Phone AS ShipperPhone,
    s.ShipmentDate,
    s.Status
    FROM Shipments s
    JOIN Shippers sh ON s.ShipperId = sh.Id
    JOIN Orders o ON s.OrderId = o.Id
    JOIN Products p ON o.ProductId = p.Id
    WHERE s.TrackingNumber = @TrackingNumber;
END
GO

--GetProfitByProductByMonthFollowColumn
CREATE PROCEDURE GetProfitByProductByMonthFollowColumn
    @Month INT,
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Columns NVARCHAR(MAX);

    -- Get the list of days in the specified month to use as columns

	SELECT @Columns = STRING_AGG(QUOTENAME(OrderDay), ', ')
	FROM (
		SELECT DISTINCT DAY(OrderDate) AS OrderDay
		FROM Orders
		WHERE MONTH(OrderDate) = @Month AND YEAR(OrderDate) = @Year
	) AS Days;

    -- Dynamic SQL query
    SET @SQL = N'
    WITH ProfitData AS (
        SELECT 
            p.Name AS ProductName,
            DAY(o.OrderDate) AS Day, 
            COALESCE(SUM(o.Quantity * p.Price), 0) AS DailyProfit
        FROM Orders o
        JOIN Products p ON o.ProductId = p.Id
        WHERE MONTH(o.OrderDate) = @Month
        AND YEAR(o.OrderDate) = @Year
        GROUP BY p.Name, DAY(o.OrderDate)
    )

    -- Get Profit by Product by Day
    SELECT 
        ProductName, ' + @Columns + '
    FROM ProfitData
    PIVOT (
        SUM(DailyProfit)
        FOR Day IN (' + @Columns + ')
    ) AS ProductPivotTable;';

    EXEC sp_executesql @SQL, N'@Month INT, @Year INT', @Month, @Year;
END
GO

--GetProfitByProductByMonth (Dynamic SQL)
CREATE PROCEDURE GetProfitByProductByMonth
    @Month INT,
    @Year INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Columns NVARCHAR(MAX);

    --Get the list of product names to use as columns
    SELECT @Columns = STRING_AGG(QUOTENAME(Name), ', ')
    FROM Products;

    --Dynamic SQL query
    SET @SQL = N'
    WITH ProfitData AS (
        SELECT 
            p.Name AS ProductName,
            DAY(o.OrderDate) AS Day, 
            COALESCE(SUM(o.Quantity * p.Price), 0) AS DailyProfit
        FROM Orders o
        JOIN Products p ON o.ProductId = p.Id
        WHERE MONTH(o.OrderDate) = @Month
        AND YEAR(o.OrderDate) = @Year
        GROUP BY p.Name, DAY(o.OrderDate)
		--Clear Days without profit
        HAVING COALESCE(SUM(o.Quantity * p.Price), 0) > 0 
    )
    
    SELECT 
        Day, ' + @Columns + '
    FROM ProfitData
    PIVOT (
        SUM(DailyProfit)
        FOR ProductName IN (' + @Columns + ')
    ) AS ProductPivotTable;';

    EXEC sp_executesql @SQL, N'@Month INT, @Year INT', @Month, @Year;
END
GO


--GetRatingAVGByProductId
CREATE PROCEDURE GetRatingAVGByProductId
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT 
    p.Name AS ProductName,
    p.Price AS ProductPrice,
    c.Name AS CategoryName,
    AVG(r.Rating) AS AverageRating 
    FROM Ratings r
    JOIN Products p ON r.ProductId = p.Id
    JOIN Categories c ON p.CategoryId = c.Id
    WHERE r.ProductId = @Id
    GROUP BY p.Name, p.Price, c.Name
    ORDER BY AverageRating DESC;
END
GO

--SearchProduct
CREATE PROCEDURE SearchProduct
    @KeySearch NVARCHAR(256),
    @TypeSearch INT, --1: Tất cả, 2: Mức ưu đãi, 3: Đánh giá 
    @PageNumber INT, 
    @PageSize INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;

    IF(@TypeSearch = 1) --Tất cả
    BEGIN
        IF LEN(@KeySearch) = 0 --Tất cả
            BEGIN
                SELECT 
                    p.Name AS ProductName,
                    p.Price AS ProductPrice,
                    c.Name AS CategoryName,
                    d.DiscountPercentage AS DiscountPercentage,
                    (p.Price - (p.Price * d.DiscountPercentage / 100)) AS DiscountedPrice,
                    d.StartDate AS DiscountStartDate,
                    d.EndDate AS DiscountEndDate
                FROM Products p
                JOIN Categories c ON p.CategoryId = c.Id
                JOIN Discounts d ON p.Id = d.ProductId
                ORDER BY p.Name
                OFFSET @Offset ROWS
                FETCH NEXT @PageSize ROWS ONLY;
            END
            ELSE --Tìm kiếm theo tên
            BEGIN
                SELECT 
                    p.Name AS ProductName,
                    p.Price AS ProductPrice,
                    c.Name AS CategoryName,
                    d.DiscountPercentage AS DiscountPercentage,
                    (p.Price - (p.Price * d.DiscountPercentage / 100)) AS DiscountedPrice,
                    d.StartDate AS DiscountStartDate,
                    d.EndDate AS DiscountEndDate
                FROM Products p
                JOIN Categories c ON p.CategoryId = c.Id
                JOIN Discounts d ON p.Id = d.ProductId
                WHERE p.Name LIKE '%' + @KeySearch + '%'
                ORDER BY p.Name
                OFFSET @Offset ROWS
                FETCH NEXT @PageSize ROWS ONLY;
            END
    END
    IF(@TypeSearch = 2) --Mức ưu đãi
    BEGIN
        IF LEN(@KeySearch) = 0 --Tất cả
            BEGIN
                SELECT 
                    p.Name AS ProductName,
                    p.Price AS ProductPrice,
                    c.Name AS CategoryName,
                    d.DiscountPercentage AS DiscountPercentage,
                    (p.Price - (p.Price * d.DiscountPercentage / 100)) AS DiscountedPrice,
                    d.StartDate AS DiscountStartDate,
                    d.EndDate AS DiscountEndDate
                FROM Products p
                JOIN Categories c ON p.CategoryId = c.Id
                JOIN Discounts d ON p.Id = d.ProductId
                WHERE d.StartDate <= GETDATE() AND d.EndDate >= GETDATE()
                ORDER BY d.DiscountPercentage DESC
                OFFSET @Offset ROWS
                FETCH NEXT @PageSize ROWS ONLY;
            END
        ELSE --Tìm kiếm theo tên
            BEGIN
                SELECT 
                    p.Name AS ProductName,
                    p.Price AS ProductPrice,
                    c.Name AS CategoryName,
                    d.DiscountPercentage AS DiscountPercentage,
                    (p.Price - (p.Price * d.DiscountPercentage / 100)) AS DiscountedPrice,
                    d.StartDate AS DiscountStartDate,
                    d.EndDate AS DiscountEndDate
                FROM Products p
                JOIN Categories c ON p.CategoryId = c.Id
                JOIN Discounts d ON p.Id = d.ProductId
                WHERE p.Name LIKE '%' + @KeySearch + '%' AND d.StartDate <= GETDATE() AND d.EndDate >= GETDATE()
                ORDER BY d.DiscountPercentage DESC
                OFFSET @Offset ROWS
                FETCH NEXT @PageSize ROWS ONLY;
            END
    END
    IF(@TypeSearch = 3) --Đánh giá
    BEGIN
        IF LEN(@KeySearch) = 0 --Tất cả
            BEGIN
                SELECT 
                    p.Name AS ProductName,
                    p.Price AS ProductPrice,
                    c.Name AS CategoryName,
                    AVG(r.Rating) AS AverageRating
                FROM Ratings r
                JOIN Products p ON r.ProductId = p.Id
                JOIN Categories c ON p.CategoryId = c.Id
                GROUP BY p.Name, p.Price, c.Name
                ORDER BY AverageRating DESC
                OFFSET @Offset ROWS
                FETCH NEXT @PageSize ROWS ONLY;
            END
        ELSE --Tìm kiếm theo tên
            BEGIN
                SELECT 
                    p.Name AS ProductName,
                    p.Price AS ProductPrice,
                    c.Name AS CategoryName,
                    AVG(r.Rating) AS AverageRating
                FROM Ratings r
                JOIN Products p ON r.ProductId = p.Id
                JOIN Categories c ON p.CategoryId = c.Id
                WHERE p.Name LIKE '%' + @KeySearch + '%'
                GROUP BY p.Name, p.Price, c.Name
                ORDER BY AverageRating DESC
                OFFSET @Offset ROWS
                FETCH NEXT @PageSize ROWS ONLY;
            END
    END
END
GO

--Create Order
CREATE PROCEDURE CreateOrder
    @CustomerId INT,
    @ProductDetails NVARCHAR(MAX) -- JSON hoặc XML chứa thông tin sản phẩm và số lượng
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OrderId INT;
    DECLARE @ProductId INT;
    DECLARE @Quantity INT;
    DECLARE @Price DECIMAL(18, 2);
    DECLARE @TotalAmount DECIMAL(18, 2) = 0;

    -- Tạo đơn hàng mới
    INSERT INTO Orders (CustomerId, OrderDate)
    VALUES (@CustomerId, GETDATE());

    SET @OrderId = SCOPE_IDENTITY(); -- Lấy ID của đơn hàng vừa tạo

    -- Phân tích thông tin sản phẩm từ @ProductDetails
    -- Giả sử @ProductDetails là JSON: [{"ProductId": 1, "Quantity": 2}, {"ProductId": 2, "Quantity": 1}]
    DECLARE @ProductTable TABLE (ProductId INT, Quantity INT);

    INSERT INTO @ProductTable (ProductId, Quantity)
    SELECT ProductId, Quantity
    FROM OPENJSON(@ProductDetails)
    WITH (ProductId INT, Quantity INT);

    -- Duyệt qua từng sản phẩm để cập nhật đơn hàng
    DECLARE product_cursor CURSOR FOR
    SELECT ProductId, Quantity FROM @ProductTable;

    OPEN product_cursor;
    FETCH NEXT FROM product_cursor INTO @ProductId, @Quantity;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Lấy giá sản phẩm
        SELECT @Price = Price FROM Products WHERE Id = @ProductId;

        IF @Price IS NOT NULL AND @Quantity > 0
        BEGIN
            -- Tính tổng số tiền
            SET @TotalAmount = @TotalAmount + (@Price * @Quantity);

            -- Thêm chi tiết đơn hàng
            INSERT INTO OrderDetails (OrderId, ProductId, Quantity, Price)
            VALUES (@OrderId, @ProductId, @Quantity, @Price);
        END

        FETCH NEXT FROM product_cursor INTO @ProductId, @Quantity;
    END

    CLOSE product_cursor;
    DEALLOCATE product_cursor;

    -- Cập nhật tổng số tiền cho đơn hàng
    UPDATE Orders
    SET TotalAmount = @TotalAmount
    WHERE Id = @OrderId;

    SELECT @OrderId AS NewOrderId; -- Trả về ID của đơn hàng mới
END
GO

--


--=======================END STORED PROCEDURE

--=======================DATA

-- Insert Sample Data into Categories
INSERT INTO Categories (Name) VALUES 
('Electronics'),
('Clothing'),
('Groceries'),
('Books'),
('Home Appliances');
GO

-- Insert Sample Data into Products
INSERT INTO Products (Name, Price, CategoryId) VALUES 
('Laptop', 999.99, 1),
('Smartphone', 599.99, 1),
('T-shirt', 19.99, 2),
('Jeans', 39.99, 2),
('Apple', 0.99, 3),
('ApplePen', 8.99, 3),
('AppleWatch', 199.99, 3),
('AppleAirpods', 149.99, 3),
('Milk', 1.49, 3),
('Banana', 0.59, 3),
('Fiction Book', 14.99, 4),
('Blender', 29.99, 5),
('Smartwatch', 199.99, 1),  -- Electronics
('Headphones', 89.99, 1),   -- Electronics
('Jacket', 59.99, 2),       -- Clothing
('Sneakers', 79.99, 2),     -- Clothing
('Cereal', 3.99, 3),        -- Groceries
('Coffee', 7.99, 3),        -- Groceries
('Cookbook', 24.99, 4),     -- Books
('Vacuum Cleaner', 149.99, 5), -- Home Appliances
('Microwave Oven', 89.99, 5), -- Home Appliances
('Tablet', 299.99, 1);       -- Electronics
GO

-- Insert Sample Data into Orders
INSERT INTO Orders (ProductId, Quantity) VALUES 
(1, 2),  -- 2 Laptops
(3, 5),  -- 5 T-shirts
(5, 10), -- 10 Apples
(4, 10), -- 10 Apples
(12, 10), -- 10 Apples
(7, 10), -- 10 Apples
(8, 10), -- 10 Apples
(9, 10), -- 10 Apples
(2, 2),  -- 2 Laptops
(6, 5),  -- 5 T-shirts
(11, 10), -- 10 Apples
(13, 10), -- 10 Apples
(14, 10), -- 10 Apples
(15, 10), -- 10 Apples
(16, 10), -- 10 Apples
(17, 10); -- 10 Apples
GO

-- Insert Sample Data into Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES 
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Elm Street'),
('Jane', 'Smith', 'jane.smith@example.com', '555-555-5555', '456 Oak Avenue'),
('Michael', 'Brown', 'michael.brown@example.com', '789-456-1230', '789 Pine Road'),
('Emily', 'Johnson', 'emily.johnson@example.com', '234-567-8901', '321 Birch Lane'),
('David', 'Lee', 'david.lee@example.com', '987-654-3210', '654 Cedar Boulevard'),
('Sophia', 'Davis', 'sophia.davis@example.com', '345-678-9012', '987 Maple Drive'),
('William', 'Martinez', 'william.martinez@example.com', '567-890-1234', '111 Walnut Street'),
('Olivia', 'Garcia', 'olivia.garcia@example.com', '765-432-1098', '222 Spruce Avenue'),
('James', 'Wilson', 'james.wilson@example.com', '876-543-2109', '333 Redwood Street'),
('Isabella', 'Lopez', 'isabella.lopez@example.com', '654-321-0987', '444 Palm Court'),
('Liam', 'Smith', 'liam.smith@example.com', '111-222-3333', '123 Maple Street'),
('Emma', 'Johnson', 'emma.johnson@example.com', '222-333-4444', '456 Pine Avenue'),
('Noah', 'Williams', 'noah.williams@example.com', '333-444-5555', '789 Oak Boulevard'),
('Ava', 'Jones', 'ava.jones@example.com', '444-555-6666', '321 Birch Lane'),
('Oliver', 'Garcia', 'oliver.garcia@example.com', '555-666-7777', '654 Cedar Road');
GO

-- Insert Sample Data into Payments
INSERT INTO Payments (OrderId, PaymentMethod, Amount) VALUES 
(1, 'Credit Card', 1999.98),
(2, 'PayPal', 99.95),
(3, 'Debit Card', 9.90),
(4, 'Credit Card', 14.99),
(5, 'Cash', 29.90),
(6, 'PayPal', 59.98),
(7, 'Credit Card', 29.99),
(8, 'Debit Card', 299.99),
(9, 'Cash', 499.99),
(10, 'Credit Card', 19.99),
(11, 'Credit Card', 199.99),
(12, 'PayPal', 49.99),
(13, 'Debit Card', 19.90),
(14, 'Credit Card', 99.99),
(15, 'Cash', 59.90);
GO

-- Insert Sample Data into Shippers
INSERT INTO Shippers (Name, Phone, Email, Address) VALUES 
('Fast Delivery', '111-222-3333', 'info@fastdelivery.com', '101 First Avenue'),
('Speedy Shipping', '444-555-6666', 'contact@speedyshipping.com', '202 Second Street'),
('Express Logistics', '777-888-9999', 'support@expresslogistics.com', '303 Third Boulevard'),
('Reliable Couriers', '123-456-7890', 'service@reliablecouriers.com', '404 Fourth Lane'),
('Global Shippers', '555-666-7777', 'global@shippers.com', '505 Fifth Road'),
('Quick Transport', '888-999-0000', 'quick@transport.com', '606 Sixth Avenue'),
('Next Day Shipping', '999-888-7777', 'nextday@shipping.com', '707 Seventh Street'),
('Best Freight', '666-555-4444', 'info@bestfreight.com', '808 Eighth Boulevard'),
('Prime Shipping', '444-333-2222', 'prime@shipping.com', '909 Ninth Road'),
('Safe Cargo', '222-111-0000', 'contact@safecargo.com', '100 First Street'),
('Swift Shipping', '111-222-4444', 'info@swifshipping.com', '111 First Avenue'),
('Reliable Delivery', '222-333-5555', 'contact@reliabledelivery.com', '222 Second Street'),
('Express Delivery', '333-444-6666', 'support@expressdelivery.com', '333 Third Boulevard'),
('Quick Ship', '444-555-7777', 'service@quickship.com', '444 Fourth Lane');
GO

-- Insert Sample Data into Shipments
INSERT INTO Shipments (OrderId, ShipperId, TrackingNumber, Status) VALUES 
(1, 1, 'FD12345', 'Shipped'),
(2, 2, 'SS54321', 'Delivered'),
(3, 3, 'EL98765', 'In Transit'),
(4, 4, 'RC87654', 'Pending'),
(5, 5, 'GS76543', 'Delivered'),
(6, 6, 'QT65432', 'Shipped'),
(7, 7, 'ND54321', 'In Transit'),
(8, 8, 'BF43210', 'Pending'),
(9, 9, 'PS32109', 'Shipped'),
(10, 10, 'SC21098', 'Delivered'),
(11, 1, 'FD54321', 'Shipped'),
(12, 2, 'SS12345', 'Delivered'),
(13, 3, 'EL67890', 'In Transit'),
(14, 4, 'RC98765', 'Pending'),
(15, 5, 'GS54321', 'Delivered');
GO

-- Insert Sample Data into Discounts
INSERT INTO Discounts (ProductId, DiscountPercentage, StartDate, EndDate) VALUES 
(1, 10.00, '2023-01-01', '2023-01-31'), -- 10% off Laptop
(2, 15.00, '2023-02-01', '2023-02-28'), -- 15% off Smartphone
(3, 5.00, '2023-03-01', '2023-03-31'),  -- 5% off T-shirt
(4, 20.00, '2023-04-01', '2023-04-30'), -- 20% off Jeans
(5, 10.00, '2023-05-01', '2023-05-31'), -- 10% off Apple
(6, 15.00, '2023-06-01', '2023-06-30'), -- 15% off Milk
(7, 5.00, '2023-07-01', '2023-07-31'),  -- 5% off Banana
(8, 25.00, '2023-08-01', '2023-08-31'), -- 25% off Fiction Book
(9, 30.00, '2023-09-01', '2023-09-30'), -- 30% off Blender
(10, 20.00, '2023-10-01', '2023-10-31'), -- 20% off New Product
(11, 15.00, '2023-11-01', '2023-11-30'), -- 15% off Another Product
(12, 25.00, '2023-12-01', '2023-12-31');
GO

-- Insert Sample Data into Ratings
INSERT INTO Ratings (ProductId, UserId, Rating, Review) VALUES 
(1, 1, 4.5, 'Excellent laptop for work and gaming.'), -- Laptop
(1, 2, 4.0, 'Good performance but a bit heavy.'),     -- Laptop
(2, 3, 4.8, 'Best smartphone I have ever used!'),     -- Smartphone
(3, 4, 3.5, 'Decent quality for the price.'),         -- T-shirt
(4, 5, 4.2, 'Very comfortable jeans.'),                -- Jeans
(5, 6, 4.8, 'Fresh and delicious apples.'),            -- Apple
(6, 7, 4.0, 'Good quality milk, very creamy.'),        -- Milk
(7, 8, 3.8, 'Bananas were ripe and sweet.'),           -- Banana
(8, 9, 4.5, 'A great read, highly recommend!'),        -- Fiction Book
(9, 10, 4.7, 'Powerful blender, makes smoothies in seconds.'), -- Blender
(1, 1, 4.5, 'Excellent laptop for work and gaming.'),  -- Laptop
(1, 2, 4.0, 'Good performance but a bit heavy.'),      -- Laptop
(1, 3, 5.0, 'Best laptop I have ever owned!'),         -- Laptop
(2, 4, 4.8, 'Best smartphone I have ever used!'),      -- Smartphone
(2, 5, 4.5, 'Great features for the price.'),          -- Smartphone
(3, 6, 3.5, 'Decent quality for the price.'),          -- T-shirt
(3, 7, 4.0, 'Comfortable and stylish.'),                -- T-shirt
(4, 8, 4.2, 'Very comfortable jeans.'),                 -- Jeans
(4, 9, 4.0, 'Good fit and quality.'),                   -- Jeans
(5, 10, 4.8, 'Fresh and delicious apples.'),            -- Apple
(6, 1, 4.0, 'Good quality milk, very creamy.'),         -- Milk
(7, 2, 3.8, 'Bananas were ripe and sweet.'),            -- Banana
(8, 3, 4.5, 'A great read, highly recommend!'),         -- Fiction Book
(9, 4, 4.7, 'Powerful blender, makes smoothies in seconds.'), -- Blender
(9, 5, 4.9, 'Best blender I have ever used!'),
(10, 1, 4.5, 'Great new product, highly recommend!'), -- New Product
(11, 2, 4.0, 'Good value for the price.'),             -- Another Product
(12, 3, 5.0, 'Absolutely love this product!');           -- Blender
GO

--=======================END DATA