

IF OBJECT_ID('stg_dimcustomer', 'U') IS NOT NULL 
DROP TABLE stg_dimcustomer; 

GO
CREATE TABLE stg_dimcustomer (
    CustomerKey         INT PRIMARY KEY,
    Gender              NVARCHAR(50),
    Name                NVARCHAR(50),
    City                NVARCHAR(50),
    StateCode           NVARCHAR(50),
    State               NVARCHAR(50),
    ZipCode             NVARCHAR(50),
    Country             NVARCHAR(50),
    Continent           NVARCHAR(50),
    Birthday            NVARCHAR(50)
    
);


IF OBJECT_ID('dimcustomer', 'U') IS NOT NULL 
DROP TABLE dimcustomer; 

GO
CREATE TABLE dimcustomer (
    CustomerKey         INT PRIMARY KEY,
    Gender              NVARCHAR(50),
    Name                NVARCHAR(50),
    City                NVARCHAR(50),
    StateCode           NVARCHAR(50),
    State               NVARCHAR(50),
    ZipCode             NVARCHAR(50),
    Country             NVARCHAR(50),
    Continent           NVARCHAR(50),
    Birthday            DATE
);

GO

IF OBJECT_ID('stg_dimproduct', 'U') IS NOT NULL
    DROP TABLE stg_dimproduct;
GO

CREATE TABLE stg_dimproduct (
	ProductKey          INT PRIMARY KEY,
	ProductName         NVARCHAR(100),
	Brand               NVARCHAR(50),
	Color               NVARCHAR(50),
	UnitCostUSD         DECIMAL(10,3),
	UnitPriceUSD        DECIMAL(10,3),
	SubcategoryKey      INT,
	Subcategory         NVARCHAR(50),
	CategoryKey         INT,
	Category            NVARCHAR(50)
);
GO

IF OBJECT_ID('dimproduct', 'U') IS NOT NULL
    DROP TABLE dimproduct;
GO

CREATE TABLE dimproduct (
	ProductKey          INT PRIMARY KEY,
	ProductName         NVARCHAR(100),
	Brand               NVARCHAR(50),
	Color               NVARCHAR(50),
	UnitCostUSD         DECIMAL(10,3),
	UnitPriceUSD        DECIMAL(10,3),
	SubcategoryKey      INT,
	Subcategory         NVARCHAR(50),
	CategoryKey         INT,
	Category            NVARCHAR(50)
);
GO

IF OBJECT_ID('stg_dimstores', 'U') IS NOT NULL
    DROP TABLE stg_dimstores;
GO

CREATE TABLE stg_dimstores (
	StoreKey            INT PRIMARY KEY,
	Country		        NVARCHAR(50),
	State               NVARCHAR(50),
	Square_Meters       DECIMAL(8,2),
	OpenDate			NVARCHAR(50)
);

IF OBJECT_ID('dimstores', 'U') IS NOT NULL
    DROP TABLE dimstores;
GO

CREATE TABLE dimstores (
	StoreKey            INT PRIMARY KEY,
	Country		        NVARCHAR(50),
	State               NVARCHAR(50),
	Square_Meters       DECIMAL(8,2),
	OpenDate			DATE
);
GO

IF OBJECT_ID('stg_dimexcrates', 'U') IS NOT NULL
    DROP TABLE stg_dimexcrates;
GO

CREATE TABLE stg_dimexcrates (
	Date				NVARCHAR(50),
	Currency			NVARCHAR(10),
	Exchange			DECIMAL (8,4),
	
);
GO


IF OBJECT_ID('dimexcrates', 'U') IS NOT NULL
    DROP TABLE dimexcrates;
GO

CREATE TABLE dimexcrates (
	Date				DATE,
	Currency			NVARCHAR(10),
	Exchange			DECIMAL (8,4),
	
);
GO

IF OBJECT_ID('stg_sales', 'U') IS NOT NULL 
DROP TABLE stg_sales; 
GO
CREATE TABLE stg_sales (
    OrderNumber         INT,
    LineItem            INT,
    OrderDate           NVARCHAR(50),
    DeliveryDate        NVARCHAR(50),
    CustomerKey         INT,
    StorerKey           INT,
    ProductKey          INT,
    Quantity            INT,
    CurrencyCode        NVARCHAR(10),
);


IF OBJECT_ID('sales', 'U') IS NOT NULL 
DROP TABLE sales; 
GO
CREATE TABLE sales (
    OrderNumber         INT,
    LineItem            INT,
    OrderDate           DATE,
    DeliveryDate        DATE,
    CustomerKey         INT,
    StorerKey           INT,
    ProductKey          INT,
    Quantity            INT,
    CurrencyCode        NVARCHAR(10),
);

