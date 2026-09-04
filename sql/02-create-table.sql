CREATE TABLE online_retail (
 InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10,2),
    Revenue DECIMAL(12,2),
    CustomerID INT,
    Country VARCHAR(100)
);

-- IMPORT DATA CEPAT
LOAD DATA LOCAL INFILE 'C:/Users/ASUS/Downloads/customer-analysis-segmentation/data/cleaned/clean_online_retail_sql.csv'
INTO TABLE online_retail
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    Revenue,
    CustomerID,
    Country
);

-- CEK DATA HASIL IMPORT
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    COUNT(DISTINCT InvoiceNo) AS unique_invoices,
    COUNT(DISTINCT StockCode) AS unique_products,
    COUNT(DISTINCT Country) AS unique_countries
FROM online_retail;
